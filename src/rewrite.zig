const std   = @import("std");
pub const DEBUGMODE = @import("builtin").mode == .Debug;

const sg    = @import("sokol").gfx;
const sapp  = @import("sokol").app;
const sgapp = @import("sokol").app_gfx_glue;
const st    = @import("sokol").debugtext;

const shd   = @import("shaders/quad.glsl.zig");
const extra = @import("extra.zig");
const input = @import("input.zig");
const assets = @import("assets.zig");
const back  = @import("background.zig");

const font  = @import("font.zig");
const audio = @import("audio.zig");

pub const resolution = 250;

pub const Sprite = struct { 
    origin: extra.Rectangle = .{},
    position: extra.Vector = .{},
    color: extra.Color = .{},
    scale: extra.Vector = .{.x=1, .y=1},
    from_center: bool = false,
    rotation: f64 = 0
};

pub const State = struct {
    init: *const (fn () anyerror!void)    = undefined,
    loop: *const (fn (f64) anyerror!void) = undefined
};

var current_state: State = undefined;

pub const States = enum {
    main
};

pub fn setState(state: States) !void {
    switch (state) {
        .main => current_state = @import("world.zig").state
    }
    
    try current_state.init();
}

const quad_amount = 4096;

pub var width: f64 = 0;
pub var height: f64 = 0;

var main_font: font.Font = undefined;

pub var timer: f64 = 0;
var current_vertex: usize = 0;
var vertices: [quad_amount * 36]f32 = undefined;

pub var real_camera: extra.Vector = .{};
pub var camera: extra.Vector = .{};

pub var allocator: std.mem.Allocator = undefined;
var atlas: assets.Image = undefined;

var bind: sg.Bindings = .{};
var pip: sg.Pipeline = .{};
var pass_action: sg.PassAction = .{};
var text_pass_action: sg.PassAction = .{};

pub var color_a: extra.Color = .{};
pub var color_b: extra.Color = .{};
pub var filter: f32 = 0.3;

fn noise(mag: f64, offset: f64) f64 {
    if (mag == 0)
        return 0;
    return @floatCast(f32, mag * (0.5 - assets.noise(.{.x=offset+timer, .y=(offset*0.5)+timer})));
}

fn posNoise(x: f64, y: f64, wobble: f64) [2]f32 {
    return [2]f32 {
        @floatCast(f32, x + noise(wobble/(width/real_camera.z),  (x*32) + (timer*3))),
        @floatCast(f32, y + noise(wobble/(height/real_camera.z), (y*32) + (timer*3)))
    };
}

pub fn render(spr: Sprite) void {
    // Horrid, I know. 
    current_vertex %= quad_amount;

    var sprite = spr;

    var n = extra.Rectangle {
        .x = sprite.position.x, 
        .y = sprite.position.y+sprite.position.z, 
        .w = sprite.origin.w*sprite.scale.x, 
        .h = sprite.origin.h*sprite.scale.y
    };

    if (sprite.from_center) {
        n.x += sprite.origin.w*(1-sprite.scale.x)*0.5;
        n.y += sprite.origin.h*(1-sprite.scale.y)*0.5;
    }

    var w: f64 = 0;//sprite.wobble;
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
    
    // TODO: Fix wobbly sprite discrimination
    // Idea: Probably grow the square by wobble?
    var p1 = posNoise(n.x, -n.h, w);
    var p2 = posNoise(n.w, -n.h, w);
    var p3 = posNoise(n.w, -n.y, w);
    var p4 = posNoise(n.x, -n.y, w);

    const c = sprite.color;
 
    // TODO: Fix the wayland backend making the 
    // sprites look weird (Probably just floor() it)

    // Now that I think about it, why does that
    // even happen??? subpixel madness????
    const tmp_vertices = [_]f32 { // i hate this coordinate system :P
        p1[0], p1[1], 1.0,   c.r, c.g, c.b, c.a,   @floatCast(f32, u.x), @floatCast(f32, u.h),
        p2[0], p2[1], 1.0,   c.r, c.g, c.b, c.a,   @floatCast(f32, u.w), @floatCast(f32, u.h),
        p3[0], p3[1], 1.0,   c.r, c.g, c.b, c.a,   @floatCast(f32, u.w), @floatCast(f32, u.y),
        p4[0], p4[1], 1.0,   c.r, c.g, c.b, c.a,   @floatCast(f32, u.x), @floatCast(f32, u.y)
    };

    std.mem.copy(f32, vertices[(current_vertex * 36)..], &tmp_vertices);

    current_vertex += 1;
}

pub fn background(color: ?extra.Color) extra.Color {
    if (color != null)
        pass_action.colors[0] = .{ .action=.CLEAR, .value=.{ .r=color.?.r, .g=color.?.g, .b=color.?.b, .a=color.?.a } };

    return color orelse extra.Color {
        .r = pass_action.colors[0].value.r,
        .g = pass_action.colors[0].value.g,
        .b = pass_action.colors[0].value.b,
        .a = pass_action.colors[0].value.a,
    };
}

pub fn rect(r: extra.Rectangle, color: extra.Color) void {
    render(
        .{
            .origin = .{.x=0, .y=0, .w=1, .h=1}, 
            .position = .{.x=r.x, .y=r.y}, 
            .color = color, 
            .scale = .{.x=r.w, .y=r.h},
        }
    );
}

