const DEBUGMODE = true;
const std   = @import("std");

const sg    = @import("sokol").gfx;
const sapp  = @import("sokol").app;
const sgapp = @import("sokol").app_gfx_glue;
const st    = @import("sokol").debugtext;

const shd   = @import("quad.glsl.zig");
const extra = @import("extra.zig");
const input = @import("input.zig");
const assets = @import("assets");
const c     = @import("c");

const font  = @import("font.zig");

var main_font: font.Font = undefined;

const chunk_size = 8 * 8;
const quad_amount = 2048;

pub const state = struct {
    var bind: sg.Bindings = .{};
    var pip: sg.Pipeline = .{};
    var pass_action: sg.PassAction = .{};
    var text_pass_action: sg.PassAction = .{};

    var width: f64 = 0;
    var height: f64 = 0;

    var vertices: [quad_amount * 36]f32 = undefined;
    var temp_camera: Position = .{};
    var camera: Position = .{};
    var current: usize = 0;
    var allocator: std.mem.Allocator = undefined;

    var atlas: Image = undefined;

    var map: Map = undefined;

    pub fn init() !void {
        const self = state;

        sg.setup(.{
            .context = sgapp.context()
        });

        var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
        self.allocator = gpa.allocator();

        try input.setup(self.allocator);

        var sdtx_desc: st.Desc = .{};
        sdtx_desc.fonts[0] = st.fontZ1013();
        st.setup(sdtx_desc);

        self.atlas = try Image.new(assets.atl_main);
        self.bind.fs_images[shd.SLOT_tex] = self.atlas.handle;

        main_font = try font.generate(self.allocator);

        self.bind.vertex_buffers[0] = sg.makeBuffer(.{
            .usage = .STREAM,
            .size = quad_amount * 36 * 4
        });

        var indices: [quad_amount*6]u32 = undefined;
        var i: usize = 0;
        while (i < quad_amount) {
            var e = @intCast(u32, i * 4);

            indices[(i*6)+0] = e;
            indices[(i*6)+1] = e+1;
            indices[(i*6)+2] = e+2;
            indices[(i*6)+3] = e;
            indices[(i*6)+4] = e+2;
            indices[(i*6)+5] = e+3;

            i += 1;
        }

        self.bind.index_buffer = sg.makeBuffer(.{
            .type = .INDEXBUFFER,
            .data = sg.asRange(&indices)
        });

        var pip_desc: sg.PipelineDesc = .{
            .index_type = .UINT32,
            .shader = sg.makeShader(shd.quadShaderDesc(sg.queryBackend())),
            .depth = .{
                .compare = .LESS_EQUAL,
                .write_enabled = true,
            },
        };

        pip_desc.colors[0].blend = .{
            .enabled = true,
            .src_factor_rgb = .SRC_ALPHA,
            .dst_factor_rgb = .ONE_MINUS_SRC_ALPHA,
            .src_factor_alpha = .SRC_ALPHA,
            .dst_factor_alpha = .ONE_MINUS_SRC_ALPHA,
        };
        
        pip_desc.layout.attrs[shd.ATTR_vs_vx_position].format = .FLOAT3;
        pip_desc.layout.attrs[shd.ATTR_vs_vx_color].format = .FLOAT4;
        pip_desc.layout.attrs[shd.ATTR_vs_vx_uv].format = .FLOAT2; 

        self.pip = sg.makePipeline(pip_desc);

        self.pass_action.colors[0] = .{ .action=.CLEAR, .value=.{ .r=0, .g=0, .b=0, .a=1 } };
        self.text_pass_action.colors[0].action = .DONTCARE;

        self.map = try Map.load(assets.map_test, self.allocator);
    }

    pub fn loop(delta: f64) !void {
        const self = state;

        input.update();
        timer += delta;

        self.width = @floatCast(f64, sapp.widthf());
        self.height = @floatCast(f64, sapp.heightf());
        self.temp_camera.z = @max(@floor(@min(self.width, self.height) / 200), 1);
        self.camera = self.camera.lerp(self.temp_camera, delta * 16);

        self.current = 0;

        var cam = Rectangle {
            .x = self.camera.x-(self.width  / self.camera.z / 2), 
            .y = self.camera.y-(self.height / self.camera.z / 2),
            .w = self.width  / self.camera.z, 
            .h = self.height / self.camera.z
        };

        rectLine(cam, .{.r=1, .g=1, .b=1, .a=0.2});

        var chunk_amount: usize = 0;

        var iter = map.eachChunk(cam);
        while (iter.next()) | chunk | {
            for (chunk.tiles.items) | tile | {
                sprite (
                    tile.position, tile.sprite, 
                    .{.r=1.0, .g=1.0, .b=1.0, .a=1.0},
                    .{.x=1, .y=1}
                );
            }

            for (chunk.colliders.items) | collider | {
                rect(collider.bounding, .{.r=1, .g=0, .b=0, .a=0.3});
            }

            chunk_amount += 1;
        }

        for (map.entities.items) | *entity | {
            try entity.process(&map, state.allocator, delta);
        }

        for (map.entities.items) | entity | {
            _ = entity.sprite orelse continue;

            centeredSprite(
                entity.position, entity.sprite.?.sprite,
                entity.sprite.?.tint, entity.sprite.?.scale
            );

//            if (comptime DEBUGMODE) {
//                var visibility: Rectangle = .{
//                    .x = entity.position.x-entity.sprite.?.offset.x,
//                    .y = entity.position.y-entity.sprite.?.offset.y,
//                    .w = entity.sprite.?.sprite.w,
//                    .h = entity.sprite.?.sprite.h
//                };
//
//                rect(visibility, .{.r=1, .g=1, .b=1, .a=0.8});
//
//                rect(.{
//                    .x = entity.position.x-2, 
//                    .y = entity.position.y-2, 
//                    .w = 4, .h = 4
//                }, .{.r=1, .g=1, .b=1, .a=1});
//            }
        }

        try print(.{.x=0, .y=0}, "another metahome.", null, .{.r=1, .g=1, .b=1, .a=1});

        //std.log.info("{}", .{current});

        sg.updateBuffer(self.bind.vertex_buffers[0], sg.asRange(&self.vertices));

        sg.beginDefaultPass(self.pass_action, sapp.width(), sapp.height());
        sg.applyPipeline(self.pip);
        sg.applyBindings(self.bind);
        sg.draw(0, @intCast(u32, self.current) * 6, 1);
        sg.endPass();

        if (comptime DEBUGMODE) {
            st.canvas(sapp.widthf()/2, sapp.heightf()/2);
            st.color1i(0xffffffff);
            st.origin(2, 2);
            st.font(0);
            st.print("Visible:\n\tQuads: {}/{}\n\tChnks: {}\n", .{self.current, quad_amount, chunk_amount});
            st.crlf();
            st.print("Camera: [{d:.1}, {d:.1}, {d:.1}]", .{self.camera.x, self.camera.y, self.camera.z});

            sg.beginDefaultPass(self.text_pass_action, sapp.width(), sapp.height());
            st.draw();
            sg.endPass();
        }

        sg.commit();
    }
};

