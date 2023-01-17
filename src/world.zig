const std = @import("std");
const extra = @import("extra.zig");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const dialog = @import("dialog.zig");
const assets = @import("assets.zig");
const znt = @import("znt.zig");
const ents = @import("entities.zig");
const back = @import("background.zig");
pub const chunk_size = 8 * 8;

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
    tiles: std.ArrayList(main.Sprite),
    colls: std.ArrayList(ColliderState)
};

pub const ColliderState = struct {
    amount: u32 = 0,
    id: znt.EntityId = 0,
    collider: extra.Rectangle
};

pub const Level = struct {
    const ProtoMap = []struct {
        width: u32,
        height: u32,
        uid: u32,
        color_a: extra.Color,
        color_b: extra.Color,
        tiles: [][6]f64,
        entities: []ents.Scene.OptionalEntity
    };

    color_a: extra.Color,
    color_b: extra.Color,

    chunks: std.AutoHashMap(Index, Chunk),
    scene: ents.Scene,

    const ChunkIterator = struct {
        parent: *Level,
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

    pub fn eachChunk(self: *Level, r: extra.Rectangle) ChunkIterator {
        var start = Index.fromVector(.{.x=r.x, .y=r.y});
        return ChunkIterator {
            .start = start,
            .end = Index.fromVector(.{.x=r.x+r.w, .y=r.y+r.h}),
            .index = start,
            .parent = self
        };
    }

    pub fn getChunk(self: *Level, index: Index) ?*Chunk {
        return self.chunks.getPtr(index);
    }

    pub fn getChunkOrCreate(self: *Level, index: Index, allocator: std.mem.Allocator) !*Chunk {
        var out = self.chunks.getPtr(index);

        if (out != null) return out.?;

        try self.chunks.put(index, .{
            .index = index,
            .tiles = std.ArrayList(main.Sprite).init(allocator),
            .colls = std.ArrayList(ColliderState).init(allocator)
        });
        return self.getChunkOrCreate(index, allocator);
    }

    pub fn addEntity(self: *Level, entity: ents.Scene.OptionalEntity, allocator: std.mem.Allocator) !void {
        var ent = ents.init(entity);
        var id = try self.scene.add(ent);

        //_ = id;
        if (ent.collider != null) {
            var collider = ent.collider.?;
            collider.x += ent.position.?.x;
            collider.y += ent.position.?.y;

            var iter = self.eachChunk(collider);
        
            while (try iter.nextOrCreate(allocator)) | chunk | {
                try chunk.colls.append(.{
                    .collider = collider,
                    .id = id
                });
            }
        }
    }

    pub fn delEntity(self: *Level, id: znt.EntityId) !void {
        var raw_collider = self.scene.getOne(.collider, id);

        if (raw_collider != null) {
            var collider = raw_collider.?.*;
            var position = self.scene.getOne(.collider, id) orelse unreachable;
            collider.x += position.x;
            collider.y += position.y;

            var iter = self.eachChunk(collider);
        
            while (iter.next()) | chunk | {
                for (chunk.colls.items) | coll, key | {
                    if (coll.id == id) { // Deletes itself
                        _ = chunk.colls.swapRemove(key);
                        continue;
                    }
                }
            }
        }

        try self.scene.del(id);
    }

    pub fn sortCollider(_: bool, a: extra.Collision, b: extra.Collision) bool {
        return a.near < b.near;
    }

    pub fn fromJSON(src: []const u8, allocator: std.mem.Allocator) ![]Level {
        var out = std.ArrayList(Level).init(allocator);
        var tokens = std.json.TokenStream.init(src);
        var raw = try std.json.parse(ProtoMap, &tokens, .{ .allocator = allocator, .ignore_unknown_fields = true });

        for (raw) | raw_level | {
            var out_level: Level = .{
                .chunks = std.AutoHashMap(Index, Chunk).init(allocator),
                .scene = ents.Scene.init(main.allocator),
                .color_a = raw_level.color_a,
                .color_b = raw_level.color_b
            };

            for (raw_level.tiles) | tile | {
                var t = main.Sprite {
                    .position = .{.x=tile[0], .y=tile[1]},
                    .origin = .{.x=tile[2], .y=tile[3], .w=tile[4], .h=tile[5]}
                };
                
                var chunk = try out_level.getChunkOrCreate(Index.fromVector(t.position), allocator);
                try chunk.tiles.append(t);
            }

            for (raw_level.entities) | ent | {
                try out_level.addEntity(ent, allocator);
            }

            try out.append(out_level);
        }

        return out.toOwnedSlice();
    }
};

var map:  []Level = undefined;
var level: *Level = undefined;

fn init() !void {
    map = try Level.fromJSON(assets.@"map_test.json", main.allocator);
    level = &map[1];
    try dialog.init(main.allocator);
}

fn loop(delta: f64) !void {
    var cam: extra.Rectangle = .{
        .x = main.real_camera.x - (main.width  / main.real_camera.z / 2), 
        .y = main.real_camera.y - (main.height / main.real_camera.z / 2),
        .w = main.width  / main.real_camera.z, 
        .h = main.height / main.real_camera.z
    };

    back.uniforms.color_a = level.color_a;
    back.uniforms.color_b = level.color_b;

    var iter = level.eachChunk(cam);
    while (iter.next()) | chunk | {
        for (chunk.tiles.items) | tile | {
            main.render(tile);
        }
        if (comptime main.DEBUGMODE) {
            //for (chunk.colls.items) | item | {
            //    main.rect(item.collider, .{.g=0, .b=0, .a=0.3});
            //}

            main.outlineRect(.{
                .x = @intToFloat(f64, chunk.index.x*chunk_size), 
                .y = @intToFloat(f64, chunk.index.y*chunk_size),
                .w = @intToFloat(f64, chunk_size), 
                .h = @intToFloat(f64, chunk_size)
            }, .{.a=0.3});
        }
    }

    try ents.process(&level.scene, level, delta);

    try dialog.loop(delta);
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};