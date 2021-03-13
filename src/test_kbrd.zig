const DEBUGMODE = @import("builtin").mode == @import("builtin").Mode.Debug;

const std = @import("std");

const sg = @import("sokol").gfx;
const sapp = @import("sokol").app;
const stime = @import("sokol").time;
const sgapp = @import("sokol").app_gfx_glue;
const sdtx = @import("sokol").debugtext;
const sa = @import("sokol").audio;

////////////////////////////////////////////////////////////////////////////////////////////////

var pass_action: sg.PassAction = .{};
var pip: sg.Pipeline = .{};
var bind: sg.Bindings = .{};

export fn audio(buffer: [*c]f32, frames: i32, channels: i32) void {}

export fn init() void {
    sa.setup(.{ .stream_cb = audio });

    sg.setup(.{ .context = sgapp.context() });
    pass_action.colors[0] = .{
        .action = .CLEAR,
        .value = .{ .r = 0.08, .g = 0.08, .b = 0.11, .a = 1.0 }, // HELLO EIGENGRAU!
    };

    stime.setup();

    var sdtx_desc: sdtx.Desc = .{};
    sdtx_desc.fonts[0] = @import("fontdata.zig").fontdesc;
    sdtx.setup(sdtx_desc);
    sdtx.font(0);
}

////////////////////////////////////////////////////////////////////////////////////////////////

var screenWidth: f32 = 0;
var screenHeight: f32 = 0;

var delta: f32 = 0;
var last_time: u64 = 0;

var row: i16 = 0;
var column: i16 = 0;

var abc = "abcdefghijklmnopqrstuvwxyz";
var name = [6]u8{ 95, 95, 95, 95, 95, 95 }; // Create name string filled with "_"s
var cur: usize = 0;

export fn frame() void {
    var rowsize: i16 = if (column == 2) 7 else 8;

    if (keys.jst_left) {
        row -= 1;
        if (row < 0) {
            row = rowsize;
        }
    } else if (keys.jst_right) {
        row += 1;
        if (row > rowsize) {
            row = 0;
        }
    }

    if (keys.jst_up) {
        if (column == 0 and row == 8) {
            row = 7;
        }
        column -= 1;
        if (column < 0) {
            column = 2;
        }
    } else if (keys.jst_down) {
        if (column == 1 and row == 8) {
            row = 7;
        }
        column += 1;
        if (column > 2) {
            column = 0;
        }
    }

    screenWidth = sapp.widthf();
    screenHeight = sapp.heightf();
    sdtx.canvas(screenWidth * 0.5, screenHeight * 0.5);
    sdtx.origin(1, 1);

    sdtx.color1i(0xFFFFFFFF);
    sdtx.print("tell me your name!\n\n   ", .{});

    for (name) |char| {
        if (char == 95) { // "_"
            sdtx.color1i(0x55FFFFFF);
        } else {
            sdtx.color1i(0xFFFFFFFF);
        }
        sdtx.putc(char);
        sdtx.putc(32); // SPACE
    }
    sdtx.print("\n\n\n", .{});

    var cnt: u16 = 0;
    var lin: u8 = 0;
    for (abc) |char, indx| {
        if (lin == column and row == cnt) {
            sdtx.color1i(0xFFFFAE00); // HIGHLIGHT THINGS UP
            sdtx.putc(char - 32); // .... YEA!

            if (keys.jst_attack and cur != 6) {
                name[cur] = char;
                cur += 1;
            } else if (keys.jst_cancel and cur != 0) {
                cur -= 1;
                name[cur] = 95; // "_"
            }
        } else {
            sdtx.color1i(0x77FFFFFF);
            sdtx.putc(char);
        }
        sdtx.putc(32); // SPACE
        cnt += 1;
        if (cnt == 9) {
            sdtx.putc(10); // LINE BREAK
            cnt = 0;
            lin += 1;
        }
    }

    sdtx.origin(24, 0);
    sdtx.pos(24, 0);
    sdtx.putc(10);

    sdtx.color1i(0xFFFFAE00);
    sdtx.print("X", .{});
    sdtx.color1i(0xFFFFFFFF);
    sdtx.print(": delete character\n\n", .{});
    sdtx.color1i(0xFFFFAE00);
    sdtx.print("C", .{});
    sdtx.color1i(0xFFFFFFFF);
    sdtx.print(": add character\n\n", .{});
    sdtx.color1i(0xFFFFAE00);
    sdtx.print("INTRO", .{});
    sdtx.color1i(0xFFFFFFFF);
    sdtx.print(": done\n\n", .{});

    sdtx.color1i(0xFFf5427b);
    sdtx.print(
        \\ WARNING:
        \\
        \\ you WONT be able to change 
        \\ your name, be careful.
        \\
    , .{});

    sg.beginDefaultPass(pass_action, sapp.width(), sapp.height());

    sdtx.draw();

    sg.endPass();
    sg.commit();

    delta = @floatCast(f32, stime.sec(stime.laptime(&last_time)));

    keys.jst_up = false;
    keys.jst_down = false;
    keys.jst_left = false;
    keys.jst_right = false;

    keys.jst_enter = false;
    keys.jst_cancel = false;
    keys.jst_attack = false;
}