pub fn outlineRect(r: extra.Rectangle, color: extra.Color) void {
    rect(.{.x=r.x, .y=r.y-1,   .w=r.w, .h=1}, color);
    rect(.{.x=r.x, .y=r.y+r.h, .w=r.w, .h=1}, color);

    rect(.{.x=r.x-1,   .y=r.y, .w=1, .h=r.h}, color);
    rect(.{.x=r.x+r.w, .y=r.y, .w=1, .h=r.h}, color);
}

pub fn print(p: extra.Vector, t: []const u8, end: ?usize, limit: f64, color: extra.Color, highlight: ?extra.Color) !void {
    if (end != null and end.? == 0)
        return;

    var cp: extra.Vector = p;
    var i: usize = 0;

    var wobbly: bool = false;
    var h = highlight orelse color;
    var ih: bool = false;

    var iter = (try std.unicode.Utf8View.init(t)).iterator();
    while (iter.nextCodepoint()) |code| {
        switch (code) {
            '\n' => {
                cp.x = p.x;
                cp.y += 9;

                i += 1;
            },

            '\t' => {
                cp.x += 8 * 4;
                i += 1;
            },

            '*' => {
                ih = !ih;
            },

            '~' => {
                wobbly = !wobbly;
            },

            else => {
                var e: font.Character = main_font.characters.get(code) orelse main_font.unknown;

                var word_end = @intToFloat(f64, std.mem.indexOf(u8, t[i..], " ") orelse 0);

                if (cp.x+(word_end*8) > (limit + p.x)) {
                    cp.x = p.x;
                    cp.y += 9;
                }

                var tp = cp;
                tp.y -= e.origin.y;
                tp.x -= e.origin.x;
                tp.y -= @sin((timer*5) + tp.x) 
                    * @as(f64, if (wobbly) 1 else 0);
                
                if (code != ' ')
                    render(
                        .{
                            .origin = e.sprite, 
                            .position = tp,
                            .color = if (ih) h else color,
                        }
                    );
                cp.x += e.sprite.w - e.origin.x;

                i += 1;
            }
        }

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

    // TODO: GET THIS FRICKEN THING TO WORKKKKKKKK GOD DAMMIT AUGHHHHH
    audio.init(allocator) catch unreachable;

    if (comptime DEBUGMODE) {
        var sdtx_desc: st.Desc = .{};
        sdtx_desc.fonts[0] = st.fontZ1013();
        st.setup(sdtx_desc);
    }

    atlas = assets.Image.fromFile("atl_main.png", allocator) catch undefined;
    bind.fs_images[shd.SLOT_tex] = atlas.handle;

    main_font = font.generate(allocator) catch undefined;

    bind.vertex_buffers[0] = sg.makeBuffer(.{
        .usage = .STREAM,
        .size = quad_amount * 36 * 4
    });

    var indices: [quad_amount*6]u16 = undefined;
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
        .index_type = .UINT16,
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

    pass_action.colors[0] = .{ .action=.DONTCARE, .value=.{ .r=0, .g=0, .b=0, .a=0 } };
    text_pass_action.colors[0].action = .DONTCARE;

    setState(.main) catch unreachable;
    back.init() catch unreachable;
}

export fn frame() void {
    input.update();

    var delta = sapp.frameDuration();
    timer += delta;

    back.render() catch unreachable;

    width = @floatCast(f64, sapp.widthf());
    height = @floatCast(f64, sapp.heightf());
    var s = @floor(@min(width, height) / resolution);
    camera.z = @max(s, 1);
    real_camera = real_camera.lerp(camera, delta * 16);

    current_vertex = 0;

    if (s > 0)
        current_state.loop(delta) catch unreachable
    else {
        print(
            .{.x = -(width/2)+32}, "Not enough space :(", 
            null, width, .{.a=0.8}, null
        ) catch unreachable;
    }

    //if (comptime DEBUGMODE)
    //    outlineRect(.{.x=-125, .y=-125, .w=250, .h=250}, .{.a=0.4});

    var uniforms: shd.VsUniforms = .{
        .color_a = back.uniforms.color_a,
        .color_b = back.uniforms.color_b,
    };
    uniforms.color_a.a = filter;
    
    sg.updateBuffer(bind.vertex_buffers[0], sg.asRange(&vertices));

    sg.beginDefaultPass(pass_action, sapp.width(), sapp.height());
    sg.applyPipeline(pip);
    sg.applyBindings(bind);

    sg.applyUniforms(sg.ShaderStage.FS, 0, sg.asRange(&uniforms));

    sg.draw(0, @intCast(u32, current_vertex) * 6, 1);
    sg.endPass();

    if (comptime DEBUGMODE) {
        st.canvas(sapp.widthf()/2, sapp.heightf()/2);
        st.color1i(0xffffffff);
        st.origin(2, 2);
        st.font(0);
        st.print("Quads: {}/{} ({}b)", .{current_vertex, quad_amount, @sizeOf(f32)*current_vertex});
        st.crlf();
        st.print("Camera: [{d:.1}, {d:.1}, {d:.1}]", .{real_camera.x, real_camera.y, real_camera.z});
        st.crlf();
        st.print("Sources: {}", .{audio.sources.items.len});

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

    switch (ev[0].type) {
        .KEY_DOWN => {
            if (ev[0].key_code == sapp.Keycode.F11 and !ev[0].key_repeat)
                sapp.toggleFullscreen();
        },
        else => {}
    }
}

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .event_cb = event,
        .width = 815,
        .height = 550,
        .icon = .{
            .sokol_default = true,
        },
        .sample_count = 0,
        .window_title = "metahome"
    });
}