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

const state = struct {
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
    sprite: Rectangle = .{}
};

pub const Entity = struct {

};

pub const Chunk = struct {
    index: Index = .{},
    tiles: std.ArrayList(Tile)
};

pub const Map = struct {
    pub const Proto = struct {
        width: u32,
        height: u32,
        uid: u32,
        tiles: [][6]f64
    };

    chunks: std.AutoHashMap(Index, Chunk),

    pub fn getChunk(self: *Map, index: Index) callconv(.Inline) ?*Chunk {
        return self.chunks.getPtr(index);
    }

    pub fn getChunkOrCreate(self: *Map, index: Index, allocator: std.mem.Allocator) !*Chunk {
        var a = self.chunks.getPtr(index);
        var b: Chunk = undefined;

        if (a == null) {
            b = Chunk {
                .index = index,
                .tiles = std.ArrayList(Tile).init(allocator)
            };

            try self.chunks.put(index, b);
        }

        return self.getChunk(index).?;
    }

    pub fn load(str: []const u8, allocator: std.mem.Allocator) !Map {
        var map = Map {
            .chunks = std.AutoHashMap(Index, Chunk).init(allocator)
        };

        var stream = std.json.TokenStream.init(str);
        const res = try std.json.parse(Proto, &stream, .{
            .allocator = allocator
        });
        
        for (res.tiles) | tile | {
            var position = Position {
                .x = tile[0], 
                .y = tile[1]
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

        return map;
    }
};

export fn init() void {
    sg.setup(.{
        .context = sgapp.context()
    });

    var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
    state.allocator = gpa.allocator();

    // TODO: PROPERLY HANDLE ERRORS
    input.setup(state.allocator) catch unreachable;

    var sdtx_desc: st.Desc = .{};
    sdtx_desc.fonts[0] = st.fontZ1013();
    st.setup(sdtx_desc);

    state.atlas = Image.new(assets.atl_main) catch unreachable;
    state.bind.fs_images[shd.SLOT_tex] = state.atlas.handle;

    main_font = font.generate(state.allocator) catch unreachable;

    state.bind.vertex_buffers[0] = sg.makeBuffer(.{
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

    state.bind.index_buffer = sg.makeBuffer(.{
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

    state.pip = sg.makePipeline(pip_desc);

    state.pass_action.colors[0] = .{ .action=.CLEAR, .value=.{ .r=0, .g=0, .b=0, .a=1 } };
    state.text_pass_action.colors[0].action = .DONTCARE;

    state.map = Map.load(assets.map_test, state.allocator) catch unreachable;
}

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

export fn frame() void {
    input.update();

    const delta = sapp.frameDuration();
    timer += delta;

    state.width = @floatCast(f64, sapp.widthf());
    state.height = @floatCast(f64, sapp.heightf());
    state.temp_camera.z = @max(@floor(@min(state.width, state.height) / 150), 1);
    state.camera = state.camera.lerp(state.temp_camera, delta * 16);

    var v: f64 = 64;

    if (input.down(.up) > 0) 
        state.temp_camera.y -= delta * v;
    
    if (input.down(.down) > 0) 
        state.temp_camera.y += delta * v;

    if (input.down(.left) > 0) {
        state.temp_camera.x -= delta * v;
        s2 = -1;
    }
     
    if (input.down(.right) > 0) {
        state.temp_camera.x += delta * v;
        s2 = 1;
    }

    s1 = extra.lerp(f64, s1, s2, delta * 16);

    state.current = 0;

    var cam_start = (Position {
        .x = state.camera.x-(state.width  / state.camera.z / 2), 
        .y = state.camera.y-(state.height / state.camera.z / 2)
    }).toIndex();

    var cam_end = (Position {
        .x = state.camera.x+(state.width  / state.camera.z / 2), 
        .y = state.camera.y+(state.height / state.camera.z / 2)
    }).toIndex();

    var current_index = cam_start;
    var chunk_amount: usize = 0;
    while (current_index.y <= cam_end.y) {
        var chunk = state.map.getChunk(current_index);
        if (chunk != null) {
            for (chunk.?.tiles.items) | tile | {
                sprite (
                    tile.position, tile.sprite, 
                    .{.r=1.0, .g=1.0, .b=1.0, .a=1.0},
                    .{.x=1, .y=1}
                );
            }

            chunk_amount += 1;
        }
        current_index.x += 1;
        if (current_index.x > cam_end.x) {
            current_index.x = cam_start.x;
            current_index.y += 1;
        }
    }

    centeredSprite(
        state.camera, .{.x=56, .y=32, .w=16, .h=16},
        .{.r=1.0, .g=0.5, .b=1.0, .a=1.0},
        .{.x=s1, .y=1}
    );

    rect(.{
        .x = state.camera.x-2, 
        .y = state.camera.y-2, 
        .w = 4, .h = 4
    }, .{.r=1, .g=1, .b=1, .a=1});

    print(.{.x=0, .y=0}, "another metahome?", null, .{.r=1, .g=1, .b=1, .a=1}) catch unreachable;

    //std.log.info("{}", .{current});

    sg.updateBuffer(state.bind.vertex_buffers[0], sg.asRange(&state.vertices));

    sg.beginDefaultPass(state.pass_action, sapp.width(), sapp.height());
    sg.applyPipeline(state.pip);
    sg.applyBindings(state.bind);
    sg.draw(0, @intCast(u32, state.current) * 6, 1);
    sg.endPass();

    if (comptime DEBUGMODE) {
        st.canvas(sapp.widthf()/2, sapp.heightf()/2);
        st.color1i(0xffffffff);
        st.origin(2, 2);
        st.font(0);
        st.print("Visible:\n\tQuads: {}/{}\n\tChnks: {}\n", .{state.current, quad_amount, chunk_amount});
        st.crlf();
        st.print("Camera: [{d:.1}, {d:.1}, {d:.1}]", .{state.camera.x, state.camera.y, state.camera.z});

        sg.beginDefaultPass(state.text_pass_action, sapp.width(), sapp.height());
        st.draw();
        sg.endPass();
    }

    sg.commit();
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