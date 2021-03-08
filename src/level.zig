const msgpack = @import("fileformats/msgpack.zig");
const std = @import("std");
const main = @import("main.zig");
const math = @import("math.zig");

pub const ActorKinds = enum(u4) {
    Player, Puppet, Enemy
};

pub const Vec3 = struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,
};

pub const Sprite = struct {
    x: u32 = 0, y: u32 = 0
};

pub const Actor = struct {
    pos: Vec3 = .{ .x = 0, .y = 0, .z = 0 },
    vel: Vec3 = .{ .x = 0, .y = 0, .z = 0 },
    spr: Sprite = .{ .x = 0, .y = 0 },
    anim: f32 = 0,

    process: bool = true,
    visible: bool = true,

    flip_x: bool = false,
    flip_y: bool = false,

    kind: ActorKinds = undefined,

    pub fn processPlayer(actor: *Actor, delta: f32) void {
        var keys = main.getKeys();
        switch (@floatToInt(u32, actor.anim)) {
            0, 2 => actor.spr.x = 0,
            1 => actor.spr.x = 1,
            3 => actor.spr.x = 2,
            else => actor.anim = 0,
        }

        actor.vel.x = math.lerp(actor.vel.x, 0, delta * 15);
        actor.vel.y = math.lerp(actor.vel.y, 0, delta * 15);

        if (keys.down) {
            actor.vel.y += 20;
        }

        if (keys.right) {
            actor.vel.x += 20;
            actor.flip_x = false;
        }

        if (keys.up) {
            actor.vel.y -= 20;
        }

        if (keys.left) {
            actor.vel.x -= 20;
            actor.flip_x = true;
        }

        if ((keys.down and !keys.up) or
            (keys.right and !keys.left) or
            (keys.up and !keys.down) or
            (keys.left and !keys.right))
        {
            actor.anim += delta * 5; // Fun fact: spriteboy's animation is around 172 BPM
        } else {
            actor.anim = 0;
        }

        var camera = main.getCamera();
        camera.x = actor.pos.x;
        camera.y = actor.pos.y;
    }
};

pub const Tile = struct {
    x: u32, y: u32, collide: bool = false, spr: Sprite = .{ .x = 0, .y = 0 }
};

pub const Level = struct {
    tiles: []Tile,
    actors: []Actor,
};

pub const World = struct {
    levels: []Level
};

pub fn loadMap(data: []const u8) !World {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const alloc: *std.mem.Allocator = &arena.allocator;
    defer arena.deinit();

    var origin = try msgpack.decode(alloc, data);
    var _worldlevels = std.ArrayList(Level).init(std.heap.page_allocator);

    for (origin.data.Array) |layer| {
        var levtiles = std.ArrayList(Tile).init(std.heap.page_allocator);

        const tiles = try layer.get("tiles");
        for (tiles.Array) |tile| {
            var x = try tile.get("x");
            var y = try tile.get("y");
            var c = try tile.get("c");
            var sx = try tile.get("sx");
            var sy = try tile.get("sy");

            _ = try levtiles.append(Tile{
                .x = @intCast(u32, x.UInt),
                .y = @intCast(u32, y.UInt),
                .collide = c.Boolean,
                .spr = .{
                    .x = @intCast(u32, sx.UInt),
                    .y = @intCast(u32, sy.UInt),
                },
            });
        }

        var levactors = std.ArrayList(Actor).init(std.heap.page_allocator);
        _ = try levactors.append(Actor{ .kind = .Player });

        _ = try _worldlevels.append(Level{
            .tiles = levtiles.toOwnedSlice(),
            .actors = levactors.toOwnedSlice(),
        });
    }
    return World{ .levels = _worldlevels.toOwnedSlice() };
}
