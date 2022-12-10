/* quad vertex shader */
@vs vs
in vec4 vx_position;
in vec4 vx_color;
in vec2 vx_uv;

out vec4 color;
out vec2 uv;

void main() {
    gl_Position = vx_position;
    color = vx_color;
    uv = vx_uv;
}
@end

/* quad fragment shader */
@fs fs
uniform sampler2D tex;

in vec4 color;
in vec2 uv;
out vec4 frag_color;

void main() {
    frag_color = texture(tex, uv) * color;
}
@end

/* quad shader program */
@program quad vs fs

