/* quad vertex shader */
@header const e = @import("extra")
@ctype vec4 e.Color

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

uniform vs_uniforms {
    vec4 color_a;
    vec4 color_b;
    float strength;
};

in vec4 color;
in vec2 uv;
out vec4 frag_color;

float luma(vec4 color) {
    return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec4 c = texture(tex, uv) * color;
    frag_color = c;
    frag_color.rgb = mix(c, mix(color_a, color_b, 1.0-luma(c)), strength).rgb;
}
@end

/* quad shader program */
@program quad vs fs