////////////////////////////////////////////////////////////////////////////////////////////////

const _keystruct = packed struct {
    up: bool = false,
    down: bool = false,
    jst_up: bool = false,
    jst_down: bool = false,

    left: bool = false,
    right: bool = false,
    jst_left: bool = false,
    jst_right: bool = false,

    enter: bool = false,
    cancel: bool = false,
    attack: bool = false,
    any: bool = false,
    jst_enter: bool = false,
    jst_cancel: bool = false,
    jst_attack: bool = false,

    home: bool = false,
};
var keys = _keystruct{};

const _mousestruct = struct {
    x: f32 = 0,
    y: f32 = 0,
    dx: f32 = 0,
    dy: f32 = 0,
    left: bool = false,
    middle: bool = false,
    right: bool = false,
    any: bool = false,
};
var mouse = _mousestruct{};

export fn input(ev: ?*const sapp.Event) void {
    const event = ev.?;
    if ((event.type == .KEY_DOWN) or (event.type == .KEY_UP)) {
        const key_pressed = event.type == .KEY_DOWN;
        keys.any = key_pressed;
        switch (event.key_code) {
            .UP => {
                keys.jst_up = key_pressed and !keys.up;
                keys.up = key_pressed;
            },
            .DOWN => {
                keys.jst_down = key_pressed and !keys.down;
                keys.down = key_pressed;
            },
            .LEFT => {
                keys.jst_left = key_pressed and !keys.left;
                keys.left = key_pressed;
            },
            .RIGHT => {
                keys.jst_right = key_pressed and !keys.right;
                keys.right = key_pressed;
            },

            .ENTER => {
                keys.jst_enter = key_pressed and !keys.enter;
                keys.enter = key_pressed;
            },
            .X => {
                keys.jst_cancel = key_pressed and !keys.cancel;
                keys.cancel = key_pressed;
            },
            .C => {
                keys.jst_attack = key_pressed and !keys.attack;
                keys.attack = key_pressed;
            },

            .BACKSPACE => keys.home = key_pressed,
            else => {},
        }
    } else if ((event.type == .MOUSE_DOWN) or (event.type == .MOUSE_UP)) {
        const mouse_pressed = event.type == .MOUSE_DOWN;
        mouse.any = mouse_pressed;
        switch (event.mouse_button) {
            .LEFT => mouse.left = mouse_pressed,
            .MIDDLE => mouse.middle = mouse_pressed,
            .RIGHT => mouse.right = mouse_pressed,
            else => {},
        }
    } else if (event.type == .MOUSE_MOVE) {
        mouse.x = event.mouse_x;
        mouse.y = event.mouse_y;

        mouse.dx = event.mouse_dx;
        mouse.dy = event.mouse_dy;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .event_cb = input,
        .width = 1024,
        .height = 600,
        .window_title = "m e t a h o m e",
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////

export fn cleanup() void {
    sg.shutdown();
    sa.shutdown();
}
