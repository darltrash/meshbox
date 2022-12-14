/* This defines the API and symbols 
   internally used by meshbox */

#include "stdint.h"

#define GX_MAX_LIGHT_AMOUNT 16

typedef struct {
    float data[16];
} matrix;

#define matrix_identity (matrix){\
    .data = {\
        1.0f, 0.0f, 0.0f, 0.0f,\
        0.0f, 1.0f, 0.0f, 0.0f,\
        0.0f, 0.0f, 1.0f, 0.0f,\
        0.0f, 0.0f, 0.0f, 1.0f\
    }\
}

enum {
    MATRIX_MODE_MODEL = 1,
    MATRIX_MODE_VIEW  = 2,
    MATRIX_MODE_PROJECTION = 3
};

typedef struct {
    int type;
    float x, y, z;
    float r, g, b;
} light;

enum {
    LIGHT_DIRECTIONAL = 1,
    LIGHT_POINT = 2
};

typedef struct { 
    float x, y; 
} vec2;

typedef struct {
    unsigned int x, y, w, h;
} irect;

typedef struct {
    float r, g, b, a;
} color;

typedef struct {
    uint32_t image;
    int w, h;
} texture;

typedef struct {
    float x, y, z;
    float nx, ny, nz;
    float u, v;
    float r, g, b, a;
} vertex;

#define vertex_default (vertex) {\
    .x = 0.0f, .y = 0.0f, .z = 0.0f,\
    .nx = 0.0f, .ny = 0.0f, .nz = 0.0f,\
    .u = 0.0f, .v = 0.0f,\
    .r = 1.0f, .g = 1.0f, .b = 1.0f, .a = 1.0f\
}

// Window stuff
int wn_title(const char *title);
//int wn_icon(texture icon);


// Memory catridge
char *sv_read(int *size);
int sv_write(char *buffer, int size);
int sv_identity(char *id);


// Input handling
vec2 in_joystick(int id);
int  in_button(int id);


// Texture stuff (sucks)
void tx_bind(const char *file);
void tx_unload(const char *file);


// Matrix stuff
int mx_mode(int mode);
void mx_identity();
void mx_set(matrix m);
matrix mx_get();
void mx_perspective(float fov, float near, float far);
void mx_orthographic(float near, float far);
void mx_look_at(
    float ex, float ey, float ez, 
    float ax, float ay, float az, 
    float ux, float uy, float uz
);
void mx_multiply(matrix m);
void mx_translate(float x, float y, float z);
void mx_rotate(float a, float x, float y, float z);
void mx_euler(float x, float y, float z);
void mx_scale(float x, float y, float z);


// Vertices stuff
vertex *vx_load(const char *file);

void vx_normal(float x, float y, float z);
void vx_texcoord(float u, float v);
void vx_color(float r, float g, float b, float a);
void vx_vertex(float x, float y, float z);
void vx_model(vertex *vertices, unsigned int amount);
void vx_render(uint32_t *indices, unsigned int amount);


// General graphiscs
void gx_scissor(
    unsigned int x, unsigned int y, 
    unsigned int w, unsigned int h
);
void gx_viewport(
    unsigned int x, unsigned int y, 
    unsigned int w, unsigned int h
);
unsigned int gx_width();
unsigned int gx_height();
void gx_background(float r, float g, float b, float a);


// Lighting 
void li_ambient(float r, float g, float b, float a);
void li_clear();
void li_light(
    int type,
    float x, float y, float z,
    float r, float g, float b
);


// Filesystem
char *fs_read(char *file);


// Audio
void au_source(unsigned char id, const char *file); // id can be null, caches
void au_unload(char *file);

void au_volume(unsigned char id, float volume);
void au_speed(unsigned char id, float speed);
void au_repeat(unsigned char id, bool repeat);
void au_position(unsigned char id, float x, float y, float z);
void au_play(unsigned char id);
void au_pause(unsigned char id);
void au_copy(unsigned char from, unsigned char to);