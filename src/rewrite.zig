const std   = @import("std");
const DEBUGMODE = @import("builtin").mode == .Debug;

const sg    = @import("sokol").gfx;
const sapp  = @import("sokol").app;
const sgapp = @import("sokol").app_gfx_glue;
const st    = @import("sokol").debugtext;

const shd   = @import("quad.glsl.zig");
const extra = @import("extra.zig");
const input = @import("input.zig");
const assets = @import("assets.zig");

const font  = @import("font.zig");

pub const Sprite = struct { 
    origin: extra.Rectangle = .{},
    position: extra.Vector = .{},
    offset: extra.Vector = .{},
    color: extra.Color = .{},
    scale: extra.Vector = .{.x=1, .y=1}
};

pub const State = struct {
    init: *const (fn () anyerror!void)    = undefined,
    loop: *const (fn (f64) anyerror!void) = undefined
};

var current_state: State = undefined;

pub const States = enum {
    dialog
};

pub fn setState(state: States) !void {
    switch (state) {
        .dialog => current_state = @import("dialog.zig").state
    }
    
    try current_state.init();
}

const quad_amount = 2048;

pub var width: f64 = 0;
pub var height: f64 = 0;

var main_font: font.Font = undefined;

pub var timer: f64 = 0;
var current_vertex: usize = 0;
var vertices: [quad_amount * 36]f32 = undefined;

var real_camera: extra.Vector = .{};
pub var camera: extra.Vector = .{};

pub var allocator: std.mem.Allocator = undefined;
var atlas: assets.Image = undefined;

var bind: sg.Bindings = .{};
var pip: sg.Pipeline = .{};
var pass_action: sg.PassAction = .{};
var text_pass_action: sg.PassAction = .{};

pub fn render(spr: Sprite) void {
    // Horrid, I know. 
    current_vertex %= quad_amount;

    var sprite = spr;

    var n = extra.Rectangle {
        .x = sprite.position.x+sprite.offset.x, 
        .y = sprite.position.y+sprite.offset.y, 
        .w = sprite.origin.w*sprite.scale.x, 
        .h = sprite.origin.h*sprite.scale.y
    };

    n = n.visible(width, height, real_camera) orelse return;

    // [Pos, Size] to [Corner A, Corner B]
    n.w += n.x;
    n.h += n.y;

    var u: extra.Rectangle = .{
        .x = sprite.origin.x / @intToFloat(f64, atlas.w),
        .y = sprite.origin.y / @intToFloat(f64, atlas.h),
        .w = sprite.origin.w / @intToFloat(f64, atlas.w),
        .h = sprite.origin.h / @intToFloat(f64, atlas.h)
    };
    
    // [Pos, Size] to [Corner A, Corner B]
    u.w += u.x;
    u.h += u.y;
    
    const tmp_vertices = [_]f32 { // i hate this coordinate system :P
        @floatCast(f32, n.x), -@floatCast(f32, n.h), 1.0,   sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a,   @floatCast(f32, u.x), @floatCast(f32, u.h),
        @floatCast(f32, n.w), -@floatCast(f32, n.h), 1.0,   sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a,   @floatCast(f32, u.w), @floatCast(f32, u.h),
        @floatCast(f32, n.w), -@floatCast(f32, n.y), 1.0,   sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a,   @floatCast(f32, u.w), @floatCast(f32, u.y),
        @floatCast(f32, n.x), -@floatCast(f32, n.y), 1.0,   sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a,   @floatCast(f32, u.x), @floatCast(f32, u.y)
    };

    std.mem.copy(f32, vertices[(current_vertex * 36)..], &tmp_vertices);

    current_vertex += 1;
}

pub fn rect(r: extra.Rectangle, color: extra.Color) void {
    render(
        .{
            .origin = .{.x=0, .y=0, .w=1, .h=1}, 
            .position = .{.x=r.x, .y=r.y}, 
            .color = color, 
            .scale = .{.x=r.w, .y=r.h}
        }
    );
}

pub fn print(p: extra.Vector, t: []const u8, end: ?usize, color: extra.Color) !void {
    if (end != null and end.? == 0)
        return;

    var cp: extra.Vector = p;
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
                render(
                    .{
                        .origin = e.sprite, 
                        .position = tp,
                        .color = color
                    }
                );
                cp.x += e.sprite.w - e.origin.x;
            }
        }

        i += 1;

        if (end != null and i == end.?)
            return;
    }
}

export fn init() void {
    sg.setup(.{
        .context = sgapp.context()
    });

    var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
    allocator = gpa.allocator();

    input.setup(allocator) catch undefined;

    var sdtx_desc: st.Desc = .{};
    sdtx_desc.fonts[0] = st.fontZ1013();
    st.setup(sdtx_desc);

    atlas = assets.Image.fromFile("atl_main.png") catch undefined;
    bind.fs_images[shd.SLOT_tex] = atlas.handle;

    main_font = font.generate(allocator) catch undefined;

    bind.vertex_buffers[0] = sg.makeBuffer(.{
        .usage = .STREAM,
        .size = quad_amount * 36 * 4
    });

    var indices: [quad_amount*6]u32 = undefined;
    comptime {
        @setEvalBranchQuota(quad_amount+1);
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
    }

    bind.index_buffer = sg.makeBuffer(.{
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

    pip = sg.makePipeline(pip_desc);

    pass_action.colors[0] = .{ .action=.CLEAR, .value=.{ .r=0, .g=0, .b=0, .a=1 } };
    text_pass_action.colors[0].action = .DONTCARE;

    // TODO: MOVE
    //self.map = try Map.load(assets.map_test, self.allocator);

    //state.init() catch unreachable;

    setState(.dialog) catch unreachable;
}

export fn frame() void {
    input.update();

    var delta = sapp.frameDuration();

    timer += delta;

    width = @floatCast(f64, sapp.widthf());
    height = @floatCast(f64, sapp.heightf());
    camera.z = @max(@floor(@min(width, height) / 200), 1);
    real_camera = real_camera.lerp(camera, delta * 16);

    current_vertex = 0;

    current_state.loop(sapp.frameDuration()) catch unreachable;

    sg.updateBuffer(bind.vertex_buffers[0], sg.asRange(&vertices));

    sg.beginDefaultPass(pass_action, sapp.width(), sapp.height());
    sg.applyPipeline(pip);
    sg.applyBindings(bind);
    sg.draw(0, @intCast(u32, current_vertex) * 6, 1);
    sg.endPass();

    if (comptime DEBUGMODE) {
        st.canvas(sapp.widthf()/2, sapp.heightf()/2);
        st.color1i(0xffffffff);
        st.origin(2, 2);
        st.font(0);
        st.print("Quads: {}/{}", .{current_vertex, quad_amount});
        st.crlf();
        st.print("Camera: [{d:.1}, {d:.1}, {d:.1}]", .{real_camera.x, real_camera.y, real_camera.z});

        sg.beginDefaultPass(text_pass_action, sapp.width(), sapp.height());
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