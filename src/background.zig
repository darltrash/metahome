const sg = @import("sokol").gfx;
const sapp = @import("sokol").app;
const sgapp = @import("sokol").app_gfx_glue;
const shd = @import("shaders/background.glsl.zig");
const extra = @import("extra.zig");
const rewrite = @import("rewrite.zig");

const state = struct {
    var bind: sg.Bindings = .{};
    var pip: sg.Pipeline = .{};
    var pass_action: sg.PassAction = .{};
};

pub var uniforms: shd.VsUniforms = .{ 
    .color_a = extra.Color.fromHex(0x0d02c1ff), 
    .color_b = extra.Color.fromHex(0xff5294ff), 
    .resolution = undefined, .time = 0 
};

pub fn init() !void {
    state.bind.vertex_buffers[0] = sg.makeBuffer(.{ 
        .data = sg.asRange(&[_]f32{ -1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0 }) 
    });

    state.bind.index_buffer = sg.makeBuffer(.{ 
        .type = .INDEXBUFFER, 
        .data = sg.asRange(&[_]u16{ 0, 1, 2, 0, 2, 3 }) 
    });

    var pip_desc: sg.PipelineDesc = .{
        .index_type = .UINT16,
        .shader = sg.makeShader(shd.quadShaderDesc(sg.queryBackend())),
    };
    pip_desc.layout.attrs[shd.ATTR_vs_vx_position].format = .FLOAT2;
    state.pip = sg.makePipeline(pip_desc);

    state.pass_action.colors[0] = .{ .action = .CLEAR, .value = .{ .r = 0, .g = 0, .b = 0, .a = 1 } };
}

pub fn render() !void {
    uniforms.resolution[0] = @floatCast(f32, rewrite.width  / @floor(rewrite.real_camera.z));
    uniforms.resolution[1] = @floatCast(f32, rewrite.height / @floor(rewrite.real_camera.z));
    uniforms.time = @floatCast(f32, rewrite.timer);

    sg.beginDefaultPass(state.pass_action, sapp.width(), sapp.height());
    sg.applyPipeline(state.pip);
    sg.applyBindings(state.bind);
    sg.applyUniforms(sg.ShaderStage.FS, 0, sg.asRange(&uniforms));
    sg.draw(0, 6, 1);
    sg.endPass();
}
