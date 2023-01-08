const sg = @import("sokol").gfx;
//
//  #version:1# (machine generated, don't edit!)
//
//  Generated by sokol-shdc (https://github.com/floooh/sokol-tools)
//
//  Cmdline: sokol-shdc -i src/shaders/output.glsl -o src/output.glsl.zig --slang glsl100:hlsl4 --format sokol_zig
//
//  Overview:
//
//      Shader program 'out':
//          Get shader desc: shd.outShaderDesc(sg.queryBackend());
//          Vertex shader: vs
//              Attribute slots:
//                  ATTR_vs_vx_position = 0
//          Fragment shader: fs
//              Image 'tex':
//                  Type: ._2D
//                  Component Type: .FLOAT
//                  Bind slot: SLOT_tex = 0
//
//
pub const ATTR_vs_vx_position = 0;
pub const SLOT_tex = 0;
//
// #version 100
// 
// attribute vec2 vx_position;
// varying vec2 position;
// 
// void main()
// {
//     gl_Position = vec4(vx_position, 1.0, 1.0);
//     position = (vx_position + vec2(1.0)) * vec2(0.5);
// }
// 
//
const vs_source_glsl100 = [185]u8 {
    0x23,0x76,0x65,0x72,0x73,0x69,0x6f,0x6e,0x20,0x31,0x30,0x30,0x0a,0x0a,0x61,0x74,
    0x74,0x72,0x69,0x62,0x75,0x74,0x65,0x20,0x76,0x65,0x63,0x32,0x20,0x76,0x78,0x5f,
    0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x76,0x61,0x72,0x79,0x69,0x6e,
    0x67,0x20,0x76,0x65,0x63,0x32,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x3b,
    0x0a,0x0a,0x76,0x6f,0x69,0x64,0x20,0x6d,0x61,0x69,0x6e,0x28,0x29,0x0a,0x7b,0x0a,
    0x20,0x20,0x20,0x20,0x67,0x6c,0x5f,0x50,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x20,
    0x3d,0x20,0x76,0x65,0x63,0x34,0x28,0x76,0x78,0x5f,0x70,0x6f,0x73,0x69,0x74,0x69,
    0x6f,0x6e,0x2c,0x20,0x31,0x2e,0x30,0x2c,0x20,0x31,0x2e,0x30,0x29,0x3b,0x0a,0x20,
    0x20,0x20,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x20,0x3d,0x20,0x28,0x76,
    0x78,0x5f,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x20,0x2b,0x20,0x76,0x65,0x63,
    0x32,0x28,0x31,0x2e,0x30,0x29,0x29,0x20,0x2a,0x20,0x76,0x65,0x63,0x32,0x28,0x30,
    0x2e,0x35,0x29,0x3b,0x0a,0x7d,0x0a,0x0a,0x00,
};
//
// #version 100
// precision mediump float;
// precision highp int;
// 
// uniform highp sampler2D tex;
// 
// varying highp vec2 position;
// 
// void main()
// {
//     gl_FragData[0] = texture2D(tex, position);
// }
// 
//
const fs_source_glsl100 = [185]u8 {
    0x23,0x76,0x65,0x72,0x73,0x69,0x6f,0x6e,0x20,0x31,0x30,0x30,0x0a,0x70,0x72,0x65,
    0x63,0x69,0x73,0x69,0x6f,0x6e,0x20,0x6d,0x65,0x64,0x69,0x75,0x6d,0x70,0x20,0x66,
    0x6c,0x6f,0x61,0x74,0x3b,0x0a,0x70,0x72,0x65,0x63,0x69,0x73,0x69,0x6f,0x6e,0x20,
    0x68,0x69,0x67,0x68,0x70,0x20,0x69,0x6e,0x74,0x3b,0x0a,0x0a,0x75,0x6e,0x69,0x66,
    0x6f,0x72,0x6d,0x20,0x68,0x69,0x67,0x68,0x70,0x20,0x73,0x61,0x6d,0x70,0x6c,0x65,
    0x72,0x32,0x44,0x20,0x74,0x65,0x78,0x3b,0x0a,0x0a,0x76,0x61,0x72,0x79,0x69,0x6e,
    0x67,0x20,0x68,0x69,0x67,0x68,0x70,0x20,0x76,0x65,0x63,0x32,0x20,0x70,0x6f,0x73,
    0x69,0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x0a,0x76,0x6f,0x69,0x64,0x20,0x6d,0x61,0x69,
    0x6e,0x28,0x29,0x0a,0x7b,0x0a,0x20,0x20,0x20,0x20,0x67,0x6c,0x5f,0x46,0x72,0x61,
    0x67,0x44,0x61,0x74,0x61,0x5b,0x30,0x5d,0x20,0x3d,0x20,0x74,0x65,0x78,0x74,0x75,
    0x72,0x65,0x32,0x44,0x28,0x74,0x65,0x78,0x2c,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,
    0x6f,0x6e,0x29,0x3b,0x0a,0x7d,0x0a,0x0a,0x00,
};
//
// static float4 gl_Position;
// static float2 vx_position;
// static float2 position;
// 
// struct SPIRV_Cross_Input
// {
//     float2 vx_position : TEXCOORD0;
// };
// 
// struct SPIRV_Cross_Output
// {
//     float2 position : TEXCOORD0;
//     float4 gl_Position : SV_Position;
// };
// 
// #line 10 "src/shaders/output.glsl"
// void vert_main()
// {
// #line 10 "src/shaders/output.glsl"
//     gl_Position = float4(vx_position, 1.0f, 1.0f);
// #line 11 "src/shaders/output.glsl"
//     position = (vx_position + 1.0f.xx) * 0.5f.xx;
// }
// 
// SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
// {
//     vx_position = stage_input.vx_position;
//     vert_main();
//     SPIRV_Cross_Output stage_output;
//     stage_output.gl_Position = gl_Position;
//     stage_output.position = position;
//     return stage_output;
// }
//
const vs_source_hlsl4 = [741]u8 {
    0x73,0x74,0x61,0x74,0x69,0x63,0x20,0x66,0x6c,0x6f,0x61,0x74,0x34,0x20,0x67,0x6c,
    0x5f,0x50,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x73,0x74,0x61,0x74,0x69,
    0x63,0x20,0x66,0x6c,0x6f,0x61,0x74,0x32,0x20,0x76,0x78,0x5f,0x70,0x6f,0x73,0x69,
    0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x73,0x74,0x61,0x74,0x69,0x63,0x20,0x66,0x6c,0x6f,
    0x61,0x74,0x32,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x0a,0x73,
    0x74,0x72,0x75,0x63,0x74,0x20,0x53,0x50,0x49,0x52,0x56,0x5f,0x43,0x72,0x6f,0x73,
    0x73,0x5f,0x49,0x6e,0x70,0x75,0x74,0x0a,0x7b,0x0a,0x20,0x20,0x20,0x20,0x66,0x6c,
    0x6f,0x61,0x74,0x32,0x20,0x76,0x78,0x5f,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,
    0x20,0x3a,0x20,0x54,0x45,0x58,0x43,0x4f,0x4f,0x52,0x44,0x30,0x3b,0x0a,0x7d,0x3b,
    0x0a,0x0a,0x73,0x74,0x72,0x75,0x63,0x74,0x20,0x53,0x50,0x49,0x52,0x56,0x5f,0x43,
    0x72,0x6f,0x73,0x73,0x5f,0x4f,0x75,0x74,0x70,0x75,0x74,0x0a,0x7b,0x0a,0x20,0x20,
    0x20,0x20,0x66,0x6c,0x6f,0x61,0x74,0x32,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,
    0x6e,0x20,0x3a,0x20,0x54,0x45,0x58,0x43,0x4f,0x4f,0x52,0x44,0x30,0x3b,0x0a,0x20,
    0x20,0x20,0x20,0x66,0x6c,0x6f,0x61,0x74,0x34,0x20,0x67,0x6c,0x5f,0x50,0x6f,0x73,
    0x69,0x74,0x69,0x6f,0x6e,0x20,0x3a,0x20,0x53,0x56,0x5f,0x50,0x6f,0x73,0x69,0x74,
    0x69,0x6f,0x6e,0x3b,0x0a,0x7d,0x3b,0x0a,0x0a,0x23,0x6c,0x69,0x6e,0x65,0x20,0x31,
    0x30,0x20,0x22,0x73,0x72,0x63,0x2f,0x73,0x68,0x61,0x64,0x65,0x72,0x73,0x2f,0x6f,
    0x75,0x74,0x70,0x75,0x74,0x2e,0x67,0x6c,0x73,0x6c,0x22,0x0a,0x76,0x6f,0x69,0x64,
    0x20,0x76,0x65,0x72,0x74,0x5f,0x6d,0x61,0x69,0x6e,0x28,0x29,0x0a,0x7b,0x0a,0x23,
    0x6c,0x69,0x6e,0x65,0x20,0x31,0x30,0x20,0x22,0x73,0x72,0x63,0x2f,0x73,0x68,0x61,
    0x64,0x65,0x72,0x73,0x2f,0x6f,0x75,0x74,0x70,0x75,0x74,0x2e,0x67,0x6c,0x73,0x6c,
    0x22,0x0a,0x20,0x20,0x20,0x20,0x67,0x6c,0x5f,0x50,0x6f,0x73,0x69,0x74,0x69,0x6f,
    0x6e,0x20,0x3d,0x20,0x66,0x6c,0x6f,0x61,0x74,0x34,0x28,0x76,0x78,0x5f,0x70,0x6f,
    0x73,0x69,0x74,0x69,0x6f,0x6e,0x2c,0x20,0x31,0x2e,0x30,0x66,0x2c,0x20,0x31,0x2e,
    0x30,0x66,0x29,0x3b,0x0a,0x23,0x6c,0x69,0x6e,0x65,0x20,0x31,0x31,0x20,0x22,0x73,
    0x72,0x63,0x2f,0x73,0x68,0x61,0x64,0x65,0x72,0x73,0x2f,0x6f,0x75,0x74,0x70,0x75,
    0x74,0x2e,0x67,0x6c,0x73,0x6c,0x22,0x0a,0x20,0x20,0x20,0x20,0x70,0x6f,0x73,0x69,
    0x74,0x69,0x6f,0x6e,0x20,0x3d,0x20,0x28,0x76,0x78,0x5f,0x70,0x6f,0x73,0x69,0x74,
    0x69,0x6f,0x6e,0x20,0x2b,0x20,0x31,0x2e,0x30,0x66,0x2e,0x78,0x78,0x29,0x20,0x2a,
    0x20,0x30,0x2e,0x35,0x66,0x2e,0x78,0x78,0x3b,0x0a,0x7d,0x0a,0x0a,0x53,0x50,0x49,
    0x52,0x56,0x5f,0x43,0x72,0x6f,0x73,0x73,0x5f,0x4f,0x75,0x74,0x70,0x75,0x74,0x20,
    0x6d,0x61,0x69,0x6e,0x28,0x53,0x50,0x49,0x52,0x56,0x5f,0x43,0x72,0x6f,0x73,0x73,
    0x5f,0x49,0x6e,0x70,0x75,0x74,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x69,0x6e,0x70,
    0x75,0x74,0x29,0x0a,0x7b,0x0a,0x20,0x20,0x20,0x20,0x76,0x78,0x5f,0x70,0x6f,0x73,
    0x69,0x74,0x69,0x6f,0x6e,0x20,0x3d,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x69,0x6e,
    0x70,0x75,0x74,0x2e,0x76,0x78,0x5f,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x3b,
    0x0a,0x20,0x20,0x20,0x20,0x76,0x65,0x72,0x74,0x5f,0x6d,0x61,0x69,0x6e,0x28,0x29,
    0x3b,0x0a,0x20,0x20,0x20,0x20,0x53,0x50,0x49,0x52,0x56,0x5f,0x43,0x72,0x6f,0x73,
    0x73,0x5f,0x4f,0x75,0x74,0x70,0x75,0x74,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x6f,
    0x75,0x74,0x70,0x75,0x74,0x3b,0x0a,0x20,0x20,0x20,0x20,0x73,0x74,0x61,0x67,0x65,
    0x5f,0x6f,0x75,0x74,0x70,0x75,0x74,0x2e,0x67,0x6c,0x5f,0x50,0x6f,0x73,0x69,0x74,
    0x69,0x6f,0x6e,0x20,0x3d,0x20,0x67,0x6c,0x5f,0x50,0x6f,0x73,0x69,0x74,0x69,0x6f,
    0x6e,0x3b,0x0a,0x20,0x20,0x20,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x6f,0x75,0x74,
    0x70,0x75,0x74,0x2e,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x20,0x3d,0x20,0x70,
    0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x20,0x20,0x20,0x20,0x72,0x65,0x74,
    0x75,0x72,0x6e,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x6f,0x75,0x74,0x70,0x75,0x74,
    0x3b,0x0a,0x7d,0x0a,0x00,
};
//
// Texture2D<float4> tex : register(t0);
// SamplerState _tex_sampler : register(s0);
// 
// static float4 frag_color;
// static float2 position;
// 
// struct SPIRV_Cross_Input
// {
//     float2 position : TEXCOORD0;
// };
// 
// struct SPIRV_Cross_Output
// {
//     float4 frag_color : SV_Target0;
// };
// 
// #line 12 "src/shaders/output.glsl"
// void frag_main()
// {
// #line 12 "src/shaders/output.glsl"
//     frag_color = tex.Sample(_tex_sampler, position);
// }
// 
// SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
// {
//     position = stage_input.position;
//     frag_main();
//     SPIRV_Cross_Output stage_output;
//     stage_output.frag_color = frag_color;
//     return stage_output;
// }
//
const fs_source_hlsl4 = [627]u8 {
    0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x32,0x44,0x3c,0x66,0x6c,0x6f,0x61,0x74,0x34,
    0x3e,0x20,0x74,0x65,0x78,0x20,0x3a,0x20,0x72,0x65,0x67,0x69,0x73,0x74,0x65,0x72,
    0x28,0x74,0x30,0x29,0x3b,0x0a,0x53,0x61,0x6d,0x70,0x6c,0x65,0x72,0x53,0x74,0x61,
    0x74,0x65,0x20,0x5f,0x74,0x65,0x78,0x5f,0x73,0x61,0x6d,0x70,0x6c,0x65,0x72,0x20,
    0x3a,0x20,0x72,0x65,0x67,0x69,0x73,0x74,0x65,0x72,0x28,0x73,0x30,0x29,0x3b,0x0a,
    0x0a,0x73,0x74,0x61,0x74,0x69,0x63,0x20,0x66,0x6c,0x6f,0x61,0x74,0x34,0x20,0x66,
    0x72,0x61,0x67,0x5f,0x63,0x6f,0x6c,0x6f,0x72,0x3b,0x0a,0x73,0x74,0x61,0x74,0x69,
    0x63,0x20,0x66,0x6c,0x6f,0x61,0x74,0x32,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,
    0x6e,0x3b,0x0a,0x0a,0x73,0x74,0x72,0x75,0x63,0x74,0x20,0x53,0x50,0x49,0x52,0x56,
    0x5f,0x43,0x72,0x6f,0x73,0x73,0x5f,0x49,0x6e,0x70,0x75,0x74,0x0a,0x7b,0x0a,0x20,
    0x20,0x20,0x20,0x66,0x6c,0x6f,0x61,0x74,0x32,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,
    0x6f,0x6e,0x20,0x3a,0x20,0x54,0x45,0x58,0x43,0x4f,0x4f,0x52,0x44,0x30,0x3b,0x0a,
    0x7d,0x3b,0x0a,0x0a,0x73,0x74,0x72,0x75,0x63,0x74,0x20,0x53,0x50,0x49,0x52,0x56,
    0x5f,0x43,0x72,0x6f,0x73,0x73,0x5f,0x4f,0x75,0x74,0x70,0x75,0x74,0x0a,0x7b,0x0a,
    0x20,0x20,0x20,0x20,0x66,0x6c,0x6f,0x61,0x74,0x34,0x20,0x66,0x72,0x61,0x67,0x5f,
    0x63,0x6f,0x6c,0x6f,0x72,0x20,0x3a,0x20,0x53,0x56,0x5f,0x54,0x61,0x72,0x67,0x65,
    0x74,0x30,0x3b,0x0a,0x7d,0x3b,0x0a,0x0a,0x23,0x6c,0x69,0x6e,0x65,0x20,0x31,0x32,
    0x20,0x22,0x73,0x72,0x63,0x2f,0x73,0x68,0x61,0x64,0x65,0x72,0x73,0x2f,0x6f,0x75,
    0x74,0x70,0x75,0x74,0x2e,0x67,0x6c,0x73,0x6c,0x22,0x0a,0x76,0x6f,0x69,0x64,0x20,
    0x66,0x72,0x61,0x67,0x5f,0x6d,0x61,0x69,0x6e,0x28,0x29,0x0a,0x7b,0x0a,0x23,0x6c,
    0x69,0x6e,0x65,0x20,0x31,0x32,0x20,0x22,0x73,0x72,0x63,0x2f,0x73,0x68,0x61,0x64,
    0x65,0x72,0x73,0x2f,0x6f,0x75,0x74,0x70,0x75,0x74,0x2e,0x67,0x6c,0x73,0x6c,0x22,
    0x0a,0x20,0x20,0x20,0x20,0x66,0x72,0x61,0x67,0x5f,0x63,0x6f,0x6c,0x6f,0x72,0x20,
    0x3d,0x20,0x74,0x65,0x78,0x2e,0x53,0x61,0x6d,0x70,0x6c,0x65,0x28,0x5f,0x74,0x65,
    0x78,0x5f,0x73,0x61,0x6d,0x70,0x6c,0x65,0x72,0x2c,0x20,0x70,0x6f,0x73,0x69,0x74,
    0x69,0x6f,0x6e,0x29,0x3b,0x0a,0x7d,0x0a,0x0a,0x53,0x50,0x49,0x52,0x56,0x5f,0x43,
    0x72,0x6f,0x73,0x73,0x5f,0x4f,0x75,0x74,0x70,0x75,0x74,0x20,0x6d,0x61,0x69,0x6e,
    0x28,0x53,0x50,0x49,0x52,0x56,0x5f,0x43,0x72,0x6f,0x73,0x73,0x5f,0x49,0x6e,0x70,
    0x75,0x74,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x69,0x6e,0x70,0x75,0x74,0x29,0x0a,
    0x7b,0x0a,0x20,0x20,0x20,0x20,0x70,0x6f,0x73,0x69,0x74,0x69,0x6f,0x6e,0x20,0x3d,
    0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x69,0x6e,0x70,0x75,0x74,0x2e,0x70,0x6f,0x73,
    0x69,0x74,0x69,0x6f,0x6e,0x3b,0x0a,0x20,0x20,0x20,0x20,0x66,0x72,0x61,0x67,0x5f,
    0x6d,0x61,0x69,0x6e,0x28,0x29,0x3b,0x0a,0x20,0x20,0x20,0x20,0x53,0x50,0x49,0x52,
    0x56,0x5f,0x43,0x72,0x6f,0x73,0x73,0x5f,0x4f,0x75,0x74,0x70,0x75,0x74,0x20,0x73,
    0x74,0x61,0x67,0x65,0x5f,0x6f,0x75,0x74,0x70,0x75,0x74,0x3b,0x0a,0x20,0x20,0x20,
    0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x6f,0x75,0x74,0x70,0x75,0x74,0x2e,0x66,0x72,
    0x61,0x67,0x5f,0x63,0x6f,0x6c,0x6f,0x72,0x20,0x3d,0x20,0x66,0x72,0x61,0x67,0x5f,
    0x63,0x6f,0x6c,0x6f,0x72,0x3b,0x0a,0x20,0x20,0x20,0x20,0x72,0x65,0x74,0x75,0x72,
    0x6e,0x20,0x73,0x74,0x61,0x67,0x65,0x5f,0x6f,0x75,0x74,0x70,0x75,0x74,0x3b,0x0a,
    0x7d,0x0a,0x00,
};
pub fn outShaderDesc(backend: sg.Backend) sg.ShaderDesc {
    var desc: sg.ShaderDesc = .{};
    switch (backend) {
        .GLES2 => {
            desc.attrs[0].name = "vx_position";
            desc.vs.source = &vs_source_glsl100;
            desc.vs.entry = "main";
            desc.fs.source = &fs_source_glsl100;
            desc.fs.entry = "main";
            desc.fs.images[0].name = "tex";
            desc.fs.images[0].image_type = ._2D;
            desc.fs.images[0].sampler_type = .FLOAT;
            desc.label = "out_shader";
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
            desc.fs.images[0].name = "tex";
            desc.fs.images[0].image_type = ._2D;
            desc.fs.images[0].sampler_type = .FLOAT;
            desc.label = "out_shader";
        },
        else => {},
    }
    return desc;
}