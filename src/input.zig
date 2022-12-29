const sapp = @import("sokol").app;
const std = @import("std");
const ini = @import("ini");

// TODO: Fix down values not being at 1 when just pressed

pub const InputMethod = enum {
    keyboard, gamepad
};

pub const InputMap = union (InputMethod) {
    keyboard: sapp.Keycode,
    gamepad: u32,
};

pub const InputKind = enum {
    up, down, left, right,
    action, menu
};

var input_map:  std.AutoHashMap(InputMap,  InputKind) = undefined;
var kind_state: std.AutoHashMap(InputKind, u32)       = undefined;

pub fn setup(alloc: std.mem.Allocator) !void {
    input_map  = @TypeOf(input_map).init(alloc);
    kind_state = @TypeOf(kind_state).init(alloc);

    try register(.{.keyboard = sapp.Keycode.UP   }, .up);
    try register(.{.keyboard = sapp.Keycode.DOWN }, .down);
    try register(.{.keyboard = sapp.Keycode.LEFT }, .left);
    try register(.{.keyboard = sapp.Keycode.RIGHT}, .right);
    try register(.{.keyboard = sapp.Keycode.X},     .action);
    try register(.{.keyboard = sapp.Keycode.C},     .menu);

    try register(.{.keyboard = sapp.Keycode.W }, .up);
    try register(.{.keyboard = sapp.Keycode.S }, .down);
    try register(.{.keyboard = sapp.Keycode.A }, .left);
    try register(.{.keyboard = sapp.Keycode.D},  .right);
    try register(.{.keyboard = sapp.Keycode.ENTER},        .action);
    try register(.{.keyboard = sapp.Keycode.RIGHT_SHIFT},  .menu);
}

pub fn register(what: InputMap, to: InputKind) !void {
    try input_map.put(what, to);
}

pub fn handle(ev: *const sapp.Event) !void {
    switch (ev.type) {
        .KEY_UP, .KEY_DOWN => {
            if (ev.key_repeat) return;

            var map = input_map.get(.{ .keyboard = ev.key_code }) orelse return;

            try kind_state.put(map, if (ev.type == .KEY_UP) 0 else 1);
        },
        else => {}
    }
}

pub fn update() void {
    var a = kind_state.valueIterator();
    while (a.next()) | v | {
        if (v.* > 0)
            v.* += 1;
    }
}

pub fn down(a: InputKind) u32 {
    return kind_state.get(a) orelse 0;
}