const DEBUGMODE = @import("builtin").mode == @import("builtin").Mode.Debug;

const std = @import("std");

const sg = @import("sokol").gfx;
const sapp = @import("sokol").app;
const stime = @import("sokol").time;
const sgapp = @import("sokol").app_gfx_glue;
const sdtx = @import("sokol").debugtext;
const sa = @import("sokol").audio;

const PNG = @import("fileformats").Png;
const map = @import("level.zig");
const fs = @import("fs");

const math = @import("math.zig");

const shd = @import("shaders/main.zig");
const errhandler = @import("errorhandler.zig");

const TILE_WIDTH = 8;
const TILE_HEIGHT = 8;

const ACTOR_WIDTH = 16;
const ACTOR_HEIGHT = 16;

var camera: map.Vec3 = .{ .z = 3 };
pub fn getCamera() *map.Vec3 {
    return &camera;
}

////////////////////////////////////////////////////////////////////////////////////////////////

pub fn times(n: isize) callconv(.Inline) []const void { // Thanks shake
    return @as([*]void, undefined)[0..@intCast(usize, n)];
}

pub const Texture = struct {
    sktexture: sg.Image,
    width: u32,
    height: u32,

    pub fn fromRaw(data: anytype, width: u32, height: u32) Texture {
        var img_desc: sg.ImageDesc = .{ .width = @intCast(i32, width), .height = @intCast(i32, height) };
        img_desc.data.subimage[0][0] = sg.asRange(data);

        return Texture{
            .sktexture = sg.makeImage(img_desc),
            .width = width,
            .height = height,
        };
    }

    pub fn fromPNGPath(filename: [:0]const u8) !Texture {
        var pngdata = try PNG.fromFile(filename);

        var img_desc: sg.ImageDesc = .{
            .width = @intCast(i32, pngdata.width),
            .height = @intCast(i32, pngdata.height),
        };
        img_desc.data.subimage[0][0] = sg.asRange(pngdata.raw);

        return Texture{
            .sktexture = sg.makeImage(img_desc),
            .width = pngdata.width,
            .height = pngdata.height,
        };
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////

const Vertex = packed struct {
    x: f32 = 0, y: f32 = 0, z: f32 = 0, color: u32 = 0xFFFFFFFF, u: i16, v: i16
};

var pass_action: sg.PassAction = .{};
var pip: sg.Pipeline = .{};
var bind: sg.Bindings = .{};

var GPA = std.heap.GeneralPurposeAllocator(.{}){};
var tilelist = std.ArrayList(Tile).init(&GPA.allocator);

var WorldStream: std.json.TokenStream = undefined;
var cworld: map.World = undefined;
var clevel: map.Level = undefined;

var tileset: Texture = undefined;
var actorset: Texture = undefined;

const mapdata = @embedFile("../maps/test.metahome.map");

export fn audio(buffer: [*c]f32, frames: i32, channels: i32) void {}

export fn init() void {
    sa.setup(.{ .stream_cb = audio });
    fs.init();

    sg.setup(.{ .context = sgapp.context() });
    pass_action.colors[0] = .{
        .action = .CLEAR,
        .value = .{ .r = 0.08, .g = 0.08, .b = 0.11, .a = 1.0 }, // HELLO EIGENGRAU!
    };

    tileset = Texture.fromPNGPath("sprites/test.png") catch {
        @panic("Unable to load Tileset.");
    };

    actorset = Texture.fromPNGPath("sprites/actor.png") catch {
        @panic("Unable to load actor Tileset.");
    };

    const QuadVertices = [4]Vertex{
        .{ .x = 2, .y = 0, .u = 6553, .v = 6553 }, .{ .x = 2, .y = 2, .u = 6553, .v = 0 },
        .{ .x = 0, .y = 2, .u = 0, .v = 0 },       .{ .x = 0, .y = 0, .u = 0, .v = 6553 },
    };
    const QuadIndices = [6]u16{ 0, 1, 3, 1, 2, 3 };

    bind.vertex_buffers[0] = sg.makeBuffer(.{ .data = sg.asRange(QuadVertices) });
    bind.index_buffer = sg.makeBuffer(.{
        .type = .INDEXBUFFER,
        .data = sg.asRange(QuadIndices),
    });

    var pip_desc: sg.PipelineDesc = .{
        .shader = sg.makeShader(shd.mainShaderDesc(sg.queryBackend())),
        .index_type = .UINT16,
        .cull_mode = .FRONT,
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

    pip_desc.layout.attrs[shd.ATTR_vs_pos].format = .FLOAT3;
    pip_desc.layout.attrs[shd.ATTR_vs_color0].format = .UBYTE4N;
    pip_desc.layout.attrs[shd.ATTR_vs_texcoord0].format = .SHORT2N;
    pip = sg.makePipeline(pip_desc);
    stime.setup();

    cworld = map.loadMap(mapdata) catch @panic("Error loading world :(");
    clevel = cworld.levels[0];

    if (comptime DEBUGMODE) {
        var sdtx_desc: sdtx.Desc = .{};
        sdtx_desc.fonts[0] = @import("fontdata.zig").fontdesc;
        sdtx.setup(sdtx_desc);
        sdtx.font(0);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////

var screenWidth: f32 = 0;
var screenHeight: f32 = 0;

var delta: f32 = 0;
var last_time: u64 = 0;

pub fn i2f(int: anytype) callconv(.Inline) f32 { // I added this function for pure convenience
    return @intToFloat(f32, int); // It shouldnt affect runtime performance
}

export fn frame() void {
    screenWidth = sapp.widthf();
    screenHeight = sapp.heightf();

    if (comptime DEBUGMODE) {
        sdtx.canvas(screenWidth * 0.5, screenHeight * 0.5);
        sdtx.origin(1, 1);

        sdtx.color1i(0xFFAA67C7);
        sdtx.print("m e t a h o m e : ---------------------------------\n\n", .{});

        sdtx.color1i(0xFFFFAE00);
        sdtx.print("hello again! =)\nwelcome to my little side-project!\n\n", .{});

        sdtx.print("use the ARROW KEYS to move spriteboy\n", .{});
        sdtx.print("use Z to display collision boxes\n", .{});
    }

    sg.beginDefaultPass(pass_action, sapp.width(), sapp.height());

    // RENDER TILES ////////////////////////////////////////////////////////////////////////////

    bind.fs_images[shd.SLOT_tex] = tileset.sktexture;
    sg.applyPipeline(pip);
    sg.applyBindings(bind);

    var TILE_ROWS = i2f(tileset.width) / TILE_WIDTH;
    var TILE_COLUMNS = i2f(tileset.height) / TILE_HEIGHT;

    for (clevel.tiles) |tile| {
        const scale = math.Mat4.scale((TILE_WIDTH * camera.z) / screenWidth, (TILE_HEIGHT * camera.z) / screenHeight, 1);
        const trans = math.Mat4.translate(.{
            .x = ((i2f(tile.x) * 2 * camera.z) - (camera.x * 2 * camera.z)) / screenWidth,
            .y = ((i2f(tile.y) * 2 * camera.z) - (camera.y * 2 * camera.z)) / -screenHeight,
            .z = 0,
        });

        sg.applyUniforms(.FS, shd.SLOT_fs_params, sg.asRange(shd.FsParams{
            .globalcolor = .{ 0.4, 0.5, 0.6, 1 },
            .cropping = .{
                TILE_WIDTH / i2f(tileset.width),
                TILE_HEIGHT / i2f(tileset.height),
                i2f(tile.spr.x) / i2f(tileset.width),
                i2f(tile.spr.y) / i2f(tileset.height),
            },
        }));

        if (keys.attack and tile.collide) {
            sg.applyUniforms(.FS, shd.SLOT_fs_params, sg.asRange(shd.FsParams{
                .globalcolor = .{ 0.6, 0.5, 0.8, 1 },
                .cropping = .{
                    TILE_WIDTH / i2f(tileset.width),
                    TILE_HEIGHT / i2f(tileset.height),
                    0.0,
                    0.0,
                },
            }));
        }

        sg.applyUniforms(.VS, shd.SLOT_vs_params, sg.asRange(shd.VsParams{ .mvp = math.Mat4.mul(trans, scale) }));

        sg.draw(0, 6, 1);
    }

    bind.fs_images[shd.SLOT_tex] = actorset.sktexture;
    sg.applyPipeline(pip);
    sg.applyBindings(bind);

    for (clevel.actors) |*actor| {
        if (actor.process) {
            switch (actor.kind) {
                .Player => actor.processPlayer(delta),

                else => {},
            }

            actor.pos.x += actor.vel.x * delta;
            actor.pos.y += actor.vel.y * delta;
        }

        if (actor.visible) {
            var flip_x: f32 = if (actor.flip_x) -1 else 1;

            const scale = math.Mat4.scale((ACTOR_WIDTH * camera.z) / screenWidth, (ACTOR_HEIGHT * camera.z) / screenHeight, 5);
            const trans = math.Mat4.translate(.{
                .x = ((actor.pos.x * 2 * camera.z) - (camera.x * 2 * camera.z)) / screenWidth,
                .y = ((actor.pos.y * 2 * camera.z) - (camera.y * 2 * camera.z)) / -screenHeight,
                .z = 0,
            });

            sg.applyUniforms(.FS, shd.SLOT_fs_params, sg.asRange(shd.FsParams{
                .globalcolor = .{ 1, 1, 1, 1 },
                .cropping = .{
                    i2f(ACTOR_WIDTH) / i2f(actorset.width),
                    i2f(ACTOR_HEIGHT) / i2f(actorset.height),
                    (i2f(actor.spr.x) * i2f(ACTOR_WIDTH)) / i2f(actorset.width),
                    (i2f(actor.spr.y) * i2f(ACTOR_HEIGHT)) / i2f(actorset.height),
                },
            }));

            sg.applyUniforms(.VS, shd.SLOT_vs_params, sg.asRange(shd.VsParams{ .mvp = math.Mat4.mul(trans, scale) }));

            sg.draw(0, 6, 1);
        }
    }

    if (comptime DEBUGMODE) {
        sdtx.draw();
    }
    sg.endPass();
    sg.commit();

    delta = @floatCast(f32, stime.sec(stime.laptime(&last_time)));
}

////////////////////////////////////////////////////////////////////////////////////////////////

const _keystruct = struct {
    up: bool = false,
    down: bool = false,
    left: bool = false,
    right: bool = false,

    attack: bool = false,
    any: bool = false,

    home: bool = false,
};
var keys = _keystruct{};

const _mousestruct = struct {
    x: f32 = 0,
    y: f32 = 0,
    dx: f32 = 0,
    dy: f32 = 0,
    left: bool = false,
    middle: bool = false,
    right: bool = false,
    any: bool = false,
};
var mouse = _mousestruct{};

export fn input(ev: ?*const sapp.Event) void {
    const event = ev.?;
    if ((event.type == .KEY_DOWN) or (event.type == .KEY_UP)) {
        const key_pressed = event.type == .KEY_DOWN;
        keys.any = key_pressed;
        switch (event.key_code) {
            .UP => keys.up = key_pressed,
            .DOWN => keys.down = key_pressed,
            .LEFT => keys.left = key_pressed,
            .RIGHT => keys.right = key_pressed,

            .Z => keys.attack = key_pressed,

            .BACKSPACE => keys.home = key_pressed,
            else => {},
        }
    } else if ((event.type == .MOUSE_DOWN) or (event.type == .MOUSE_UP)) {
        const mouse_pressed = event.type == .MOUSE_DOWN;
        mouse.any = mouse_pressed;
        switch (event.mouse_button) {
            .LEFT => mouse.left = mouse_pressed,
            .MIDDLE => mouse.middle = mouse_pressed,
            .RIGHT => mouse.right = mouse_pressed,
            else => {},
        }
    } else if (event.type == .MOUSE_MOVE) {
        mouse.x = event.mouse_x;
        mouse.y = event.mouse_y;

        mouse.dx = event.mouse_dx;
        mouse.dy = event.mouse_dy;
    }
}

pub fn getKeys() *_keystruct {
    return &keys;
}

////////////////////////////////////////////////////////////////////////////////////////////////

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .event_cb = input,
        .fail_cb = fail,
        .width = 1024,
        .height = 600,
        .window_title = "m e t a h o m e",
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////

export fn cleanup() void {
    sg.shutdown();
    sa.shutdown();
    _ = fs.deinit();
    var leaked = GPA.deinit();
}

export fn fail(err: [*c]const u8) callconv(.C) void {
    errhandler.handle(err);
}