pub const Color = sg.Color;

pub const Index = struct {
    x: i32 = 0, 
    y: i32 = 0
};

pub const Position = struct {
    x: f64 = 0.0,
    y: f64 = 0.0,
    z: f64 = 0.0,

    pub fn lerp(self: Position, into: Position, delta: f64) Position {
        var n = self;
        n.x = extra.lerp(f64, self.x, into.x, delta);
        n.y = extra.lerp(f64, self.y, into.y, delta);
        n.z = extra.lerp(f64, self.z, into.z, delta);

        return n;
    } 

    pub fn addPosition(self: Position, b: Position) Position {
        return .{ 
            .x = self.x + b.x, 
            .y = self.y + b.y
        };
    }

    pub fn subPosition(self: Position, b: Position) Position {
        return .{ 
            .x = self.x - b.x, 
            .y = self.y - b.y
        };
    }

    pub fn mul(self: Position, b: f64) Position {
        return .{ 
            .x = self.x * b, 
            .y = self.y * b
        };
    }

    pub fn toIndex(self: Position) Index {
        return .{ 
            .x = @floatToInt(i32, @divFloor(self.x, @intToFloat(f64, chunk_size))), 
            .y = @floatToInt(i32, @divFloor(self.y, @intToFloat(f64, chunk_size))) 
        };
    }
};

