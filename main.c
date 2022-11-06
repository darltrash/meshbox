#include "lib/sokol_app.h"
#include "lib/sokol_gfx.h"
#include "lib/sokol_glue.h"
#include "lib/minilua.h"
#include "lib/stb_image.h"
#include "lib/map.h"
#include "lib/log.h"
#include "lua.h"

#include "meshbox.h"
#include "shader.h"

#include "math.h"
#include "fs.h"

sg_pipeline pip;
sg_bindings bind;
sg_pass_action pass_action;

int vx_size    = 0;
int vx_current = 0;
int vx_buffer  = 0;

map_t(sg_image) tx_images;
sg_image tx_current;
sg_image tx_clear;

int vx_index_offset;
int vx_vertex_offset;
vertex vx_current_vertex;
vertex vx_raw_vertices[VX_BUFFER_SIZE];
vs_uniforms_t vs_uniforms = {};
fs_uniforms_t fs_uniforms = {};

static void init(void) {
    sg_setup(&(sg_desc){
        .context = sapp_sgcontext()
    });

    map_init(&tx_images);

    uint32_t pixel = 0xFFFFFFFF;

    tx_clear = sg_make_image(&(sg_image_desc){
        .width = 1,
        .height = 1,
        .wrap_u = SG_WRAP_REPEAT,
        .wrap_v = SG_WRAP_REPEAT,
        .data.subimage[0][0] = SG_RANGE(pixel)
    });
    tx_current = tx_clear;

    bind.vertex_buffers[0] = sg_make_buffer(&(sg_buffer_desc){
        .size = sizeof(vx_raw_vertices),
        .usage = SG_USAGE_DYNAMIC,
        .type = SG_BUFFERTYPE_VERTEXBUFFER
    });

    bind.index_buffer = sg_make_buffer(&(sg_buffer_desc){
        .size = VX_BUFFER_SIZE * 3 * sizeof(uint32_t),
        .usage = SG_USAGE_DYNAMIC,
        .type = SG_BUFFERTYPE_INDEXBUFFER
    });

    sg_shader shd = sg_make_shader(triangle_shader_desc(sg_query_backend()));

    // TODO: Fix depth buffer not doing anything at all.
    // TODO [NOV 5]: what the fuck
    pip = sg_make_pipeline(&(sg_pipeline_desc){
        .shader = shd,
        .layout = {
            .attrs = {
                [ATTR_vs_vx_position].format = SG_VERTEXFORMAT_FLOAT3,
                [ATTR_vs_vx_normal].format = SG_VERTEXFORMAT_FLOAT3,
                [ATTR_vs_vx_texcoord].format = SG_VERTEXFORMAT_FLOAT2,
                [ATTR_vs_vx_color].format = SG_VERTEXFORMAT_FLOAT4
            }
        },

        .index_type = SG_INDEXTYPE_UINT32,
        .cull_mode = SG_CULLMODE_BACK,

        .depth = {
            .write_enabled = true,
            .compare = SG_COMPAREFUNC_LESS_EQUAL,
        },

        .label = "pipeline"
    });

    pass_action = (sg_pass_action) {
        .colors[0] = { 
            .action = SG_ACTION_CLEAR, 
            .value = { 0.0f, 0.0f, 0.0f, 1.0f } 
        }
    };
}

// Texture binding functions.
    void tx_bind(const char *file) {
        if (file == NULL) {
            bind.fs_images[0] = tx_clear;
            return;
        }

        sg_image *t = map_get(&tx_images, file);
        if (t) {
            bind.fs_images[0] = *t;
            return;
        }

        log_info("Loading '%s'", file);

        FILE *f = fopen(file, "rb");

        int w, h, c;
        stbi_set_flip_vertically_on_load(1);
        void *d = stbi_load_from_file(f, &w, &h, &c, 4);

        sg_image i = sg_make_image(&(sg_image_desc) {
            .width  = w,
            .height = h,

            .wrap_u = SG_WRAP_REPEAT,
            .wrap_v = SG_WRAP_REPEAT,

            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .min_filter = SG_FILTER_NEAREST,
            .mag_filter = SG_FILTER_NEAREST,

            .data.subimage[0][0] = {
                .ptr = d,
                .size = (size_t)(w * h * 4),
            }
        });

        map_set(&tx_images, file, i);

        fclose(f);

        bind.fs_images[0] = i;
    }

