const std = @import("std");
const extra = @import("extra.zig");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const dialog = @import("dialog.zig");
//const znt = @import("znt.zig");

const Controller = enum {
    player
};

//const Scene = znt.Scene(struct {
//    sprite: main.Sprite,
//    position: extra.Vector,
//    velocity: extra.Vector,
//    controller: Controller
//}, .{});
//
//var scene: Scene = undefined;

fn init() !void {
    //scene = Scene.init(main.allocator);
    //_ = try scene.add(.{ 
    //    .position = .{}, 
    //    .velocity = .{}, 
    //    .sprite = .{
    //        .x=56, .y=32, .w=16, .h=16
    //    },
    //    .controller = .player
    //});

    try dialog.loadScript(@embedFile("script.json"));
}

fn loop(delta: f64) !void {
    //var it = scene.iter(&.{.position, .sprite});
    //while (it.next()) |ent| {
    //    main.render(ent.sprite.*);
    //}

    try dialog.loop(delta);
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};

