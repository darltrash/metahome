const std = @import("std");
const extra = @import("extra.zig");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const dialog = @import("dialog.zig");
const assets = @import("assets.zig");
const znt = @import("znt.zig");
const chunk_size = 8 * 8;

const Index = struct {
    x: i16 = 0, 
    y: i16 = 0,

    pub fn fromVector(from: extra.Vector) Index {
        return .{ 
            .x = @floatToInt(i16, @divFloor(from.x, @intToFloat(f64, chunk_size))), 
            .y = @floatToInt(i16, @divFloor(from.y, @intToFloat(f64, chunk_size))) 
        };
    }
};

const Chunk = struct {
    index: Index,
    tiles: std.ArrayList(main.Sprite)
};

const World = struct {
    const Proto = struct {
        width: u32,
        height: u32,
        uid: u32,
        tiles: [][6]f64,
        //entities: []Entity
    };

    chunks: std.AutoHashMap(Index, Chunk),

    const ChunkIterator = struct {
        parent: *World = undefined,
        start: Index = .{},
        end: Index = .{},
        index: Index = .{},

        pub fn next(self: *ChunkIterator) ?*Chunk {
            while (self.index.y <= self.end.y) {
                var chunk = self.parent.getChunk(self.index);

                self.index.x += 1;
                if (self.index.x > self.end.x) {
                    self.index.x = self.start.x;
                    self.index.y += 1;
                }
                
                if (chunk != null)
                    return chunk;
            }
            return null;
        }

        pub fn nextOrCreate(self: *ChunkIterator, allocator: std.mem.Allocator) !?*Chunk {
            if (self.index.y > self.end.y) 
                return null;
            
            var chunk = try self.parent.getChunkOrCreate(self.index, allocator);

            self.index.x += 1;
            if (self.index.x > self.end.x) {
                self.index.x = self.start.x;
                self.index.y += 1;
            }
        
            return chunk;
        }
    };

    pub fn eachChunk(self: *World, r: extra.Rectangle) ChunkIterator {
        var start = Index.fromVector(.{.x=r.x, .y=r.y});
        return ChunkIterator {
            .start = start,
            .end = Index.fromVector(.{.x=r.x+r.w, .y=r.y+r.h}),
            .index = start,
            .parent = self
        };
    }

    pub fn getChunk(self: *World, index: Index) ?*Chunk {
        return self.chunks.getPtr(index);
    }

    pub fn getChunkOrCreate(self: *World, index: Index, allocator: std.mem.Allocator) !*Chunk {
        var chunk = self.chunks.getPtr(index);
        if (chunk == null)
            try self.chunks.put(index, .{
                .index = index,
                .tiles = std.ArrayList(main.Sprite).init(allocator)
            });
        
        return chunk orelse self.chunks.getPtr(index) orelse undefined;
    }

    pub fn fromJSON(src: []const u8, allocator: std.mem.Allocator) !World {
        var out: World = .{
            .chunks = std.AutoHashMap(Index, Chunk).init(allocator)
        };

        var tokens = std.json.TokenStream.init(src);
        var raw = try std.json.parse(Proto, &tokens, .{ .allocator = allocator });

        for (raw.tiles) | tile | {
            var t = main.Sprite {
                .position = .{.x=tile[0], .y=tile[1]},
                .origin = .{.x=tile[2], .y=tile[3], .w=tile[4], .h=tile[5]}
            };
            
            var chunk = try out.getChunkOrCreate(Index.fromVector(t.position), allocator);
            try chunk.tiles.append(t);
        }

        return out;
    }
};

var map: World = undefined;

const Scene = znt.Scene(struct {
    sprite:   main.Sprite,
    position: extra.Vector,
    velocity: extra.Vector,
    camera_focus: void
}, .{});

var scene: Scene = undefined;

fn init() !void {
    map = try World.fromJSON(assets.@"map_test.json", main.allocator);

    scene = Scene.init(main.allocator);
    _ = try scene.add(.{
        .position = .{.x=0, .y=0},
        .velocity = .{.x=5, .y=5},
        .sprite = .{
            .origin = .{
                .x=112, .y=0,
                .w=24,  .h=16
            }
        },
        .camera_focus = {}
    });
}

fn loop(delta: f64) !void {
    var cam: extra.Rectangle = .{
        .x = main.real_camera.x - (main.width  / main.real_camera.z / 2), 
        .y = main.real_camera.y - (main.height / main.real_camera.z / 2),
        .w = main.width  / main.real_camera.z, 
        .h = main.height / main.real_camera.z
    };

    var iter = map.eachChunk(cam);
    while (iter.next()) | chunk | {
        for (chunk.tiles.items) | tile | {
            main.render(tile);
        }
    }

    {
        var ents = scene.iter(&.{ .position, .velocity });
        while (ents.next()) | ent | {
            ent.position.* = ent.position.add(ent.velocity.mul_f64(delta));
        }
    }

    {
        var ents = scene.iter(&.{ .sprite });
        while (ents.next()) | ent | {
            var spr = ent.sprite.*;
            var pos = scene.getOne(.position, ent.id);
            if (pos != null) 
                spr.position = spr.position.add(pos.?.*);
            main.render(spr);
        }
    }

    {
        var ents = scene.iter(&.{ .camera_focus, .position });
        while (ents.next()) | ent | {
            main.camera = ent.position.*;
        }
    }

    try dialog.loop(delta);
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};