pub const Rectangle = struct {
    pub const clip = Rectangle {
        .x = -1, .y = -1,
        .w =  2, .h =  2
    }; // Clip space min and max. [Pos, Size] format

    x: f64 = 0.0,
    y: f64 = 0.0,
    w: f64 = 0.0,
    h: f64 = 0.0,

    pub fn colliding(self: Rectangle, other: Rectangle) bool {
        return self.x  < (other.x+other.w) and
               other.x < (self.x+self.w) and
               self.y  < (other.y+other.h) and
               other.y < (self.y+self.h);
    }

    pub fn visible(self: Rectangle) ?Rectangle {
        const w = state.width  / state.camera.z / 2;
        const h = state.height / state.camera.z / 2;

        var n: Rectangle = .{};
        n.x = (self.x - state.camera.x) / w;
        n.y = (self.y - state.camera.y) / h;
        n.w = self.w / w;
        n.h = self.h / h;

        return if (n.colliding(Rectangle.clip)) n else null;
    }

    pub fn expand(self: Rectangle, bx: f64, by: f64) Rectangle {
        return .{
            .x = self.x - (bx/2), .y = self.y - (by/2),
            .w = self.w + bx,     .h = self.h + by
        };
    }

    pub fn getMiddle(self: Rectangle) Position {
        return .{
            .x = self.x+(self.w/2),
            .y = self.y+(self.h/2)
        };
    }

    pub fn vsRay(self: Rectangle, start: Position, end: Position) ?Collision {
        var inv_dir: Position = .{
            .x = 1 / end.x, 
            .y = 1 / end.y
        };
        
        var near: Position = .{
            .x = (self.x - start.x) * inv_dir.x, 
            .y = (self.y - start.y) * inv_dir.y
        };

        var far: Position = .{
            .x = (self.x + self.w - start.x) * inv_dir.x, 
            .y = (self.y + self.h - start.y) * inv_dir.y
        };

        if (near.x > far.x) {
            var _x = near.x;
            near.x = far.x;
            far.x = _x;
        }

        if (near.y > far.y) {
            var _y = near.y;
            near.y = far.y;
            far.y = _y;
        }

        if (near.x > far.y or near.y > far.x)
            return null;

        var hit_near = @max(near.x, near.y);
        var hit_far  = @min(far.x,  far.y);

        if (hit_far < 0)
            return null;

        var collision: Collision = .{
            .at = .{
                .x = start.x + hit_near * end.x,
                .y = start.y + hit_near * end.y
            },
            .near = hit_near
        };

        if (near.x > near.y)
            collision.normal.x = if (inv_dir.x < 0) 1 else -1

        else if (near.x < near.y)
            collision.normal.y = if (inv_dir.y < 0) 1 else -1;
        
        return collision;
    }

    pub fn vsKinematic(self: Rectangle, b: Rectangle, velocity: Position, delta: f64) ?Collision {
        if (velocity.x == 0 and velocity.y == 0)
            return null;

        var collision = 
            self.expand(b.w, b.h).vsRay(b.getMiddle(), velocity.mul(delta))
            orelse return null;

        if (collision.near >= 0.0 and collision.near < 1.0)
            return collision;

        return null;
    }

    pub fn solveCollision(self: Rectangle, b: Rectangle, velocity: Position, delta: f64) ?Collision {
        var collision = b.vsKinematic(self, velocity, delta) orelse return null;

        var v: Position = velocity;
        v.x = velocity.x + (collision.normal.x * @fabs(velocity.x) * (1-collision.near));
        v.y = velocity.y + (collision.normal.y * @fabs(velocity.y) * (1-collision.near));

        collision.velocity = v;
        return collision;
    }
};

