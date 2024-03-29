const sg = @import("sokol").gfx;
//
//  #version:1# (machine generated, don't edit!)
//
//  Generated by sokol-shdc (https://github.com/floooh/sokol-tools)
//
//  Cmdline: sokol-shdc -i src/shaders/background.glsl -o src/shaders/background.glsl.zig -l glsl100:glsl330:metal_macos:hlsl4 -f sokol_zig
//
//  Overview:
//
//      Shader program 'quad':
//          Get shader desc: shd.quadShaderDesc(sg.queryBackend());
//          Vertex shader: vs
//              Attribute slots:
//                  ATTR_vs_vx_position = 0
//          Fragment shader: fs
//              Uniform block 'vs_uniforms':
//                  C struct: vs_uniforms_t
//                  Bind slot: SLOT_vs_uniforms = 0
//
//
const e = @import("extra");
pub const ATTR_vs_vx_position = 0;
pub const SLOT_vs_uniforms = 0;
pub const VsUniforms = extern struct {
    color_a: e.Color align(16),
    color_b: e.Color,
    resolution: [2]f32,
    time: f32,
    _pad_44: [4]u8 = undefined,
};
//
// #version 330
//
// layout(location = 0) in vec2 vx_position;
// out vec2 uv;
//
// void main()
// {
//     gl_Position = vec4(vx_position, 1.0, 1.0);
//     uv = (vx_position + vec2(1.0)) * vec2(0.5);
// }
//
//
const vs_source_glsl330 = [183]u8{
    0x23, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x33, 0x33, 0x30, 0x0a, 0x0a, 0x6c, 0x61,
    0x79, 0x6f, 0x75, 0x74, 0x28, 0x6c, 0x6f, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20,
    0x30, 0x29, 0x20, 0x69, 0x6e, 0x20, 0x76, 0x65, 0x63, 0x32, 0x20, 0x76, 0x78, 0x5f, 0x70, 0x6f,
    0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x6f, 0x75, 0x74, 0x20, 0x76, 0x65, 0x63, 0x32,
    0x20, 0x75, 0x76, 0x3b, 0x0a, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28,
    0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74,
    0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x76, 0x65, 0x63, 0x34, 0x28, 0x76, 0x78, 0x5f, 0x70, 0x6f,
    0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x2c, 0x20, 0x31, 0x2e, 0x30,
    0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x75, 0x76, 0x20, 0x3d, 0x20, 0x28, 0x76, 0x78, 0x5f,
    0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x2b, 0x20, 0x76, 0x65, 0x63, 0x32, 0x28,
    0x31, 0x2e, 0x30, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x76, 0x65, 0x63, 0x32, 0x28, 0x30, 0x2e, 0x35,
    0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// #version 330
//
// uniform vec4 vs_uniforms[3];
// in vec2 uv;
// layout(location = 0) out vec4 frag_color;
//
// float rand(vec2 co)
// {
//     return fract(sin(dot(co, vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875);
// }
//
// void main()
// {
//     vec2 _43 = floor(uv * vs_uniforms[2].xy) / vs_uniforms[2].xy;
//     vec2 param = _43;
//     frag_color = mix(vs_uniforms[0], vs_uniforms[1], vec4((1.0 - _43.y) + ((rand(param) - 0.5) * 0.0500000007450580596923828125)));
// }
//
//
const fs_source_glsl330 = [459]u8{
    0x23, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x33, 0x33, 0x30, 0x0a, 0x0a, 0x75, 0x6e,
    0x69, 0x66, 0x6f, 0x72, 0x6d, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e,
    0x69, 0x66, 0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x33, 0x5d, 0x3b, 0x0a, 0x69, 0x6e, 0x20, 0x76, 0x65,
    0x63, 0x32, 0x20, 0x75, 0x76, 0x3b, 0x0a, 0x6c, 0x61, 0x79, 0x6f, 0x75, 0x74, 0x28, 0x6c, 0x6f,
    0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x30, 0x29, 0x20, 0x6f, 0x75, 0x74, 0x20,
    0x76, 0x65, 0x63, 0x34, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b,
    0x0a, 0x0a, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x72, 0x61, 0x6e, 0x64, 0x28, 0x76, 0x65, 0x63,
    0x32, 0x20, 0x63, 0x6f, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75,
    0x72, 0x6e, 0x20, 0x66, 0x72, 0x61, 0x63, 0x74, 0x28, 0x73, 0x69, 0x6e, 0x28, 0x64, 0x6f, 0x74,
    0x28, 0x63, 0x6f, 0x2c, 0x20, 0x76, 0x65, 0x63, 0x32, 0x28, 0x31, 0x32, 0x2e, 0x39, 0x38, 0x39,
    0x38, 0x30, 0x30, 0x34, 0x35, 0x33, 0x31, 0x38, 0x36, 0x30, 0x33, 0x35, 0x31, 0x35, 0x36, 0x32,
    0x35, 0x2c, 0x20, 0x37, 0x38, 0x2e, 0x32, 0x33, 0x33, 0x30, 0x30, 0x31, 0x37, 0x30, 0x38, 0x39,
    0x38, 0x34, 0x33, 0x37, 0x35, 0x29, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x34, 0x33, 0x37, 0x35, 0x38,
    0x2e, 0x35, 0x34, 0x36, 0x38, 0x37, 0x35, 0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x76, 0x6f, 0x69,
    0x64, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x76,
    0x65, 0x63, 0x32, 0x20, 0x5f, 0x34, 0x33, 0x20, 0x3d, 0x20, 0x66, 0x6c, 0x6f, 0x6f, 0x72, 0x28,
    0x75, 0x76, 0x20, 0x2a, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x73,
    0x5b, 0x32, 0x5d, 0x2e, 0x78, 0x79, 0x29, 0x20, 0x2f, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69,
    0x66, 0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x32, 0x5d, 0x2e, 0x78, 0x79, 0x3b, 0x0a, 0x20, 0x20, 0x20,
    0x20, 0x76, 0x65, 0x63, 0x32, 0x20, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x20, 0x3d, 0x20, 0x5f, 0x34,
    0x33, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f,
    0x72, 0x20, 0x3d, 0x20, 0x6d, 0x69, 0x78, 0x28, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f,
    0x72, 0x6d, 0x73, 0x5b, 0x30, 0x5d, 0x2c, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f,
    0x72, 0x6d, 0x73, 0x5b, 0x31, 0x5d, 0x2c, 0x20, 0x76, 0x65, 0x63, 0x34, 0x28, 0x28, 0x31, 0x2e,
    0x30, 0x20, 0x2d, 0x20, 0x5f, 0x34, 0x33, 0x2e, 0x79, 0x29, 0x20, 0x2b, 0x20, 0x28, 0x28, 0x72,
    0x61, 0x6e, 0x64, 0x28, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x29, 0x20, 0x2d, 0x20, 0x30, 0x2e, 0x35,
    0x29, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x30, 0x35, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x37,
    0x34, 0x35, 0x30, 0x35, 0x38, 0x30, 0x35, 0x39, 0x36, 0x39, 0x32, 0x33, 0x38, 0x32, 0x38, 0x31,
    0x32, 0x35, 0x29, 0x29, 0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// #version 100
//
// attribute vec2 vx_position;
// varying vec2 uv;
//
// void main()
// {
//     gl_Position = vec4(vx_position, 1.0, 1.0);
//     uv = (vx_position + vec2(1.0)) * vec2(0.5);
// }
//
//
const vs_source_glsl100 = [173]u8{
    0x23, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x31, 0x30, 0x30, 0x0a, 0x0a, 0x61, 0x74,
    0x74, 0x72, 0x69, 0x62, 0x75, 0x74, 0x65, 0x20, 0x76, 0x65, 0x63, 0x32, 0x20, 0x76, 0x78, 0x5f,
    0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x76, 0x61, 0x72, 0x79, 0x69, 0x6e,
    0x67, 0x20, 0x76, 0x65, 0x63, 0x32, 0x20, 0x75, 0x76, 0x3b, 0x0a, 0x0a, 0x76, 0x6f, 0x69, 0x64,
    0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x67, 0x6c,
    0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x76, 0x65, 0x63, 0x34,
    0x28, 0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x2c, 0x20, 0x31, 0x2e,
    0x30, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x75, 0x76, 0x20,
    0x3d, 0x20, 0x28, 0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x2b,
    0x20, 0x76, 0x65, 0x63, 0x32, 0x28, 0x31, 0x2e, 0x30, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x76, 0x65,
    0x63, 0x32, 0x28, 0x30, 0x2e, 0x35, 0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// #version 100
// precision mediump float;
// precision highp int;
//
// uniform highp vec4 vs_uniforms[3];
// varying highp vec2 uv;
//
// highp float rand(highp vec2 co)
// {
//     return fract(sin(dot(co, vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875);
// }
//
// void main()
// {
//     highp vec2 _43 = floor(uv * vs_uniforms[2].xy) / vs_uniforms[2].xy;
//     highp vec2 param = _43;
//     gl_FragData[0] = mix(vs_uniforms[0], vs_uniforms[1], vec4((1.0 - _43.y) + ((rand(param) - 0.5) * 0.0500000007450580596923828125)));
// }
//
//
const fs_source_glsl100 = [508]u8{
    0x23, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x31, 0x30, 0x30, 0x0a, 0x70, 0x72, 0x65,
    0x63, 0x69, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x6d, 0x65, 0x64, 0x69, 0x75, 0x6d, 0x70, 0x20, 0x66,
    0x6c, 0x6f, 0x61, 0x74, 0x3b, 0x0a, 0x70, 0x72, 0x65, 0x63, 0x69, 0x73, 0x69, 0x6f, 0x6e, 0x20,
    0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x69, 0x6e, 0x74, 0x3b, 0x0a, 0x0a, 0x75, 0x6e, 0x69, 0x66,
    0x6f, 0x72, 0x6d, 0x20, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x76,
    0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x33, 0x5d, 0x3b, 0x0a, 0x76,
    0x61, 0x72, 0x79, 0x69, 0x6e, 0x67, 0x20, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, 0x65, 0x63,
    0x32, 0x20, 0x75, 0x76, 0x3b, 0x0a, 0x0a, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x66, 0x6c, 0x6f,
    0x61, 0x74, 0x20, 0x72, 0x61, 0x6e, 0x64, 0x28, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, 0x65,
    0x63, 0x32, 0x20, 0x63, 0x6f, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74,
    0x75, 0x72, 0x6e, 0x20, 0x66, 0x72, 0x61, 0x63, 0x74, 0x28, 0x73, 0x69, 0x6e, 0x28, 0x64, 0x6f,
    0x74, 0x28, 0x63, 0x6f, 0x2c, 0x20, 0x76, 0x65, 0x63, 0x32, 0x28, 0x31, 0x32, 0x2e, 0x39, 0x38,
    0x39, 0x38, 0x30, 0x30, 0x34, 0x35, 0x33, 0x31, 0x38, 0x36, 0x30, 0x33, 0x35, 0x31, 0x35, 0x36,
    0x32, 0x35, 0x2c, 0x20, 0x37, 0x38, 0x2e, 0x32, 0x33, 0x33, 0x30, 0x30, 0x31, 0x37, 0x30, 0x38,
    0x39, 0x38, 0x34, 0x33, 0x37, 0x35, 0x29, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x34, 0x33, 0x37, 0x35,
    0x38, 0x2e, 0x35, 0x34, 0x36, 0x38, 0x37, 0x35, 0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x76, 0x6f,
    0x69, 0x64, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, 0x65, 0x63, 0x32, 0x20, 0x5f, 0x34, 0x33, 0x20, 0x3d,
    0x20, 0x66, 0x6c, 0x6f, 0x6f, 0x72, 0x28, 0x75, 0x76, 0x20, 0x2a, 0x20, 0x76, 0x73, 0x5f, 0x75,
    0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x32, 0x5d, 0x2e, 0x78, 0x79, 0x29, 0x20, 0x2f,
    0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x32, 0x5d, 0x2e,
    0x78, 0x79, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, 0x65,
    0x63, 0x32, 0x20, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x20, 0x3d, 0x20, 0x5f, 0x34, 0x33, 0x3b, 0x0a,
    0x20, 0x20, 0x20, 0x20, 0x67, 0x6c, 0x5f, 0x46, 0x72, 0x61, 0x67, 0x44, 0x61, 0x74, 0x61, 0x5b,
    0x30, 0x5d, 0x20, 0x3d, 0x20, 0x6d, 0x69, 0x78, 0x28, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66,
    0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x30, 0x5d, 0x2c, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66,
    0x6f, 0x72, 0x6d, 0x73, 0x5b, 0x31, 0x5d, 0x2c, 0x20, 0x76, 0x65, 0x63, 0x34, 0x28, 0x28, 0x31,
    0x2e, 0x30, 0x20, 0x2d, 0x20, 0x5f, 0x34, 0x33, 0x2e, 0x79, 0x29, 0x20, 0x2b, 0x20, 0x28, 0x28,
    0x72, 0x61, 0x6e, 0x64, 0x28, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x29, 0x20, 0x2d, 0x20, 0x30, 0x2e,
    0x35, 0x29, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x30, 0x35, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
    0x37, 0x34, 0x35, 0x30, 0x35, 0x38, 0x30, 0x35, 0x39, 0x36, 0x39, 0x32, 0x33, 0x38, 0x32, 0x38,
    0x31, 0x32, 0x35, 0x29, 0x29, 0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// static float4 gl_Position;
// static float2 vx_position;
// static float2 uv;
//
// struct SPIRV_Cross_Input
// {
//     float2 vx_position : TEXCOORD0;
// };
//
// struct SPIRV_Cross_Output
// {
//     float2 uv : TEXCOORD0;
//     float4 gl_Position : SV_Position;
// };
//
// #line 10 "src/shaders/background.glsl"
// void vert_main()
// {
// #line 10 "src/shaders/background.glsl"
//     gl_Position = float4(vx_position, 1.0f, 1.0f);
// #line 11 "src/shaders/background.glsl"
//     uv = (vx_position + 1.0f.xx) * 0.5f.xx;
// }
//
// SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
// {
//     vx_position = stage_input.vx_position;
//     vert_main();
//     SPIRV_Cross_Output stage_output;
//     stage_output.gl_Position = gl_Position;
//     stage_output.uv = uv;
//     return stage_output;
// }
//
const vs_source_hlsl4 = [723]u8{
    0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x67, 0x6c,
    0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x73, 0x74, 0x61, 0x74, 0x69,
    0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69,
    0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f,
    0x61, 0x74, 0x32, 0x20, 0x75, 0x76, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20,
    0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x49, 0x6e, 0x70, 0x75,
    0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x76,
    0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3a, 0x20, 0x54, 0x45, 0x58,
    0x43, 0x4f, 0x4f, 0x52, 0x44, 0x30, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75,
    0x63, 0x74, 0x20, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f,
    0x75, 0x74, 0x70, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61,
    0x74, 0x32, 0x20, 0x75, 0x76, 0x20, 0x3a, 0x20, 0x54, 0x45, 0x58, 0x43, 0x4f, 0x4f, 0x52, 0x44,
    0x30, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x67, 0x6c,
    0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3a, 0x20, 0x53, 0x56, 0x5f, 0x50,
    0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x23, 0x6c, 0x69,
    0x6e, 0x65, 0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65,
    0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c,
    0x73, 0x6c, 0x22, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20, 0x76, 0x65, 0x72, 0x74, 0x5f, 0x6d, 0x61,
    0x69, 0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x30, 0x20,
    0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63,
    0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20,
    0x20, 0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20,
    0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x28, 0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69,
    0x6f, 0x6e, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x66, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x66, 0x29, 0x3b,
    0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x31, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73,
    0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e,
    0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x75, 0x76, 0x20, 0x3d,
    0x20, 0x28, 0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x2b, 0x20,
    0x31, 0x2e, 0x30, 0x66, 0x2e, 0x78, 0x78, 0x29, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x35, 0x66, 0x2e,
    0x78, 0x78, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f,
    0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x53,
    0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x49, 0x6e, 0x70, 0x75, 0x74,
    0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70, 0x75, 0x74, 0x29, 0x0a, 0x7b, 0x0a,
    0x20, 0x20, 0x20, 0x20, 0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20,
    0x3d, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70, 0x75, 0x74, 0x2e, 0x76, 0x78,
    0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x76,
    0x65, 0x72, 0x74, 0x5f, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70,
    0x75, 0x74, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x3b,
    0x0a, 0x20, 0x20, 0x20, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75,
    0x74, 0x2e, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20,
    0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x20, 0x20, 0x20,
    0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x2e, 0x75, 0x76,
    0x20, 0x3d, 0x20, 0x75, 0x76, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72,
    0x6e, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x3b, 0x0a,
    0x7d, 0x0a, 0x00,
};
//
// cbuffer vs_uniforms : register(b0)
// {
//     float4 _33_color_a : packoffset(c0);
//     float4 _33_color_b : packoffset(c1);
//     float2 _33_resolution : packoffset(c2);
//     float _33_time : packoffset(c2.z);
// };
//
//
// static float2 uv;
// static float4 frag_color;
//
// struct SPIRV_Cross_Input
// {
//     float2 uv : TEXCOORD0;
// };
//
// struct SPIRV_Cross_Output
// {
//     float4 frag_color : SV_Target0;
// };
//
// #line 20 "src/shaders/background.glsl"
// float rand(float2 co)
// {
// #line 20 "src/shaders/background.glsl"
//     return frac(sin(dot(co, float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f);
// }
//
// #line 24 "src/shaders/background.glsl"
// void frag_main()
// {
// #line 24 "src/shaders/background.glsl"
//     float2 _43 = floor(uv * _33_resolution) / _33_resolution;
// #line 25 "src/shaders/background.glsl"
//     float2 param = _43;
// #line 26 "src/shaders/background.glsl"
//     frag_color = lerp(_33_color_a, _33_color_b, ((1.0f - _43.y) + ((rand(param) - 0.5f) * 0.0500000007450580596923828125f)).xxxx);
// }
//
// SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
// {
//     uv = stage_input.uv;
//     frag_main();
//     SPIRV_Cross_Output stage_output;
//     stage_output.frag_color = frag_color;
//     return stage_output;
// }
//
const fs_source_hlsl4 = [1186]u8{
    0x63, 0x62, 0x75, 0x66, 0x66, 0x65, 0x72, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f,
    0x72, 0x6d, 0x73, 0x20, 0x3a, 0x20, 0x72, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x28, 0x62,
    0x30, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20,
    0x5f, 0x33, 0x33, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x61, 0x20, 0x3a, 0x20, 0x70, 0x61,
    0x63, 0x6b, 0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x28, 0x63, 0x30, 0x29, 0x3b, 0x0a, 0x20, 0x20,
    0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x5f, 0x33, 0x33, 0x5f, 0x63, 0x6f, 0x6c,
    0x6f, 0x72, 0x5f, 0x62, 0x20, 0x3a, 0x20, 0x70, 0x61, 0x63, 0x6b, 0x6f, 0x66, 0x66, 0x73, 0x65,
    0x74, 0x28, 0x63, 0x31, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74,
    0x32, 0x20, 0x5f, 0x33, 0x33, 0x5f, 0x72, 0x65, 0x73, 0x6f, 0x6c, 0x75, 0x74, 0x69, 0x6f, 0x6e,
    0x20, 0x3a, 0x20, 0x70, 0x61, 0x63, 0x6b, 0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x28, 0x63, 0x32,
    0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x5f, 0x33, 0x33,
    0x5f, 0x74, 0x69, 0x6d, 0x65, 0x20, 0x3a, 0x20, 0x70, 0x61, 0x63, 0x6b, 0x6f, 0x66, 0x66, 0x73,
    0x65, 0x74, 0x28, 0x63, 0x32, 0x2e, 0x7a, 0x29, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x0a, 0x73,
    0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x75, 0x76, 0x3b,
    0x0a, 0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x66,
    0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75,
    0x63, 0x74, 0x20, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x49,
    0x6e, 0x70, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74,
    0x32, 0x20, 0x75, 0x76, 0x20, 0x3a, 0x20, 0x54, 0x45, 0x58, 0x43, 0x4f, 0x4f, 0x52, 0x44, 0x30,
    0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x53, 0x50, 0x49,
    0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x0a,
    0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x66, 0x72, 0x61,
    0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3a, 0x20, 0x53, 0x56, 0x5f, 0x54, 0x61, 0x72,
    0x67, 0x65, 0x74, 0x30, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20,
    0x32, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f,
    0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22,
    0x0a, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x72, 0x61, 0x6e, 0x64, 0x28, 0x66, 0x6c, 0x6f, 0x61,
    0x74, 0x32, 0x20, 0x63, 0x6f, 0x29, 0x0a, 0x7b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32,
    0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62,
    0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a,
    0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72, 0x6e, 0x20, 0x66, 0x72, 0x61, 0x63, 0x28,
    0x73, 0x69, 0x6e, 0x28, 0x64, 0x6f, 0x74, 0x28, 0x63, 0x6f, 0x2c, 0x20, 0x66, 0x6c, 0x6f, 0x61,
    0x74, 0x32, 0x28, 0x31, 0x32, 0x2e, 0x39, 0x38, 0x39, 0x38, 0x30, 0x30, 0x34, 0x35, 0x33, 0x31,
    0x38, 0x36, 0x30, 0x33, 0x35, 0x31, 0x35, 0x36, 0x32, 0x35, 0x66, 0x2c, 0x20, 0x37, 0x38, 0x2e,
    0x32, 0x33, 0x33, 0x30, 0x30, 0x31, 0x37, 0x30, 0x38, 0x39, 0x38, 0x34, 0x33, 0x37, 0x35, 0x66,
    0x29, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x34, 0x33, 0x37, 0x35, 0x38, 0x2e, 0x35, 0x34, 0x36, 0x38,
    0x37, 0x35, 0x66, 0x29, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32,
    0x34, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62,
    0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a,
    0x76, 0x6f, 0x69, 0x64, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29,
    0x0a, 0x7b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x34, 0x20, 0x22, 0x73, 0x72, 0x63,
    0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f,
    0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c,
    0x6f, 0x61, 0x74, 0x32, 0x20, 0x5f, 0x34, 0x33, 0x20, 0x3d, 0x20, 0x66, 0x6c, 0x6f, 0x6f, 0x72,
    0x28, 0x75, 0x76, 0x20, 0x2a, 0x20, 0x5f, 0x33, 0x33, 0x5f, 0x72, 0x65, 0x73, 0x6f, 0x6c, 0x75,
    0x74, 0x69, 0x6f, 0x6e, 0x29, 0x20, 0x2f, 0x20, 0x5f, 0x33, 0x33, 0x5f, 0x72, 0x65, 0x73, 0x6f,
    0x6c, 0x75, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x35,
    0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61,
    0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20,
    0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x20,
    0x3d, 0x20, 0x5f, 0x34, 0x33, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x36, 0x20,
    0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63,
    0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20,
    0x20, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x6c,
    0x65, 0x72, 0x70, 0x28, 0x5f, 0x33, 0x33, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x61, 0x2c,
    0x20, 0x5f, 0x33, 0x33, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x62, 0x2c, 0x20, 0x28, 0x28,
    0x31, 0x2e, 0x30, 0x66, 0x20, 0x2d, 0x20, 0x5f, 0x34, 0x33, 0x2e, 0x79, 0x29, 0x20, 0x2b, 0x20,
    0x28, 0x28, 0x72, 0x61, 0x6e, 0x64, 0x28, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x29, 0x20, 0x2d, 0x20,
    0x30, 0x2e, 0x35, 0x66, 0x29, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x30, 0x35, 0x30, 0x30, 0x30, 0x30,
    0x30, 0x30, 0x30, 0x37, 0x34, 0x35, 0x30, 0x35, 0x38, 0x30, 0x35, 0x39, 0x36, 0x39, 0x32, 0x33,
    0x38, 0x32, 0x38, 0x31, 0x32, 0x35, 0x66, 0x29, 0x29, 0x2e, 0x78, 0x78, 0x78, 0x78, 0x29, 0x3b,
    0x0a, 0x7d, 0x0a, 0x0a, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f,
    0x4f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x53, 0x50, 0x49, 0x52,
    0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x49, 0x6e, 0x70, 0x75, 0x74, 0x20, 0x73, 0x74,
    0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70, 0x75, 0x74, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20,
    0x20, 0x75, 0x76, 0x20, 0x3d, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70, 0x75,
    0x74, 0x2e, 0x75, 0x76, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x6d,
    0x61, 0x69, 0x6e, 0x28, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x53, 0x50, 0x49, 0x52, 0x56,
    0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x20, 0x73, 0x74,
    0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x2e, 0x66, 0x72, 0x61,
    0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72, 0x6e,
    0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x3b, 0x0a, 0x7d,
    0x0a, 0x00,
};
//
// #include <metal_stdlib>
// #include <simd/simd.h>
//
// using namespace metal;
//
// struct main0_out
// {
//     float2 uv [[user(locn0)]];
//     float4 gl_Position [[position]];
// };
//
// struct main0_in
// {
//     float2 vx_position [[attribute(0)]];
// };
//
// #line 10 "src/shaders/background.glsl"
// vertex main0_out main0(main0_in in [[stage_in]])
// {
//     main0_out out = {};
// #line 10 "src/shaders/background.glsl"
//     out.gl_Position = float4(in.vx_position, 1.0, 1.0);
// #line 11 "src/shaders/background.glsl"
//     out.uv = (in.vx_position + float2(1.0)) * float2(0.5);
//     return out;
// }
//
//
const vs_source_metal_macos = [553]u8{
    0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x20, 0x3c, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x5f,
    0x73, 0x74, 0x64, 0x6c, 0x69, 0x62, 0x3e, 0x0a, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65,
    0x20, 0x3c, 0x73, 0x69, 0x6d, 0x64, 0x2f, 0x73, 0x69, 0x6d, 0x64, 0x2e, 0x68, 0x3e, 0x0a, 0x0a,
    0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x6e, 0x61, 0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, 0x20,
    0x6d, 0x65, 0x74, 0x61, 0x6c, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d,
    0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66,
    0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x75, 0x76, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28,
    0x6c, 0x6f, 0x63, 0x6e, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c,
    0x6f, 0x61, 0x74, 0x34, 0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e,
    0x20, 0x5b, 0x5b, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d,
    0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f,
    0x69, 0x6e, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20,
    0x76, 0x78, 0x5f, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x5b, 0x5b, 0x61, 0x74,
    0x74, 0x72, 0x69, 0x62, 0x75, 0x74, 0x65, 0x28, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b,
    0x0a, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f,
    0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75,
    0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x20,
    0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x28,
    0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x69, 0x6e, 0x20, 0x69, 0x6e, 0x20, 0x5b, 0x5b, 0x73, 0x74,
    0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x5d, 0x5d, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6f, 0x75, 0x74, 0x20, 0x3d, 0x20,
    0x7b, 0x7d, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72,
    0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72,
    0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6f,
    0x75, 0x74, 0x2e, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d,
    0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x28, 0x69, 0x6e, 0x2e, 0x76, 0x78, 0x5f, 0x70, 0x6f,
    0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x2c, 0x20, 0x31, 0x2e, 0x30,
    0x29, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x31, 0x20, 0x22, 0x73, 0x72, 0x63,
    0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f,
    0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6f, 0x75,
    0x74, 0x2e, 0x75, 0x76, 0x20, 0x3d, 0x20, 0x28, 0x69, 0x6e, 0x2e, 0x76, 0x78, 0x5f, 0x70, 0x6f,
    0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x2b, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x28,
    0x31, 0x2e, 0x30, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x28, 0x30,
    0x2e, 0x35, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72, 0x6e, 0x20,
    0x6f, 0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// #pragma clang diagnostic ignored "-Wmissing-prototypes"
//
// #include <metal_stdlib>
// #include <simd/simd.h>
//
// using namespace metal;
//
// struct vs_uniforms
// {
//     float4 color_a;
//     float4 color_b;
//     float2 resolution;
//     float time;
// };
//
// struct main0_out
// {
//     float4 frag_color [[color(0)]];
// };
//
// struct main0_in
// {
//     float2 uv [[user(locn0)]];
// };
//
// #line 20 "src/shaders/background.glsl"
// static inline __attribute__((always_inline))
// float rand(thread const float2& co)
// {
// #line 20 "src/shaders/background.glsl"
//     return fract(sin(dot(co, float2(12.98980045318603515625, 78.233001708984375))) * 43758.546875);
// }
//
// #line 24 "src/shaders/background.glsl"
// fragment main0_out main0(main0_in in [[stage_in]], constant vs_uniforms& _33 [[buffer(0)]])
// {
//     main0_out out = {};
// #line 24 "src/shaders/background.glsl"
//     float2 _43 = floor(in.uv * _33.resolution) / _33.resolution;
// #line 25 "src/shaders/background.glsl"
//     float2 param = _43;
// #line 26 "src/shaders/background.glsl"
//     out.frag_color = mix(_33.color_a, _33.color_b, float4((1.0 - _43.y) + ((rand(param) - 0.5) * 0.0500000007450580596923828125)));
//     return out;
// }
//
//
const fs_source_metal_macos = [1124]u8{
    0x23, 0x70, 0x72, 0x61, 0x67, 0x6d, 0x61, 0x20, 0x63, 0x6c, 0x61, 0x6e, 0x67, 0x20, 0x64, 0x69,
    0x61, 0x67, 0x6e, 0x6f, 0x73, 0x74, 0x69, 0x63, 0x20, 0x69, 0x67, 0x6e, 0x6f, 0x72, 0x65, 0x64,
    0x20, 0x22, 0x2d, 0x57, 0x6d, 0x69, 0x73, 0x73, 0x69, 0x6e, 0x67, 0x2d, 0x70, 0x72, 0x6f, 0x74,
    0x6f, 0x74, 0x79, 0x70, 0x65, 0x73, 0x22, 0x0a, 0x0a, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64,
    0x65, 0x20, 0x3c, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x5f, 0x73, 0x74, 0x64, 0x6c, 0x69, 0x62, 0x3e,
    0x0a, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x20, 0x3c, 0x73, 0x69, 0x6d, 0x64, 0x2f,
    0x73, 0x69, 0x6d, 0x64, 0x2e, 0x68, 0x3e, 0x0a, 0x0a, 0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x6e,
    0x61, 0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, 0x20, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x3b, 0x0a,
    0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f,
    0x72, 0x6d, 0x73, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34,
    0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x61, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c,
    0x6f, 0x61, 0x74, 0x34, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x62, 0x3b, 0x0a, 0x20, 0x20,
    0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x72, 0x65, 0x73, 0x6f, 0x6c, 0x75, 0x74,
    0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x74,
    0x69, 0x6d, 0x65, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20,
    0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f,
    0x72, 0x20, 0x5b, 0x5b, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x28, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a,
    0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30,
    0x5f, 0x69, 0x6e, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32,
    0x20, 0x75, 0x76, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e, 0x30,
    0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32,
    0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62,
    0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a,
    0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x69, 0x6e, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x5f, 0x5f,
    0x61, 0x74, 0x74, 0x72, 0x69, 0x62, 0x75, 0x74, 0x65, 0x5f, 0x5f, 0x28, 0x28, 0x61, 0x6c, 0x77,
    0x61, 0x79, 0x73, 0x5f, 0x69, 0x6e, 0x6c, 0x69, 0x6e, 0x65, 0x29, 0x29, 0x0a, 0x66, 0x6c, 0x6f,
    0x61, 0x74, 0x20, 0x72, 0x61, 0x6e, 0x64, 0x28, 0x74, 0x68, 0x72, 0x65, 0x61, 0x64, 0x20, 0x63,
    0x6f, 0x6e, 0x73, 0x74, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x26, 0x20, 0x63, 0x6f, 0x29,
    0x0a, 0x7b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63,
    0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f,
    0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65,
    0x74, 0x75, 0x72, 0x6e, 0x20, 0x66, 0x72, 0x61, 0x63, 0x74, 0x28, 0x73, 0x69, 0x6e, 0x28, 0x64,
    0x6f, 0x74, 0x28, 0x63, 0x6f, 0x2c, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x28, 0x31, 0x32,
    0x2e, 0x39, 0x38, 0x39, 0x38, 0x30, 0x30, 0x34, 0x35, 0x33, 0x31, 0x38, 0x36, 0x30, 0x33, 0x35,
    0x31, 0x35, 0x36, 0x32, 0x35, 0x2c, 0x20, 0x37, 0x38, 0x2e, 0x32, 0x33, 0x33, 0x30, 0x30, 0x31,
    0x37, 0x30, 0x38, 0x39, 0x38, 0x34, 0x33, 0x37, 0x35, 0x29, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x34,
    0x33, 0x37, 0x35, 0x38, 0x2e, 0x35, 0x34, 0x36, 0x38, 0x37, 0x35, 0x29, 0x3b, 0x0a, 0x7d, 0x0a,
    0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x34, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73,
    0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e,
    0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x66, 0x72, 0x61, 0x67, 0x6d, 0x65, 0x6e, 0x74,
    0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30,
    0x28, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x69, 0x6e, 0x20, 0x69, 0x6e, 0x20, 0x5b, 0x5b, 0x73,
    0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x5d, 0x5d, 0x2c, 0x20, 0x63, 0x6f, 0x6e, 0x73, 0x74,
    0x61, 0x6e, 0x74, 0x20, 0x76, 0x73, 0x5f, 0x75, 0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x73, 0x26,
    0x20, 0x5f, 0x33, 0x33, 0x20, 0x5b, 0x5b, 0x62, 0x75, 0x66, 0x66, 0x65, 0x72, 0x28, 0x30, 0x29,
    0x5d, 0x5d, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f,
    0x6f, 0x75, 0x74, 0x20, 0x6f, 0x75, 0x74, 0x20, 0x3d, 0x20, 0x7b, 0x7d, 0x3b, 0x0a, 0x23, 0x6c,
    0x69, 0x6e, 0x65, 0x20, 0x32, 0x34, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64,
    0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67,
    0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20,
    0x5f, 0x34, 0x33, 0x20, 0x3d, 0x20, 0x66, 0x6c, 0x6f, 0x6f, 0x72, 0x28, 0x69, 0x6e, 0x2e, 0x75,
    0x76, 0x20, 0x2a, 0x20, 0x5f, 0x33, 0x33, 0x2e, 0x72, 0x65, 0x73, 0x6f, 0x6c, 0x75, 0x74, 0x69,
    0x6f, 0x6e, 0x29, 0x20, 0x2f, 0x20, 0x5f, 0x33, 0x33, 0x2e, 0x72, 0x65, 0x73, 0x6f, 0x6c, 0x75,
    0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x35, 0x20, 0x22,
    0x73, 0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b,
    0x67, 0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20,
    0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x20, 0x3d, 0x20,
    0x5f, 0x34, 0x33, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x32, 0x36, 0x20, 0x22, 0x73,
    0x72, 0x63, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x62, 0x61, 0x63, 0x6b, 0x67,
    0x72, 0x6f, 0x75, 0x6e, 0x64, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x6f, 0x75, 0x74, 0x2e, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d,
    0x20, 0x6d, 0x69, 0x78, 0x28, 0x5f, 0x33, 0x33, 0x2e, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x61,
    0x2c, 0x20, 0x5f, 0x33, 0x33, 0x2e, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x5f, 0x62, 0x2c, 0x20, 0x66,
    0x6c, 0x6f, 0x61, 0x74, 0x34, 0x28, 0x28, 0x31, 0x2e, 0x30, 0x20, 0x2d, 0x20, 0x5f, 0x34, 0x33,
    0x2e, 0x79, 0x29, 0x20, 0x2b, 0x20, 0x28, 0x28, 0x72, 0x61, 0x6e, 0x64, 0x28, 0x70, 0x61, 0x72,
    0x61, 0x6d, 0x29, 0x20, 0x2d, 0x20, 0x30, 0x2e, 0x35, 0x29, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x30,
    0x35, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x37, 0x34, 0x35, 0x30, 0x35, 0x38, 0x30, 0x35,
    0x39, 0x36, 0x39, 0x32, 0x33, 0x38, 0x32, 0x38, 0x31, 0x32, 0x35, 0x29, 0x29, 0x29, 0x3b, 0x0a,
    0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72, 0x6e, 0x20, 0x6f, 0x75, 0x74, 0x3b, 0x0a,
    0x7d, 0x0a, 0x0a, 0x00,
};
pub fn quadShaderDesc(backend: sg.Backend) sg.ShaderDesc {
    var desc: sg.ShaderDesc = .{};
    switch (backend) {
        .GLCORE33 => {
            desc.attrs[0].name = "vx_position";
            desc.vs.source = &vs_source_glsl330;
            desc.vs.entry = "main";
            desc.fs.source = &fs_source_glsl330;
            desc.fs.entry = "main";
            desc.fs.uniform_blocks[0].size = 48;
            desc.fs.uniform_blocks[0].layout = .STD140;
            desc.fs.uniform_blocks[0].uniforms[0].name = "vs_uniforms";
            desc.fs.uniform_blocks[0].uniforms[0].type = .FLOAT4;
            desc.fs.uniform_blocks[0].uniforms[0].array_count = 3;
            desc.label = "quad_shader";
        },
        .GLES2 => {
            desc.attrs[0].name = "vx_position";
            desc.vs.source = &vs_source_glsl100;
            desc.vs.entry = "main";
            desc.fs.source = &fs_source_glsl100;
            desc.fs.entry = "main";
            desc.fs.uniform_blocks[0].size = 48;
            desc.fs.uniform_blocks[0].layout = .STD140;
            desc.fs.uniform_blocks[0].uniforms[0].name = "vs_uniforms";
            desc.fs.uniform_blocks[0].uniforms[0].type = .FLOAT4;
            desc.fs.uniform_blocks[0].uniforms[0].array_count = 3;
            desc.label = "quad_shader";
        },
        .D3D11 => {
            desc.attrs[0].sem_name = "TEXCOORD";
            desc.attrs[0].sem_index = 0;
            desc.vs.source = &vs_source_hlsl4;
            desc.vs.d3d11_target = "vs_4_0";
            desc.vs.entry = "main";
            desc.fs.source = &fs_source_hlsl4;
            desc.fs.d3d11_target = "ps_4_0";
            desc.fs.entry = "main";
            desc.fs.uniform_blocks[0].size = 48;
            desc.fs.uniform_blocks[0].layout = .STD140;
            desc.label = "quad_shader";
        },
        .METAL_MACOS => {
            desc.vs.source = &vs_source_metal_macos;
            desc.vs.entry = "main0";
            desc.fs.source = &fs_source_metal_macos;
            desc.fs.entry = "main0";
            desc.fs.uniform_blocks[0].size = 48;
            desc.fs.uniform_blocks[0].layout = .STD140;
            desc.label = "quad_shader";
        },
        else => {},
    }
    return desc;
}
