#pragma sokol @ctype mat4 @import("../math.zig").Mat4

#pragma sokol @vs vs
uniform vs_params {
    mat4 mvp;
};

in vec4 pos;
in vec4 color0;
in vec2 texcoord0;

out vec4 color;
out vec2 uv;

void main() {
    gl_Position = mvp * pos;
    color = color0;
    uv = texcoord0 * 5.0;
}
#pragma sokol @end

#pragma sokol @fs fs
uniform sampler2D tex;

uniform fs_params {
    vec4 globalcolor;
    vec4 cropping;
};

in vec4 color;
in vec2 uv;
out vec4 frag_color;

void main() {
    frag_color = texture(tex, uv * cropping.xy + cropping.zw) * globalcolor;
}
#pragma sokol @end

#pragma sokol @program main vs fs

