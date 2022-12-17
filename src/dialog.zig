const std = @import("std");
const extra = @import("extra.zig");
const main = @import("rewrite.zig");
const input = @import("input.zig");

var at: usize = 0;
var cursor: f64 = 0;
var text: []const u8 = "";
var instructions: []Instruction = undefined;
var options: ?[]Option = null;
var selected: i8 = 0;
var selected_float: f64 = 0;

const Option = struct {
    text: []const u8 = "",
    goto: ?usize = 0
};

const InstructionTypes = enum {
    say, ask, goto, set, end
};

const Instruction = union(InstructionTypes) {
    say: []const u8,
    ask: struct {
        text: []const u8,
        options: []Option
    },
    goto: usize,
    set: bool,
    end: bool
};

fn advance() void {
    active = at < instructions.len;
    if (at >= instructions.len)
        return;

    cursor = 0;

    switch (instructions[at]) {
        .say => |t| {
            text = t;
            at += 1;
        },
        .ask => |q| {
            text = q.text;
            options = q.options;
            selected = 0;
            selected_float = 0;
            at += 1;
        },
        .goto => |g| {
            at = g;
            advance();
        },
        .set => unreachable,
        .end => at = instructions.len + 1  
    }
}

pub fn loadScript(source: []const u8) !void {
    var tokens = std.json.TokenStream.init(source);
    instructions = try std.json.parse([]Instruction, &tokens, .{ .allocator = main.allocator });
    at = 0;
    active = true;
    advance();
}

pub var active: bool = false;
var position: f64 = 1;

fn init() !void {
}

fn frame(r: extra.Rectangle) void {
    // Frame
    main.rect(.{ .x=r.x-3, .y=r.y-4, .w=r.w+6, .h=r.h+8}, .{});
    main.rect(.{ .x=r.x-4, .y=r.y-3, .w=r.w+8, .h=r.h+6}, .{});

    // Black space
    main.rect(r, .{.r=0, .g=0, .b=0});

    // Shadow
    main.rect(.{.x=r.x, .y=r.y, .w=r.w+4, .h=r.h+4}, .{.r=0, .g=0, .b=0, .a=0.6});
}

const highlight: extra.Color = .{.r=0.439, .g=0.682, .b=1, .a=1};

pub fn loop(delta: f64) !void {
    //_ = main.background(.{.r=0.439, .g=0.682, .b=1, .a=1});

    cursor += delta * 32;

    var f: f64 = if (active) 0 else 1;
    position = extra.lerp(f64, position, f, delta*8);

    var i = @floatToInt(usize, cursor);

    if (position > 0.99)
        return;

    var p = position * (main.height / main.real_camera.z / 2);

    if (options == null) {
        frame(.{ .x=-125+8, .y=p+(125-76), .w=250-16, .h=80-12});

        try main.print(.{
            .x=-125+16, .y=p+(125-60)
        }, text, i, 250-26, .{}, .{.r=0.439, .g=0.682, .b=1, .a=1});

    } else {
        frame(.{ .x=-125+8, .y=p+(125-76), .w=125-16, .h=80-12});
        frame(.{ .x=8, .y=p+(125-76), .w=125-16, .h=80-12});

        if (input.down(.up) == 2)
            selected -= 1;

        if (input.down(.down) == 2)
            selected += 1;

        selected = @mod(selected, @intCast(i8, options.?.len));

        try main.print(.{ .x=-125+16, .y=p+(125-60) }, text, i, 125-26, .{}, highlight);

        var k: usize = 0;
        for (options.?) | option | {
            var y = p+(125-60)+@intToFloat(f64, k*13);

            try main.print(.{ .x=16, .y=y }, option.text, i, 125-26, .{}, highlight);

            k += 1;
        }

        selected_float = extra.lerp(f64, selected_float, @intToFloat(f64, selected*13), delta * 16);

        try main.print(.{ .x=125-20, .y=p+(125-60)+selected_float }, "<", i, 125-26, .{}, null);
    }

    if (i > text.len and input.down(.action) > 0) {
        if (options != null) {
            at = options.?[@intCast(usize, selected)].goto orelse at;
            options = null;
        }
        advance();
    }
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};

