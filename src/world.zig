const std = @import("std");
const extra = @import("extra.zig");
const main = @import("main.zig");
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
    const ProtoLevel = struct {
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

    pub fn addEntity(self: *Level, entity: ents.Scene.OptionalEntity, allocator: std.mem.Allocator) !znt.EntityId {
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

        return id;
    }

    pub fn delEntity(self: *Level, id: znt.EntityId) !void {
        var raw_collider = self.scene.getOne(.collider, id);

        if (raw_collider != null) {
            var collider = raw_collider.?.*;
            var position = self.scene.getOne(.position, id) orelse unreachable;
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
};

pub const Map = struct {
    pub const EntityReference = struct {
        entity: znt.EntityId,
        level: ?usize = null
    };

    transition: ?f64 = null,
    transition_state: f64 = 0,

    camera: extra.Vector = .{},

    levels: []Level,
    current: *Level,
    next_level: ?*Level = null,
    delete_entity: ?znt.EntityId = null,
    entity_uuids: std.AutoHashMap(u32, EntityReference),

    pub fn addEntity(self: *Map, ref: ?usize, ent: ents.Scene.OptionalEntity, allocator: std.mem.Allocator) !znt.EntityId {
        var l: *Level = if (ref) | r | &self.levels[r] else self.current;
        return try l.addEntity(ent, allocator);
    }

    pub fn getOne(self: *Map, ref: EntityReference, comptime opt: ents.Scene.Component) ?*std.meta.fieldInfo(ents.Scene.Entity, opt).type {
        var l: *Level = if (ref.level) | r | &self.levels[r] else self.current;
        return l.scene.getOne(opt, ref.entity);
    }

    pub fn delEntity(self: *Map, ref: EntityReference) !void {
        var l: *Level = if (ref.level) | lv | &self.levels[lv] else self.current;
        try l.delEntity(ref.entity);
    }

    pub fn fromJSON(src: []const u8, allocator: std.mem.Allocator) !Map {
        var out_map: Map = .{
            .levels = undefined,
            .current = undefined,
            .entity_uuids = std.AutoHashMap(u32, EntityReference).init(allocator)
        };
        
        var levels = std.ArrayList(Level).init(allocator);
        var tokens = std.json.TokenStream.init(src);
        var raw = try std.json.parse([]Level.ProtoLevel, &tokens, .{ .allocator = allocator, .ignore_unknown_fields = true });

        for (raw) | raw_level, level_idx | {
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
                var id = try out_level.addEntity(ent, allocator);
                var uuid = out_level.scene.getOne(.uuid, id);
                if (uuid != null) 
                    try out_map.entity_uuids.put(uuid.?.*, .{
                        .entity = id,
                        .level = level_idx
                    });
            }

            try levels.append(out_level);
        }

        out_map.levels = try levels.toOwnedSlice();
        out_map.current = &out_map.levels[0];

        return out_map;
    }

    pub fn loop(self: *Map, delta: f64) !void {
        main.camera = self.camera;

        var cam: extra.Rectangle = .{
            .x = main.real_camera.x - (main.width  / main.real_camera.z / 2), 
            .y = main.real_camera.y - (main.height / main.real_camera.z / 2),
            .w = main.width  / main.real_camera.z, 
            .h = main.height / main.real_camera.z
        };

        var iter = self.current.eachChunk(cam);
        while (iter.next()) | chunk | {
            for (chunk.tiles.items) | tile | {
                main.render(tile);
            }

            if (comptime main.DEBUGMODE) {
                for (chunk.colls.items) | item | {
                    main.rect(item.collider, .{.g=0, .b=0, .a=0.3});
                }

                main.outlineRect(.{
                    .x = @intToFloat(f64, chunk.index.x*chunk_size), 
                    .y = @intToFloat(f64, chunk.index.y*chunk_size),
                    .w = @intToFloat(f64, chunk_size), 
                    .h = @intToFloat(f64, chunk_size)
                }, .{.a=0.3});
            }
        }

        try ents.process(self, delta);

        try dialog.loop(delta);

        back.color_a = map.current.color_a;
        back.color_b = map.current.color_b;

        self.transition_state = extra.clamp(f64, self.transition_state + (self.transition orelse 0)*delta*4, 0, 1);

        back.strength = 0.3 * @floatCast(f32, 1-self.transition_state);

        if (self.transition != null) {
            if (self.transition_state == 0) 
                self.transition = null;

            if (self.transition_state == 1) {
                if (self.delete_entity != null)
                    try self.current.delEntity(self.delete_entity.?);

                self.current = self.next_level.?;
                self.next_level = null;
                self.transition = -1;
            }
        }
                
        main.rect(cam, .{.r = 0, .g = 0, .b = 0, .a = @floatCast(f32, self.transition_state)});
    }
};

var map: Map = undefined;

fn init() !void {
    map = try Map.fromJSON(assets.@"map_test.json", main.allocator);
    try dialog.init(main.allocator);
}

fn loop(delta: f64) !void {
    try map.loop(delta);
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};