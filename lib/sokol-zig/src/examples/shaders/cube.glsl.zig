const sg = @import("sokol").gfx;
//
//  #version:1# (machine generated, don't edit!)
//
//  Generated by sokol-shdc (https://github.com/floooh/sokol-tools)
//
//  Cmdline: sokol-shdc -i src/examples/shaders/cube.glsl -o src/examples/shaders/cube.glsl.zig -l glsl330:metal_macos:hlsl4 -f sokol_zig
//
//  Overview:
//
//      Shader program 'cube':
//          Get shader desc: shd.cubeShaderDesc(sg.queryBackend());
//          Vertex shader: vs
//              Attribute slots:
//                  ATTR_vs_position = 0
//                  ATTR_vs_color0 = 1
//              Uniform block 'vs_params':
//                  C struct: vs_params_t
//                  Bind slot: SLOT_vs_params = 0
//          Fragment shader: fs
//
//
const m = @import("../math.zig");
pub const ATTR_vs_position = 0;
pub const ATTR_vs_color0 = 1;
pub const SLOT_vs_params = 0;
pub const VsParams = extern struct {
    mvp: m.Mat4 align(16),
};
//
// #version 330
//
// uniform vec4 vs_params[4];
// layout(location = 0) in vec4 position;
// out vec4 color;
// layout(location = 1) in vec4 color0;
//
// void main()
// {
//     gl_Position = mat4(vs_params[0], vs_params[1], vs_params[2], vs_params[3]) * position;
//     color = color0;
// }
//
//
const vs_source_glsl330 = [263]u8{
    0x23, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x33, 0x33, 0x30, 0x0a, 0x0a, 0x75, 0x6e,
    0x69, 0x66, 0x6f, 0x72, 0x6d, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x76, 0x73, 0x5f, 0x70, 0x61,
    0x72, 0x61, 0x6d, 0x73, 0x5b, 0x34, 0x5d, 0x3b, 0x0a, 0x6c, 0x61, 0x79, 0x6f, 0x75, 0x74, 0x28,
    0x6c, 0x6f, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x30, 0x29, 0x20, 0x69, 0x6e,
    0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a,
    0x6f, 0x75, 0x74, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a,
    0x6c, 0x61, 0x79, 0x6f, 0x75, 0x74, 0x28, 0x6c, 0x6f, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20,
    0x3d, 0x20, 0x31, 0x29, 0x20, 0x69, 0x6e, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x63, 0x6f, 0x6c,
    0x6f, 0x72, 0x30, 0x3b, 0x0a, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28,
    0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74,
    0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x6d, 0x61, 0x74, 0x34, 0x28, 0x76, 0x73, 0x5f, 0x70, 0x61,
    0x72, 0x61, 0x6d, 0x73, 0x5b, 0x30, 0x5d, 0x2c, 0x20, 0x76, 0x73, 0x5f, 0x70, 0x61, 0x72, 0x61,
    0x6d, 0x73, 0x5b, 0x31, 0x5d, 0x2c, 0x20, 0x76, 0x73, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73,
    0x5b, 0x32, 0x5d, 0x2c, 0x20, 0x76, 0x73, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x33,
    0x5d, 0x29, 0x20, 0x2a, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x20,
    0x20, 0x20, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72,
    0x30, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// #version 330
//
// layout(location = 0) out vec4 frag_color;
// in vec4 color;
//
// void main()
// {
//     frag_color = color;
// }
//
//
const fs_source_glsl330 = [114]u8{
    0x23, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x33, 0x33, 0x30, 0x0a, 0x0a, 0x6c, 0x61,
    0x79, 0x6f, 0x75, 0x74, 0x28, 0x6c, 0x6f, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20,
    0x30, 0x29, 0x20, 0x6f, 0x75, 0x74, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x66, 0x72, 0x61, 0x67,
    0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x69, 0x6e, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20,
    0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20, 0x6d, 0x61, 0x69,
    0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x7d, 0x0a,
    0x0a, 0x00,
};
//
// cbuffer vs_params : register(b0)
// {
//     row_major float4x4 _21_mvp : packoffset(c0);
// };
//
//
// static float4 gl_Position;
// static float4 position;
// static float4 color;
// static float4 color0;
//
// struct SPIRV_Cross_Input
// {
//     float4 position : TEXCOORD0;
//     float4 color0 : TEXCOORD1;
// };
//
// struct SPIRV_Cross_Output
// {
//     float4 color : TEXCOORD0;
//     float4 gl_Position : SV_Position;
// };
//
// #line 16 "src/examples/shaders/cube.glsl"
// void vert_main()
// {
// #line 16 "src/examples/shaders/cube.glsl"
//     gl_Position = mul(position, _21_mvp);
// #line 17 "src/examples/shaders/cube.glsl"
//     color = color0;
// }
//
// SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
// {
//     position = stage_input.position;
//     color0 = stage_input.color0;
//     vert_main();
//     SPIRV_Cross_Output stage_output;
//     stage_output.gl_Position = gl_Position;
//     stage_output.color = color;
//     return stage_output;
// }
//
const vs_source_hlsl4 = [874]u8{
    0x63, 0x62, 0x75, 0x66, 0x66, 0x65, 0x72, 0x20, 0x76, 0x73, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d,
    0x73, 0x20, 0x3a, 0x20, 0x72, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x28, 0x62, 0x30, 0x29,
    0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x6f, 0x77, 0x5f, 0x6d, 0x61, 0x6a, 0x6f, 0x72,
    0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x78, 0x34, 0x20, 0x5f, 0x32, 0x31, 0x5f, 0x6d, 0x76,
    0x70, 0x20, 0x3a, 0x20, 0x70, 0x61, 0x63, 0x6b, 0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x28, 0x63,
    0x30, 0x29, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x0a, 0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20,
    0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69,
    0x6f, 0x6e, 0x3b, 0x0a, 0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74,
    0x34, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x73, 0x74, 0x61, 0x74,
    0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b,
    0x0a, 0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x53,
    0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x49, 0x6e, 0x70, 0x75, 0x74,
    0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x70, 0x6f,
    0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3a, 0x20, 0x54, 0x45, 0x58, 0x43, 0x4f, 0x4f, 0x52,
    0x44, 0x30, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x20, 0x3a, 0x20, 0x54, 0x45, 0x58, 0x43, 0x4f, 0x4f, 0x52, 0x44,
    0x31, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x53, 0x50,
    0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70, 0x75, 0x74,
    0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63, 0x6f,
    0x6c, 0x6f, 0x72, 0x20, 0x3a, 0x20, 0x54, 0x45, 0x58, 0x43, 0x4f, 0x4f, 0x52, 0x44, 0x30, 0x3b,
    0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x67, 0x6c, 0x5f, 0x50,
    0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3a, 0x20, 0x53, 0x56, 0x5f, 0x50, 0x6f, 0x73,
    0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65,
    0x20, 0x31, 0x36, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65,
    0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e, 0x67,
    0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20, 0x76, 0x65, 0x72, 0x74, 0x5f, 0x6d,
    0x61, 0x69, 0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x36,
    0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x73, 0x2f, 0x73,
    0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e, 0x67, 0x6c, 0x73, 0x6c,
    0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f,
    0x6e, 0x20, 0x3d, 0x20, 0x6d, 0x75, 0x6c, 0x28, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e,
    0x2c, 0x20, 0x5f, 0x32, 0x31, 0x5f, 0x6d, 0x76, 0x70, 0x29, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e,
    0x65, 0x20, 0x31, 0x37, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c,
    0x65, 0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e,
    0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20,
    0x3d, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x53, 0x50, 0x49,
    0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x20,
    0x6d, 0x61, 0x69, 0x6e, 0x28, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73,
    0x5f, 0x49, 0x6e, 0x70, 0x75, 0x74, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70,
    0x75, 0x74, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69,
    0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70, 0x75, 0x74,
    0x2e, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x20, 0x3d, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e,
    0x70, 0x75, 0x74, 0x2e, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x76, 0x65, 0x72, 0x74, 0x5f, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20,
    0x20, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74,
    0x70, 0x75, 0x74, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74,
    0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70,
    0x75, 0x74, 0x2e, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d,
    0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3b, 0x0a, 0x20, 0x20,
    0x20, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x2e, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x20, 0x20,
    0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72, 0x6e, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f,
    0x75, 0x74, 0x70, 0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x00,
};
//
// static float4 frag_color;
// static float4 color;
//
// struct SPIRV_Cross_Input
// {
//     float4 color : TEXCOORD0;
// };
//
// struct SPIRV_Cross_Output
// {
//     float4 frag_color : SV_Target0;
// };
//
// #line 10 "src/examples/shaders/cube.glsl"
// void frag_main()
// {
// #line 10 "src/examples/shaders/cube.glsl"
//     frag_color = color;
// }
//
// SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
// {
//     color = stage_input.color;
//     frag_main();
//     SPIRV_Cross_Output stage_output;
//     stage_output.frag_color = frag_color;
//     return stage_output;
// }
//
const fs_source_hlsl4 = [519]u8{
    0x73, 0x74, 0x61, 0x74, 0x69, 0x63, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x66, 0x72,
    0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x73, 0x74, 0x61, 0x74, 0x69, 0x63,
    0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x0a,
    0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f,
    0x73, 0x73, 0x5f, 0x49, 0x6e, 0x70, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66,
    0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3a, 0x20, 0x54, 0x45,
    0x58, 0x43, 0x4f, 0x4f, 0x52, 0x44, 0x30, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72,
    0x75, 0x63, 0x74, 0x20, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f,
    0x4f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f,
    0x61, 0x74, 0x34, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3a,
    0x20, 0x53, 0x56, 0x5f, 0x54, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a,
    0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65,
    0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f,
    0x63, 0x75, 0x62, 0x65, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20,
    0x66, 0x72, 0x61, 0x67, 0x5f, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x23, 0x6c,
    0x69, 0x6e, 0x65, 0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61, 0x6d,
    0x70, 0x6c, 0x65, 0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75, 0x62,
    0x65, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x72, 0x61, 0x67,
    0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a,
    0x7d, 0x0a, 0x0a, 0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f,
    0x75, 0x74, 0x70, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x53, 0x50, 0x49, 0x52, 0x56,
    0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x49, 0x6e, 0x70, 0x75, 0x74, 0x20, 0x73, 0x74, 0x61,
    0x67, 0x65, 0x5f, 0x69, 0x6e, 0x70, 0x75, 0x74, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e,
    0x70, 0x75, 0x74, 0x2e, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66,
    0x72, 0x61, 0x67, 0x5f, 0x6d, 0x61, 0x69, 0x6e, 0x28, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x53, 0x50, 0x49, 0x52, 0x56, 0x5f, 0x43, 0x72, 0x6f, 0x73, 0x73, 0x5f, 0x4f, 0x75, 0x74, 0x70,
    0x75, 0x74, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75, 0x74, 0x3b,
    0x0a, 0x20, 0x20, 0x20, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70, 0x75,
    0x74, 0x2e, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x66,
    0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72,
    0x65, 0x74, 0x75, 0x72, 0x6e, 0x20, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x6f, 0x75, 0x74, 0x70,
    0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x00,
};
//
// #include <metal_stdlib>
// #include <simd/simd.h>
//
// using namespace metal;
//
// struct vs_params
// {
//     float4x4 mvp;
// };
//
// struct main0_out
// {
//     float4 color [[user(locn0)]];
//     float4 gl_Position [[position]];
// };
//
// struct main0_in
// {
//     float4 position [[attribute(0)]];
//     float4 color0 [[attribute(1)]];
// };
//
// #line 16 "src/examples/shaders/cube.glsl"
// vertex main0_out main0(main0_in in [[stage_in]], constant vs_params& _21 [[buffer(0)]])
// {
//     main0_out out = {};
// #line 16 "src/examples/shaders/cube.glsl"
//     out.gl_Position = _21.mvp * in.position;
// #line 17 "src/examples/shaders/cube.glsl"
//     out.color = in.color0;
//     return out;
// }
//
//
const vs_source_metal_macos = [635]u8{
    0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x20, 0x3c, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x5f,
    0x73, 0x74, 0x64, 0x6c, 0x69, 0x62, 0x3e, 0x0a, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65,
    0x20, 0x3c, 0x73, 0x69, 0x6d, 0x64, 0x2f, 0x73, 0x69, 0x6d, 0x64, 0x2e, 0x68, 0x3e, 0x0a, 0x0a,
    0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x6e, 0x61, 0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, 0x20,
    0x6d, 0x65, 0x74, 0x61, 0x6c, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x76,
    0x73, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66,
    0x6c, 0x6f, 0x61, 0x74, 0x34, 0x78, 0x34, 0x20, 0x6d, 0x76, 0x70, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a,
    0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75,
    0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e,
    0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34,
    0x20, 0x67, 0x6c, 0x5f, 0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x5b, 0x5b, 0x70,
    0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73,
    0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x69, 0x6e, 0x0a, 0x7b,
    0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x70, 0x6f, 0x73, 0x69,
    0x74, 0x69, 0x6f, 0x6e, 0x20, 0x5b, 0x5b, 0x61, 0x74, 0x74, 0x72, 0x69, 0x62, 0x75, 0x74, 0x65,
    0x28, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74,
    0x34, 0x20, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x20, 0x5b, 0x5b, 0x61, 0x74, 0x74, 0x72, 0x69,
    0x62, 0x75, 0x74, 0x65, 0x28, 0x31, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x23,
    0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x36, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61,
    0x6d, 0x70, 0x6c, 0x65, 0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75,
    0x62, 0x65, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x20,
    0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x28,
    0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x69, 0x6e, 0x20, 0x69, 0x6e, 0x20, 0x5b, 0x5b, 0x73, 0x74,
    0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x5d, 0x5d, 0x2c, 0x20, 0x63, 0x6f, 0x6e, 0x73, 0x74, 0x61,
    0x6e, 0x74, 0x20, 0x76, 0x73, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x26, 0x20, 0x5f, 0x32,
    0x31, 0x20, 0x5b, 0x5b, 0x62, 0x75, 0x66, 0x66, 0x65, 0x72, 0x28, 0x30, 0x29, 0x5d, 0x5d, 0x29,
    0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74,
    0x20, 0x6f, 0x75, 0x74, 0x20, 0x3d, 0x20, 0x7b, 0x7d, 0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65,
    0x20, 0x31, 0x36, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65,
    0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e, 0x67,
    0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6f, 0x75, 0x74, 0x2e, 0x67, 0x6c, 0x5f,
    0x50, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x3d, 0x20, 0x5f, 0x32, 0x31, 0x2e, 0x6d,
    0x76, 0x70, 0x20, 0x2a, 0x20, 0x69, 0x6e, 0x2e, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e,
    0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x37, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f,
    0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73,
    0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x6f, 0x75, 0x74, 0x2e, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d, 0x20, 0x69, 0x6e, 0x2e, 0x63,
    0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72,
    0x6e, 0x20, 0x6f, 0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
//
// #include <metal_stdlib>
// #include <simd/simd.h>
//
// using namespace metal;
//
// struct main0_out
// {
//     float4 frag_color [[color(0)]];
// };
//
// struct main0_in
// {
//     float4 color [[user(locn0)]];
// };
//
// #line 10 "src/examples/shaders/cube.glsl"
// fragment main0_out main0(main0_in in [[stage_in]])
// {
//     main0_out out = {};
// #line 10 "src/examples/shaders/cube.glsl"
//     out.frag_color = in.color;
//     return out;
// }
//
//
const fs_source_metal_macos = [399]u8{
    0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x20, 0x3c, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x5f,
    0x73, 0x74, 0x64, 0x6c, 0x69, 0x62, 0x3e, 0x0a, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65,
    0x20, 0x3c, 0x73, 0x69, 0x6d, 0x64, 0x2f, 0x73, 0x69, 0x6d, 0x64, 0x2e, 0x68, 0x3e, 0x0a, 0x0a,
    0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x6e, 0x61, 0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, 0x20,
    0x6d, 0x65, 0x74, 0x61, 0x6c, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d,
    0x61, 0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66,
    0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72,
    0x20, 0x5b, 0x5b, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x28, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d,
    0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x5f,
    0x69, 0x6e, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20,
    0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63,
    0x6e, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65,
    0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65,
    0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73, 0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e, 0x67,
    0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x66, 0x72, 0x61, 0x67, 0x6d, 0x65, 0x6e, 0x74, 0x20, 0x6d, 0x61,
    0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6d, 0x61, 0x69, 0x6e, 0x30, 0x28, 0x6d, 0x61,
    0x69, 0x6e, 0x30, 0x5f, 0x69, 0x6e, 0x20, 0x69, 0x6e, 0x20, 0x5b, 0x5b, 0x73, 0x74, 0x61, 0x67,
    0x65, 0x5f, 0x69, 0x6e, 0x5d, 0x5d, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6d, 0x61,
    0x69, 0x6e, 0x30, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6f, 0x75, 0x74, 0x20, 0x3d, 0x20, 0x7b, 0x7d,
    0x3b, 0x0a, 0x23, 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x31, 0x30, 0x20, 0x22, 0x73, 0x72, 0x63, 0x2f,
    0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x73, 0x2f, 0x73, 0x68, 0x61, 0x64, 0x65, 0x72, 0x73,
    0x2f, 0x63, 0x75, 0x62, 0x65, 0x2e, 0x67, 0x6c, 0x73, 0x6c, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20,
    0x6f, 0x75, 0x74, 0x2e, 0x66, 0x72, 0x61, 0x67, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x3d,
    0x20, 0x69, 0x6e, 0x2e, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72,
    0x65, 0x74, 0x75, 0x72, 0x6e, 0x20, 0x6f, 0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00,
};
pub fn cubeShaderDesc(backend: sg.Backend) sg.ShaderDesc {
    var desc: sg.ShaderDesc = .{};
    switch (backend) {
        .GLCORE33 => {
            desc.attrs[0].name = "position";
            desc.attrs[1].name = "color0";
            desc.vs.source = &vs_source_glsl330;
            desc.vs.entry = "main";
            desc.vs.uniform_blocks[0].size = 64;
            desc.vs.uniform_blocks[0].layout = .STD140;
            desc.vs.uniform_blocks[0].uniforms[0].name = "vs_params";
            desc.vs.uniform_blocks[0].uniforms[0].type = .FLOAT4;
            desc.vs.uniform_blocks[0].uniforms[0].array_count = 4;
            desc.fs.source = &fs_source_glsl330;
            desc.fs.entry = "main";
            desc.label = "cube_shader";
        },
        .D3D11 => {
            desc.attrs[0].sem_name = "TEXCOORD";
            desc.attrs[0].sem_index = 0;
            desc.attrs[1].sem_name = "TEXCOORD";
            desc.attrs[1].sem_index = 1;
            desc.vs.source = &vs_source_hlsl4;
            desc.vs.d3d11_target = "vs_4_0";
            desc.vs.entry = "main";
            desc.vs.uniform_blocks[0].size = 64;
            desc.vs.uniform_blocks[0].layout = .STD140;
            desc.fs.source = &fs_source_hlsl4;
            desc.fs.d3d11_target = "ps_4_0";
            desc.fs.entry = "main";
            desc.label = "cube_shader";
        },
        .METAL_MACOS => {
            desc.vs.source = &vs_source_metal_macos;
            desc.vs.entry = "main0";
            desc.vs.uniform_blocks[0].size = 64;
            desc.vs.uniform_blocks[0].layout = .STD140;
            desc.fs.source = &fs_source_metal_macos;
            desc.fs.entry = "main0";
            desc.label = "cube_shader";
        },
        else => {},
    }
    return desc;
}