pub const Image = struct { 
    w: u32 = 0, 
    h: u32 = 0, 
    handle: sg.Image,

    pub fn new(raw: []const u8) !Image {
        var a: Image = undefined;

        var w: c_int = 0;
        var h: c_int = 0;

        if (c.stbi_info_from_memory(raw.ptr, @intCast(c_int, raw.len), &w, &h, null) == 0)
            return error.NotPngFile;

        a.w = @intCast(u32, w);
        a.h = @intCast(u32, h);

        if (a.w <= 0 or a.h <= 0) 
            return error.NoPixels;

        if (c.stbi_is_16_bit_from_memory(raw.ptr, @intCast(c_int, raw.len)) != 0)
            return error.InvalidFormat;

        const bits_per_channel = 8;
        const channel_count = 4;

        const image_data = c.stbi_load_from_memory(raw.ptr, @intCast(c_int, raw.len), &w, &h, null, channel_count);

        if (image_data == null) 
            return error.NoMem;

        var img = sg.ImageDesc {
            .width  = @intCast(i32, a.w), 
            .height = @intCast(i32, a.h),
        };

        var pitch = a.w * bits_per_channel * channel_count / 8;

        img.data.subimage[0][0] = sg.asRange(image_data[0 .. a.h * pitch]);
        a.handle = sg.makeImage(img);

        std.c.free(image_data);

        return a;
    }
};

pub const Tile = struct {
    position: Position = .{},
    sprite: Rectangle = .{},
    scale: Position = .{.x=1, .y=1},
    tint: Color = .{.r=1, .g=1, .b=1, .a=1},
    offset: Position = .{}
};

pub const EntityType = enum {
    none, player
};

pub const Entity = struct {
    pub const Collider = struct {
        bounding: Rectangle = .{},
        uid: u32 = 0
    };

    uid: u32 = 0,
    velocity: ?Position = null, // No velocity == Static
    sprite: ?Tile = null,
    size: Position = .{},
    position: Position = .{},
    collider: ?Rectangle = null,
    offset: Position = .{},

    fields: union(EntityType) {
        none: struct {
            __none: bool
        },
        player: struct {
            isPlayer: bool = true,
            flip: f64 = 1
        }
    },

    pub fn init(self: *Entity) void {
        if (self.fields == .player) {
            std.log.info("surpsass", .{});
            self.collider = Rectangle {
                .x = -4, .y = -3,
                .w = 8, .h = 3
            };
        }
    }

    pub fn process(self: *Entity, map: *Map, allocator: std.mem.Allocator, delta: f64) !void {  
        switch (self.fields) {
            .none => {},
            .player => | *f | {
                state.temp_camera.x = self.position.x;
                state.temp_camera.y = self.position.y;

                var vel: Position = .{};

                var v: f64 = 36;

                if (input.down(.up) > 0) 
                    vel.y -= v;
                
                if (input.down(.down) > 0) 
                    vel.y += v;

                if (input.down(.left) > 0) {
                    vel.x -= v;
                    f.flip = -1;
                }

                if (input.down(.right) > 0) {
                    vel.x += v;
                    f.flip = 1;
                }

                self.sprite.?.scale.x = extra.lerp(f64, self.sprite.?.scale.x, f.flip, delta*30);
                self.velocity = vel;
            }
        }

        if (self.velocity != null) {
            var vel: Position = self.velocity.?;

            if (self.collider == null) {
                vel.x *= delta;
                vel.y *= delta;
        
            } else {
                var col: Rectangle = .{ 
                    .x = self.position.x+self.collider.?.x,
                    .y = self.position.y+self.collider.?.y,
                    .w = self.collider.?.w,
                    .h = self.collider.?.h
                };

                var iter = map.eachChunk(col.expand(chunk_size, chunk_size));
                while (try iter.nextOrCreate(allocator)) | chunk | {
                    for (chunk.colliders.toOwnedSlice()) | collider | {
                        if (collider.uid == self.uid)
                            continue;

                        try chunk.colliders.append(collider);

                        var collision = col.solveCollision(collider.bounding, vel, delta);
                        if (collision != null) {
                            vel = collision.?.velocity;
                        }
                    }
                }
            }

            self.position.x += vel.x;
            self.position.y += vel.y;

            if (self.collider != null) {
                var col: Rectangle = .{ 
                    .x = self.position.x+self.collider.?.x,
                    .y = self.position.y+self.collider.?.y,
                    .w = self.collider.?.w,
                    .h = self.collider.?.h
                };

                var iter = map.eachChunk(col);

                while (try iter.nextOrCreate(allocator)) | chunk | {
                    try chunk.colliders.append(.{
                        .bounding = col,
                        .uid = self.uid
                    });
                }
            }
        }
    }
};