// Matrix functions.
    matrix *mx_current = NULL;

    int mx_mode(int mode) {
        switch (mode) {
            case MATRIX_MODE_MODEL:
                mx_current = &vs_uniforms.model;
            break;

            case MATRIX_MODE_VIEW:
                mx_current = &vs_uniforms.view;
            break;

            case MATRIX_MODE_PROJECTION:
                mx_current = &vs_uniforms.projection;
            break;

            default: 
                return 1;
                break;
        }
        return 0;
    }

    void mx_identity() {
        memcpy(mx_current, &matrix_identity, sizeof(matrix));
    }

    void mx_set(matrix m) {
        memcpy(mx_current, &m, sizeof(matrix));
    }

    matrix mx_get() {
        return *mx_current;
    }

    void mx_perspective(float fov, float near, float far) {
        mx_identity();

        float t = tanf(fov * (PI / 180.0f) * 0.5f);
        float aspect = sapp_widthf()/sapp_heightf();

        mx_current->data[0]  =  1.0f / (t * aspect);
        mx_current->data[5]  =  1.0f / t;
        mx_current->data[10] = -(far + near) / (far - near);
        mx_current->data[11] = -1.0;
        mx_current->data[14] = -(2.0 * far * near) / (far - near);
        mx_current->data[15] =  0.0;
    }

    void mx_orthographic(float near, float far) {
        mx_identity();

        float right = sapp_widthf();
        float bottom = sapp_heightf();

        mx_current->data[0]    =  2.0 / right;
        mx_current->data[5]    =  2.0 / -bottom;
        mx_current->data[10]   = -2.0 / (far - near);
        mx_current->data[12]   = -1.0;
        mx_current->data[13]   = -(bottom / -bottom);
        mx_current->data[14]   = -((far + near) / (far - near));
        mx_current->data[15]   =  1.0;
    }

    void mx_multiply(matrix m) {
        matrix o = matrix_identity; 

        o.data[0]  = m.data[0]  * mx_current->data[0] + m.data[1]  * mx_current->data[4] + m.data[2]  * mx_current->data[8]  + m.data[3]  * mx_current->data[12];
        o.data[1]  = m.data[0]  * mx_current->data[1] + m.data[1]  * mx_current->data[5] + m.data[2]  * mx_current->data[9]  + m.data[3]  * mx_current->data[13];
        o.data[2]  = m.data[0]  * mx_current->data[2] + m.data[1]  * mx_current->data[6] + m.data[2]  * mx_current->data[10] + m.data[3]  * mx_current->data[14];
        o.data[3]  = m.data[0]  * mx_current->data[3] + m.data[1]  * mx_current->data[7] + m.data[2]  * mx_current->data[11] + m.data[3]  * mx_current->data[15];
        o.data[4]  = m.data[4]  * mx_current->data[0] + m.data[5]  * mx_current->data[4] + m.data[6]  * mx_current->data[8]  + m.data[7]  * mx_current->data[12];
        o.data[5]  = m.data[4]  * mx_current->data[1] + m.data[5]  * mx_current->data[5] + m.data[6]  * mx_current->data[9]  + m.data[7]  * mx_current->data[13];
        o.data[6]  = m.data[4]  * mx_current->data[2] + m.data[5]  * mx_current->data[6] + m.data[6]  * mx_current->data[10] + m.data[7]  * mx_current->data[14];
        o.data[7]  = m.data[4]  * mx_current->data[3] + m.data[5]  * mx_current->data[7] + m.data[6]  * mx_current->data[11] + m.data[7]  * mx_current->data[15];
        o.data[8]  = m.data[8]  * mx_current->data[0] + m.data[9]  * mx_current->data[4] + m.data[10] * mx_current->data[8]  + m.data[11] * mx_current->data[12];
        o.data[9]  = m.data[8]  * mx_current->data[1] + m.data[9]  * mx_current->data[5] + m.data[10] * mx_current->data[9]  + m.data[11] * mx_current->data[13];
        o.data[10] = m.data[8]  * mx_current->data[2] + m.data[9]  * mx_current->data[6] + m.data[10] * mx_current->data[10] + m.data[11] * mx_current->data[14];
        o.data[11] = m.data[8]  * mx_current->data[3] + m.data[9]  * mx_current->data[7] + m.data[10] * mx_current->data[11] + m.data[11] * mx_current->data[15];
        o.data[12] = m.data[12] * mx_current->data[0] + m.data[13] * mx_current->data[4] + m.data[14] * mx_current->data[8]  + m.data[15] * mx_current->data[12];
        o.data[13] = m.data[12] * mx_current->data[1] + m.data[13] * mx_current->data[5] + m.data[14] * mx_current->data[9]  + m.data[15] * mx_current->data[13];
        o.data[14] = m.data[12] * mx_current->data[2] + m.data[13] * mx_current->data[6] + m.data[14] * mx_current->data[10] + m.data[15] * mx_current->data[14];
        o.data[15] = m.data[12] * mx_current->data[3] + m.data[13] * mx_current->data[7] + m.data[14] * mx_current->data[11] + m.data[15] * mx_current->data[15];
    
        mx_set(o);
    }

    static void _normalize(
        float x, float y, float z, 
        float *ox, float *oy, float *oz
    ) {
        float l = sqrtf(powf(x, 2.0f) + powf(y, 2.0f) + powf(z, 2.0f));
        *ox = x/l;
        *oy = y/l;
        *oz = z/l;
    }

    static void _cross(
        float  ax, float  ay, float  az, 
        float  bx, float  by, float  bz, 
        float *ox, float *oy, float *oz
    ) {
        *ox = ay * bz - az * by;
        *oy = az * bx - ax * bz;
        *oz = ax * by - ay * bx;
    }

    void mx_look_at(
        float ex, float ey, float ez, 
        float ax, float ay, float az, 
        float ux, float uy, float uz
    ) {
        float zx, zy, zz;
        _normalize(
            ex - ax,
            ey - ay,
            ez - az,
            &zx, &zy, &zz
        );

        float xx, xy, xz;
        float _x, _y, _z;
        _cross(
            ux, uy, uz,
            zx, zy, zz,
            &_x, &_y, &_z
        );
        _normalize(_x, _y, _z, &xx, &xy, &xz);

        float yx, yy, yz;
        _cross(
            zx, zy, zz,
            xx, xy, xz,
            &yx, &yy, &yz
        );

        matrix o = matrix_identity;
        
        o.data[0]  = xx;
	    o.data[1]  = yx;
	    o.data[2]  = zx;
	    o.data[3]  = 0;
	    o.data[4]  = xy;
	    o.data[5]  = yy;
	    o.data[6]  = zy;
	    o.data[7]  = 0;
	    o.data[8]  = xz;
	    o.data[9]  = yz;
	    o.data[10] = zz;
	    o.data[11] = 0;
        o.data[12] = -o.data[0]*ex - o.data[4]*ey - o.data[ 8]*ez;
        o.data[13] = -o.data[1]*ex - o.data[5]*ey - o.data[ 9]*ez;
        o.data[14] = -o.data[2]*ex - o.data[6]*ey - o.data[10]*ez;
        o.data[15] = -o.data[3]*ex - o.data[7]*ey - o.data[11]*ez + 1.0f;

        mx_set(o);
    }

    void mx_translate(float x, float y, float z) {
        matrix o = matrix_identity;
        o.data[12] = x;
        o.data[13] = y;
        o.data[14] = z;

        mx_multiply(o);
    }

    void mx_rotate(float a, float x, float y, float z) {
        matrix o = matrix_identity;

        float tx, ty, tz;
        _normalize(x, y, z, &tx, &ty, &tz);

        float c = cosf(a);
        float s = sinf(a);

        o.data[0]  = tx * tx * (1 - c) + c;
        o.data[1]  = ty * tx * (1 - c) + tz * s;
        o.data[2]  = tx * tz * (1 - c) - ty * s;
        o.data[4]  = tx * ty * (1 - c) - tz * s;
        o.data[5]  = ty * ty * (1 - c) + c;
        o.data[6]  = ty * tz * (1 - c) + tx * s;
        o.data[8]  = tx * tz * (1 - c) + ty * s;
        o.data[9]  = ty * tz * (1 - c) - tx * s;
        o.data[10] = tz * tz * (1 - c) + c;

        mx_multiply(o);
    }

    void mx_euler(float x, float y, float z) {
        mx_rotate(x, 1.0f, 0.0f, 0.0f);
        mx_rotate(y, 0.0f, 1.0f, 0.0f);
        mx_rotate(z, 0.0f, 0.0f, 1.0f);
    }

    void mx_scale(float x, float y, float z) {
        matrix o = matrix_identity;
        o.data[0]  = x;
        o.data[5]  = y;
        o.data[10] = z;
        
        mx_multiply(o);
    }

