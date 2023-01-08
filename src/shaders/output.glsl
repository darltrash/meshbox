@vs vs
in vec2 vx_position;
out vec2 position;

void main() {
    gl_Position = vec4(vx_position, 1.0, 1.0);
    position = (vx_position + 1.0) / 2.0;
}
@end

@fs fs
in vec2 position;
out vec4 frag_color;

uniform sampler2D tex;

void main() {
    frag_color = texture(tex, position);
}
@end

@program out vs fs