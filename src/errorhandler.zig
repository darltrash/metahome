const std   = @import("std");

const sg    = @import("sokol").gfx;
const sapp  = @import("sokol").app;
const sgapp = @import("sokol").app_gfx_glue;
const sdtx  = @import("sokol").debugtext;

var pass_action: sg.PassAction = .{};

var GPA = std.heap.GeneralPurposeAllocator(.{}){};
var errmsg: []const u8 = undefined;

export fn errinit() void {
    sg.setup(.{ .context = sgapp.context() });

    var sdtx_desc: sdtx.Desc = .{};
    sdtx_desc.fonts[1] = sdtx.fontKc853();

    sdtx.setup(sdtx_desc);
    pass_action.colors[0] = .{ .action = .CLEAR, .value = .{ .r=0, .g=0.125, .b=0.25, .a=1 }};
}

export fn errframe() void {
    sdtx.canvas(sapp.widthf()*0.5, sapp.heightf()*0.5);
    sdtx.origin(0.0, 2.0);
    sdtx.home();

    sdtx.font(1);
    sdtx.color1i(0xFFFF0077);
    sdtx.puts("SOMETHING BROKE!\n");

    sg.beginDefaultPass(pass_action, sapp.width(), sapp.height());
    sdtx.draw();
    sg.endPass();
    sg.commit();
}

export fn errcleanup() void {
    sdtx.shutdown();
    sg.shutdown();
}

pub fn handle(msg: [*c]const u8) void {
    sapp.run(.{
        .init_cb = errinit,
        .frame_cb = errframe,
        .cleanup_cb = errcleanup,
        .width = 1024,
        .height = 600,
        .window_title = "h o m e c r a s h",
    });
}