// Vertex functions.
    void vx_normal(float x, float y, float z) {
        vx_current_vertex.nx = x;
        vx_current_vertex.ny = y;
        vx_current_vertex.nz = z;
    }

    void vx_texcoord(float u, float v) {
        vx_current_vertex.u = u;
        vx_current_vertex.v = v;
    }

    void vx_color(float r, float g, float b, float a) {
        vx_current_vertex.r = r;
        vx_current_vertex.g = g;
        vx_current_vertex.b = b;
        vx_current_vertex.a = a;
    }

    void vx_vertex(float x, float y, float z) {
        vx_current_vertex.x = x;
        vx_current_vertex.y = y;
        vx_current_vertex.z = z;

        vx_raw_vertices[vx_current] = vx_current_vertex;
        vx_current++;
        vx_size++;
    }

    void vx_load(vertex *vertices, unsigned int amount) {
        memcpy(&vx_raw_vertices[vx_current], vertices, sizeof(vertex) * amount);
        vx_current += amount;
        vx_size += amount;
    }

    void vx_render(uint32_t *indices, unsigned int amount) {
        sg_append_buffer(bind.vertex_buffers[0], &(sg_range){
            .ptr = &vx_raw_vertices,
            .size = sizeof(vertex) * vx_current
        });

        int a = amount;
        uint32_t *d = indices;

        if (!a) {
            a = vx_current;

            uint32_t n[a]; 
            for (int i=0; i < a; i++) {
                n[i] = i;
            }

            d = &n;

            vx_current_vertex = vertex_default;
        }

        sg_append_buffer(bind.index_buffer, &(sg_range){
            .ptr = d,
            .size = a * sizeof(uint32_t)
        });

        sg_apply_uniforms(SG_SHADERSTAGE_VS, SLOT_vs_uniforms, &SG_RANGE(vs_uniforms));
        sg_apply_uniforms(SG_SHADERSTAGE_FS, SLOT_fs_uniforms, &SG_RANGE(fs_uniforms));

        sg_apply_bindings(&bind);
        sg_draw(0, a, 1);

        bind.vertex_buffer_offsets[0] += sizeof(vertex)   * vx_size;
        bind.index_buffer_offset      += sizeof(uint32_t) * a;

        vx_current = 0;
        vx_size    = 0;
    };

