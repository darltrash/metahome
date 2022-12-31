const std = @import("std");
const extra = @import("extra.zig");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const dialog = @import("dialog.zig");
const assets = @import("assets.zig");
const znt = @import("znt.zig");
const ents = @import("entities.zig");
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

pub const World = struct {
    const Proto = struct {
        width: u32,
        height: u32,
        uid: u32,
        tiles: [][6]f64,
        entities: []ents.Scene.OptionalEntity
    };

    chunks: std.AutoHashMap(Index, Chunk),
    scene: ents.Scene,

    const ChunkIterator = struct {
        parent: *World,
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
        if (self.chunks.getPtr(index) == null)
            try self.chunks.put(index, .{
                .index = index,
                .tiles = std.ArrayList(main.Sprite).init(allocator),
                .colls = std.ArrayList(ColliderState).init(allocator)
            });
        
        return self.chunks.getPtr(index) orelse unreachable;
    }

    pub fn addEntity(self: *World, entity: ents.Scene.OptionalEntity, _: std.mem.Allocator) !void {
        var ent = ents.init(entity);
        var id = try self.scene.add(ent);

        //_ = id;
        if (ent.collider != null) {
            var iter = map.eachChunk(ent.collider.?);
        
            while (iter.next()) | chunk | {
                try chunk.colls.append(.{
                    .collider = ent.collider.?,
                    .id = id
                });
            }
        }
    }

    pub fn sortCollider(_: bool, a: extra.Collision, b: extra.Collision) bool {
        return a.near < b.near;
    }

    pub fn fromJSON(src: []const u8, allocator: std.mem.Allocator) !World {
        var out: World = .{
            .chunks = std.AutoHashMap(Index, Chunk).init(allocator),
            .scene = ents.Scene.init(main.allocator)
        };

        var tokens = std.json.TokenStream.init(src);
        var raw = try std.json.parse(Proto, &tokens, .{ .allocator = allocator, .ignore_unknown_fields = true });

        for (raw.tiles) | tile | {
            var t = main.Sprite {
                .position = .{.x=tile[0], .y=tile[1]},
                .origin = .{.x=tile[2], .y=tile[3], .w=tile[4], .h=tile[5]}
            };
            
            var chunk = try out.getChunkOrCreate(Index.fromVector(t.position), allocator);
            try chunk.tiles.append(t);
        }

        for (raw.entities) | ent | {
            try out.addEntity(ent, allocator);
        }

        return out;
    }
};

var map: World = undefined;

fn init() !void {
    map = try World.fromJSON(assets.@"map_test.json", main.allocator);
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
        if (comptime main.DEBUGMODE) {
            //for (chunk.colls.items) | item | {
            //    main.rect(item.collider, .{.g=0, .b=0, .a=0.3});
            //}

            //main.outlineRect(.{
            //    .x = @intToFloat(f64, chunk.index.x*chunk_size), 
            //    .y = @intToFloat(f64, chunk.index.y*chunk_size),
            //    .w = @intToFloat(f64, chunk_size), 
            //    .h = @intToFloat(f64, chunk_size)
            //}, .{.a=0.3});
        }
    }

    try ents.process(map.scene, &map, delta);

    try dialog.loop(delta);
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};

