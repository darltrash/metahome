const msgpack = @import("fileformats/msgpack.zig");
const std = @import("std");

pub const ActorKinds = enum(u4) {
    Player, Enemy
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
