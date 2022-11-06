@ctype mat4 matrix

@vs vs
in vec3 vx_position;
in vec3 vx_normal;
in vec2 vx_texcoord;
in vec4 vx_color;

uniform vs_uniforms {
    mat4 model;
    mat4 view;
    mat4 projection;
};

out vec3 position;
out vec3 normal;
out vec2 texcoord;
out vec4 color;

mat3 cofactor(mat4 m) {
    return mat3(
        cross(m[1].xyz, m[2].xyz),
        cross(m[2].xyz, m[0].xyz),
        cross(m[0].xyz, m[1].xyz)
    );
}

void main() {
    gl_Position = projection * view * model * vec4(vx_position, 1.0);
    
    position = (model * vec4(vx_position, 1.0)).xyz;
    normal = cofactor(model) * vx_normal;
    texcoord = vx_texcoord;
    color = vx_color;
}
@end

@fs fs
in vec3 position;
in vec3 normal;
in vec2 texcoord;
in vec4 color;

uniform fs_uniforms {
    vec4 ambient;
    vec4 light_position[16]; // A/W represents type.
    vec4 light_color   [16]; // Alpha is unused.
    int light_amounts;
};

out vec4 frag_color;

uniform sampler2D tex;

void main() {
    vec4 diffuse = vec4(0.0, 0.0, 0.0, 0.0);

    for (int i=0; i < light_amounts; i++) {
        float lt = light_position[i].w;
        vec3 lp = light_position[i].xyz;
        vec3 lc = light_color[i].rgb;

        float power = 1.0;
        if (lt > 1.0) {
            float d2 = distance(lp, position);
            d2 *= d2;
            float power = mix(0.0, length(lc) / d2, step(1.0e-5, d2));
        }

        diffuse.rgb += lc * power * dot(lp, normal);
    }

    vec4 o = texture(tex, texcoord) * color * (ambient + diffuse);
    //o.rgb = pow(o.rgb, vec3(1.0/2.2));
    frag_color = o;
}
@end

@program triangle vs fs