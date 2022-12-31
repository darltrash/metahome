/* quad vertex shader */
@header const e = @import("extra")
@ctype vec4 e.Color

@vs vs
in vec2 vx_position;
out vec2 uv;

void main() {
    gl_Position = vec4(vx_position, 1.0, 1.0);
    uv = (vx_position+1.0)/2.0;
}
@end

/* quad fragment shader */
@fs fs
uniform sampler2D tex;

uniform vs_uniforms {
    vec4 color_a;
    vec4 color_b;
    vec2 resolution;
    float time;
};

in vec2 uv;
out vec4 frag_color;

// https://stackoverflow.com/a/28095165
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 fv = floor(uv*resolution)/resolution;
    float noise = (rand(fv) - 0.5) * (0.05);
    frag_color = mix(color_a, color_b, fv.y + noise);
}
@end

/* quad shader program */
@program quad vs fs

