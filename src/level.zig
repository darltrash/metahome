const msgpack = @import("fileformats/msgpack.zig");
const std = @import("std");

pub const ActorKinds = enum {
    Player, Enemy
};

pub const Actor = struct {
    x: f32,
    y: f32,
    z: f32,
    isPlayer: bool = false,
    vx: f32 = 0,
    vy: f32 = 0,
    vm: f32 = 50,

    sx: u32 = 0,
    sy: u32 = 0,
};

pub const Tile = struct {
    x: u32, y: u32, c: bool = false, sx: u32 = 0, sy: u32 = 0
};

pub const Level = struct {
    tiles: []Tile
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
                .c = c.Boolean,
                .sx = @intCast(u32, sx.UInt),
                .sy = @intCast(u32, sy.UInt),
            });
        }
        _ = try _worldlevels.append(Level{ .tiles = levtiles.toOwnedSlice() });
    }
    return World{ .levels = _worldlevels.toOwnedSlice() };
}
