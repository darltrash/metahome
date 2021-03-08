const sg = @import("sokol").gfx;
const sapp = @import("sokol").app;
const sgapp = @import("sokol").app_gfx_glue;
const stm = @import("sokol").time;
const sdtx = @import("sokol").debugtext;

const std = @import("std");
const fmt = @import("std").fmt;

fn script() void {
    _ = say(.{
        .o = "rack",
        .m =
        \\hello! my name's rack!
        \\it's a pleasure to meet you!
    });
    var v = switch (say(.{
        .o = "rack",
        .m = "everything's fine?",
        .p = [4][]const u8{ "yup :)", "nope :(", undefined, undefined },
    })) {
        0 => {
            _ = say(.{
                .o = "rack",
                .m =
                \\that's great, dude!
                \\i'm glad you're glad :)
            });
        },

        1 => {
            _ = say(.{
                .o = "rack",
                .m =
                \\aw shucks man, that sucks.
                \\i hope everything gets- 
                \\better from now on...
            });
        },

        else => unreachable,
    };
    stop();
}

var scriptframe: @Frame(script) = undefined;
var pass_action: sg.PassAction = .{};

export fn init() void {
    stm.setup();
    sg.setup(.{ .context = sgapp.context() });

    var sdtx_desc: sdtx.Desc = .{};
    sdtx_desc.fonts[0] = @import("fontdata.zig").fontdesc;
    sdtx.setup(sdtx_desc);

    pass_action.colors[0] = .{
        .action = .CLEAR,
        .value = .{ .r = 0, .g = 0.125, .b = 0.25, .a = 1 },
    };

    scriptframe = async script();
}

////////////////////////////////////////////////////////////////////////////////////////

pub const dialogline = struct {
    o: []const u8 = "UNKN_WN", m: []const u8 = "FLAGRANT ERROR!", // lets rant about flags for a second
    p: [4][]const u8 = undefined
};

var sintime: f32 = 0;

var continueDialog: bool = true;
var currentDialog: dialogline = undefined;

var length: f32 = 0;
var speed: f32 = 4;
var busy: bool = true;
var selection: u8 = 0;

var sayframe: anyframe = undefined;

pub fn say(what: dialogline) u8 {
    sayframe = @frame();

    selection = 0;
    length = 0;
    currentDialog = what;
    suspend;

    return selection;
}

pub fn stop() void {
    busy = false;
}

const name = "metahome";
var frame_count: u32 = 0;
var time_stamp: u64 = 0;

export fn frame() void {
    frame_count += 1;
    const delta = @floatCast(f32, stm.ms(stm.laptime(&time_stamp)) * 0.005);

    sdtx.canvas(sapp.widthf() * 0.5, sapp.heightf() * 0.5);
    sdtx.origin(4, 11);
    sdtx.font(0);

    if (busy) {
        sintime += delta;

        sdtx.color3b(0xbb, 0xaa, 0xff);
        sdtx.print("{s}:\n", .{currentDialog.o});
        sdtx.crlf();

        sdtx.moveY(-0.5);
        sdtx.color3b(0xff, 0xff, 0xff);
        sdtx.print("{s}", .{currentDialog.m[0..@floatToInt(u32, length)]});
        sdtx.crlf();

        if (@floatToInt(u32, length) < currentDialog.m.len) {
            if (currentDialog.m[@floatToInt(u32, length)] == 17) {
                resume sayframe;
            }

            if (keys.skp) {
                length += speed * 2 * delta;
            } else {
                length += speed * delta;
            }
        } else {
            var maxselect: u8 = 4;
            var skipped: bool = false;

            sdtx.moveY(0.5);

            var mx: f32 = 0;
            var my: f32 = 0;

            for (currentDialog.p) |option, indx| {
                if (option.len == 0) {
                    maxselect = @intCast(u8, indx);
                    skipped = (indx == 0);
                    break;
                }

                if ((@mod(@intToFloat(f32, indx), 2)) == 0) {
                    mx = @sin(sintime / 2) / 8;
                    my = @cos(sintime / 2) / 8;
                } else {
                    mx = @cos(sintime / 2) / 8;
                    my = @sin(sintime / 2) / 8;
                }

                sdtx.move(mx, my);
                if (indx == selection) {
                    sdtx.color3b(0xff, 0xe4, 0x78);
                    sdtx.print(">", .{});
                } else {
                    sdtx.color3b(0xff, 0xaa, 0xd0);
                    sdtx.print(" ", .{});
                }

                sdtx.print("{s}  ", .{option});
                sdtx.move(-mx, -my);
            }

            if (skipped) {
                mx = @sin(sintime / 2) / 8;
                my = @cos(sintime / 2) / 8;

                sdtx.move(mx, my);
                sdtx.color3b(0xff, 0xe4, 0x78);
                sdtx.print(">next", .{});
                sdtx.move(-mx, -my);
            } else {
                if (keys.jst_rig) {
                    if (selection == maxselect - 1) {
                        selection = 0;
                    } else {
                        selection += 1;
                    }
                }

                if (keys.jst_lef) {
                    if (selection == 0) {
                        selection = maxselect - 1;
                    } else {
                        selection -= 1;
                    }
                }
            }

            if (keys.nxt) {
                resume sayframe;
            }
        }
    } else {
        sintime += delta / 2;
        for (name) |char, indx| {
            sdtx.putc(char);
            sdtx.crlf();
            sdtx.posX(@intToFloat(f32, indx + 1));
            sdtx.posY(@sin(sintime + @intToFloat(f32, indx + 1)));
        }
    }

    sg.beginDefaultPass(pass_action, sapp.width(), sapp.height());
    sdtx.draw();
    sg.endPass();
    sg.commit();

    keys.jst_lef = false;
    keys.jst_rig = false;
}

export fn cleanup() void {
    sdtx.shutdown();
    sg.shutdown();
}

const _keystruct = struct {
    nxt: bool = false, skp: bool = false, any: bool = false, lef: bool = false, rig: bool = false, jst_lef: bool = false, jst_rig: bool = false
};
var keys = _keystruct{};

export fn input(ev: ?*const sapp.Event) void {
    const event = ev.?;
    if ((event.type == .KEY_DOWN) or (event.type == .KEY_UP)) {
        const key_pressed = event.type == .KEY_DOWN;
        keys.any = key_pressed;
        switch (event.key_code) {
            .X => keys.skp = key_pressed,
            .C => keys.nxt = key_pressed,
            .LEFT => {
                keys.jst_lef = key_pressed and !keys.lef;
                keys.lef = key_pressed;
            },
            .RIGHT => {
                keys.jst_rig = key_pressed and !keys.rig;
                keys.rig = key_pressed;
            },
            else => {},
        }
    }
}

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .event_cb = input,
        .width = 640,
        .height = 480,
        .window_title = "METAHOME DEBUGTEXT BUILD",
    });
}