// General graphics functions
    void gx_background(float r, float g, float b, float a) {
        pass_action.colors[0].value = (sg_color){ r, g, b, a };
    }

    void gx_ambient(float r, float g, float b, float a) {
        fs_uniforms.ambient[0] = r;
        fs_uniforms.ambient[1] = g;
        fs_uniforms.ambient[2] = b;
        fs_uniforms.ambient[3] = a;
    }

    void gx_reset() {
        fs_uniforms.light_amounts = 0;
    }

    void gx_light(
        int type,
        float x, float y, float z,
        float r, float g, float b
    ) {
        int i = fs_uniforms.light_amounts;

        fs_uniforms.light_color[i][0] = r;
        fs_uniforms.light_color[i][1] = g;
        fs_uniforms.light_color[i][2] = b;

        fs_uniforms.light_position[i][0] = x;
        fs_uniforms.light_position[i][1] = y;
        fs_uniforms.light_position[i][2] = z;
        fs_uniforms.light_position[i][3] = (float)(type);

        fs_uniforms.light_amounts = (i + 1) % GX_LIGHT_AMOUNT;
    }

void frame(void) {
    mx_current = &vs_uniforms.projection;

    tx_bind(NULL);
    gx_reset();
    gx_ambient(1.0f, 1.0f, 1.0f, 1.0f);

    vs_uniforms.model = matrix_identity;
    vs_uniforms.view  = matrix_identity;
    vs_uniforms.projection = matrix_identity;

    vx_current_vertex = vertex_default;

    bind.vertex_buffer_offsets[0] = 0;
    bind.index_buffer_offset = 0;

    vx_index_offset  = 0;
    vx_current = 0;
    vx_size    = 0;

    sg_begin_default_pass(&pass_action, sapp_width(), sapp_height());
    sg_apply_pipeline(pip);
    sg_apply_bindings(&bind);

    lua_api_frame(sapp_frame_duration());

    sg_end_pass();
    sg_commit();
}

void cleanup(void) {
    sg_shutdown();
}

sapp_desc sokol_main(int argc, char* argv[]) {
    char *path = NULL;
    if (argc > 1)
        path = argv[1];

    fs_init(path);

    //fs_file sus = fs_read("fs.h");
    //printf("%s\n", sus.data);

    lua_api_setup();

    (void)argc; (void)argv;
    return (sapp_desc){
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .width = 800,
        .height = 600,
        .gl_force_gles2 = true,
        .window_title = "meshbox",
        .icon.sokol_default = true,
    };
}