pub const Collision = struct {
    normal: Position = .{},
    at: Position = .{},
    near: f64 = 0,
    velocity: Position = .{}
};

pub const Chunk = struct {
    index: Index = .{},
    tiles: std.ArrayList(Tile),
    colliders: std.ArrayList(Entity.Collider)
};

pub const Map = struct {
    pub const Proto = struct {
        width: u32,
        height: u32,
        uid: u32,
        tiles: [][6]f64,
        entities: []Entity
    };

    chunks: std.AutoHashMap(Index, Chunk),
    entities: std.ArrayList(Entity),

    var uid: u32 = 0;

    pub fn getChunk(self: *Map, index: Index) callconv(.Inline) ?*Chunk {
        return self.chunks.getPtr(index);
    }

    pub fn getChunkOrCreate(self: *Map, index: Index, allocator: std.mem.Allocator) !*Chunk {
        var a = self.chunks.getPtr(index);
        var b: Chunk = undefined;

        if (a == null) {
            b = Chunk {
                .index = index,
                .tiles = std.ArrayList(Tile).init(allocator),
                .colliders = std.ArrayList(Entity.Collider).init(allocator)
            };

            try self.chunks.put(index, b);
        }

        return self.getChunk(index).?;
    }

    pub fn addEntity(self: *Map, ent: Entity, allocator: std.mem.Allocator) !void {
        var entity = ent;
        entity.uid = uid;
        try self.entities.append(entity);
        uid = uid + 1;

        entity.init();

        if (entity.collider==null) return;

        var col: Rectangle = .{ 
            .x = entity.position.x+entity.collider.?.x,
            .y = entity.position.y+entity.collider.?.y,
            .w = entity.collider.?.w,
            .h = entity.collider.?.h
        };

        var iter = self.eachChunk(col);

        while (try iter.nextOrCreate(allocator)) | chunk | {
            try chunk.colliders.append(.{
                .bounding = col,
                .uid = entity.uid
            });
        }
    }

    const ChunkIterator = struct {
        parent: *Map = undefined,
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

    pub fn eachChunk(self: *Map, r: Rectangle) ChunkIterator{
        var start = (Position {.x=r.x, .y=r.y}).toIndex();
        return ChunkIterator {
            .start = start,
            .end = (Position {.x=r.x+r.w, .y=r.y+r.h}).toIndex(),
            .index = start,
            .parent = self
        };
    }

    //pub fn deleteEntityRefs() {}

    pub fn load(str: []const u8, allocator: std.mem.Allocator) !Map {
        var map = Map {
            .chunks = std.AutoHashMap(Index, Chunk).init(allocator),
            .entities = std.ArrayList(Entity).init(allocator)
        };

        var stream = std.json.TokenStream.init(str);
        const res = try std.json.parse(Proto, &stream, .{
            .allocator = allocator,
            .ignore_unknown_fields = true
        });
        
        for (res.tiles) | tile | {
            var position = Position {
                .x = tile[0], .y = tile[1]
            };
            
            var chunk = try map.getChunkOrCreate(position.toIndex(), allocator);

            try chunk.tiles.append(.{
                .position = position,
                .sprite = .{
                    .x = tile[2], .y = tile[3],
                    .w = tile[4], .h = tile[5]
                }
            });
        }

        for (res.entities) | entity | {
            try map.addEntity(entity, allocator);
        }

        return map;
    }
};

pub fn sprite(p: Position, s: Rectangle, color: Color, scale: Position) void {
    if ((36 * state.current) > state.vertices.len) {
        state.current = 0; // Loop around (yes, this SUCKS)
    }

    var n = Rectangle {
        .x = p.x, .y = p.y, 
        .w = s.w * scale.x, .h = s.h * scale.y
    };

    n = n.visible() orelse return;

    // [Pos, Size] to [Corner A, Corner B]
    n.w += n.x;
    n.h += n.y;

    var u: Rectangle = .{};
    u.x = s.x / @intToFloat(f64, state.atlas.w);
    u.y = s.y / @intToFloat(f64, state.atlas.h);
    u.w = s.w / @intToFloat(f64, state.atlas.w);
    u.h = s.h / @intToFloat(f64, state.atlas.h);

    // [Pos, Size] to [Corner A, Corner B]
    u.w += u.x;
    u.h += u.y;
    
    const tmp_vertices = [_]f32 { // i hate this coordinate system :P
        @floatCast(f32, n.x), -@floatCast(f32, n.h), 1.0,   color.r, color.g, color.b, color.a,   @floatCast(f32, u.x), @floatCast(f32, u.h),
        @floatCast(f32, n.w), -@floatCast(f32, n.h), 1.0,   color.r, color.g, color.b, color.a,   @floatCast(f32, u.w), @floatCast(f32, u.h),
        @floatCast(f32, n.w), -@floatCast(f32, n.y), 1.0,   color.r, color.g, color.b, color.a,   @floatCast(f32, u.w), @floatCast(f32, u.y),
        @floatCast(f32, n.x), -@floatCast(f32, n.y), 1.0,   color.r, color.g, color.b, color.a,   @floatCast(f32, u.x), @floatCast(f32, u.y)
    };

    var o = state.current * 36;
    for (tmp_vertices) | v, i | {
        state.vertices[o + i] = v;
    }

    state.current += 1;
}

pub fn centeredSprite(p: Position, s: Rectangle, color: Color, scale: Position) void {
    var np: Position = p;
    np.x -= s.w * scale.x * 0.5;
    np.y -= s.h * scale.y;
    sprite(np, s, color, scale);
}

pub fn rect(r: Rectangle, color: Color) void {
    sprite(
        .{.x=r.x, .y=r.y}, 
        .{.x=0, .y=0, .w=1, .h=1}, 
        color, .{.x=r.w, .y=r.h}
    );
}

pub fn rectLine(r: Rectangle, color: Color) void {
    sprite(
        .{.x=r.x, .y=r.y}, 
        .{.x=0, .y=0, .w=1, .h=1}, 
        color, .{.x=r.w, .y=1}
    );

    sprite(
        .{.x=r.x, .y=r.y+r.h}, 
        .{.x=0, .y=0, .w=1, .h=1}, 
        color, .{.x=r.w, .y=1}
    );

    sprite(
        .{.x=r.x, .y=r.y+1}, 
        .{.x=0, .y=0, .w=1, .h=1}, 
        color, .{.x=1, .y=r.h-1}
    );

    sprite(
        .{.x=r.x+r.w, .y=r.y+1}, 
        .{.x=0, .y=0, .w=1, .h=1}, 
        color, .{.x=1, .y=r.h-1}
    );
}

pub fn print(p: Position, t: []const u8, end: ?usize, color: Color) !void {
    if (end != null and end.? == 0)
        return;

    var cp: Position = p;
    var i: usize = 0;

    var iter = (try std.unicode.Utf8View.init(t)).iterator();
    while (iter.nextCodepoint()) |code| {
        switch (code) {
            '\n' => {
                cp.x = p.x;
                cp.y += 8;
            },

            else => {
                var e: font.Character = main_font.characters.get(code) orelse .{};
                var tp = cp;
                tp.y -= e.origin.y;
                sprite(tp, e.sprite, color, .{.x=1, .y=1});
                cp.x += e.sprite.w - e.origin.x;
            }
        }

        i += 1;

        if (end != null and i == end.?)
            return;
    }
}

var timer: f64 = 0;
var s1: f64 = 1;
var s2: f64 = 1;

export fn init() void {
    state.init() catch unreachable;
}

export fn frame() void {
    state.loop(sapp.frameDuration()) catch unreachable;
}

export fn cleanup() void {
    sg.shutdown();
}

export fn event(ev: [*c]const sapp.Event) void {
    input.handle(ev) catch unreachable;
}

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .event_cb = event,
        .width = 800,
        .height = 600,
        .icon = .{
            .sokol_default = true,
        },
        .window_title = "quad.zig"
    });
}