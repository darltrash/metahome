const std = @import("std");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const znt = @import("znt.zig");
const extra = @import("extra.zig");
const world = @import("world.zig");
const dialog = @import("dialog.zig");
const assets = @import("assets.zig");

// TODO: Implement enemy AI through this thing :)
pub const Controller = enum {
    player
};

pub const Interaction = enum {
    none, available, occupied
};

pub const Entity = struct {
    sprite:   main.Sprite,
    position: extra.Vector,
    velocity: extra.Vector,
    collider: extra.Rectangle,
    interact: Interaction,
    interact_anim: f64,
    dialogue: []const u8,
    animation: f64,
    camera_focus: bool,
    controller: Controller,
    collider_state: world.ColliderState,
};

pub const Scene = znt.Scene(Entity, .{});

fn sorter(_: bool, a: main.Sprite, b: main.Sprite) bool {
    return (a.position.y+(a.origin.h*a.scale.y)) 
         < (b.position.y+(b.origin.h*b.scale.y));
}

pub fn init(ent: Scene.OptionalEntity) Scene.OptionalEntity {
    var entity = ent;
    if (entity.controller != null) {
        entity.velocity = .{};
        entity.camera_focus = true;
        entity.collider = .{
            .x = 0,  .y = 20, 
            .w = 16, .h = 4
        };
        entity.animation = 0;
    }

    if (entity.dialogue != null) {
        if (!assets.scripts.has(entity.dialogue.?)) {
            entity.dialogue = null;
        }
    }

    if (entity.interact != null)
        entity.interact_anim = 0;

    return entity;
}

var player: ?znt.EntityId = 0;

// TODO: Implement animation struct to ease out animation
const Anim = struct {
    pub const player = [3]extra.Rectangle{
        .{.x=136+0,  .y=0, .w=16, .h=24}, 
        .{.x=136+16, .y=0, .w=16, .h=24}, 
        .{.x=136+32, .y=0, .w=16, .h=24}
    };
};

fn getPosition(scene: Scene, entity: znt.EntityId) extra.Vector {
    var pos: extra.Vector = .{};
    var _pos = scene.getOne(.position, entity);
    if (_pos != null) 
        pos = _pos.?.*;
    
    var _spr = scene.getOne(.sprite, entity);
    if (_spr != null) 
        pos = pos.add(.{
            .x = _spr.?.*.origin.w/2,
            .y = _spr.?.*.origin.h  
        });

    return pos;
}

// TODO: Do fixed timesteps 
// TODO: Figure out how the hell do I remove entities ._.
pub fn process(scene: Scene, map: *world.World, delta: f64) !void {
    {
        var ents = scene.iter(&.{ .velocity, .controller, .sprite, .animation });
        while (ents.next()) | ent | {
            switch(ent.controller.*) {
                .player => {
                    player = ent.id;
                    var v: extra.Vector = .{};
                    const m = 60;

                    if (!dialog.active) {
                        if (input.down(.up) > 0) 
                            v.y -= m;
                        
                        if (input.down(.down) > 0) 
                            v.y += m;

                        if (input.down(.left) > 0) 
                            v.x -= m;
                        
                        if (input.down(.right) > 0) 
                            v.x += m;
                    }

                    var moving = v.distance(.{}) > 0;
                    if (moving) {
                        if (ent.animation.* < 1)
                            ent.animation.* = 1;
                        ent.animation.* += delta * 3;

                        if (ent.animation.* >= 3)
                            ent.animation.* = 1;
                    } else 
                        ent.animation.* = 0;

                    var spr = Anim.player[@floatToInt(usize, ent.animation.*)];

                    if (v.y < 0) {
                        spr.y += 48;
                    } else if (v.x != 0) {
                        spr.y += 24;
                    }

                    if (v.x != 0) {
                        ent.sprite.*.scale.x = std.math.sign(v.x);
                    }

                    ent.sprite.*.origin = spr;
                    ent.sprite.*.from_center = true;

                    ent.velocity.* = v;
                }
            }
        }
    }

    {
        var ents = scene.iter(&.{ .position, .velocity });
        while (ents.next()) | ent | {
            _ = map;
            //var iter = map.eachChunk(ent.collider.?);
            //
            //while (iter.next()) | chunk | {
            //    try chunk.colls.append(.{
            //        .collider = ent.collider.?,
            //        .id = id
            //    });
            //}
            var pos = ent.position.add(ent.velocity.mul_f64(delta));

            ent.position.* = pos;
            //if (scene.getOne(comptime comp: Component, eid: EntityId))
        }
    }

    var buffer = std.ArrayList(main.Sprite).init(main.allocator);
    {
        var ents = scene.iter(&.{ .sprite, .position });
        while (ents.next()) | ent | {
            var spr = ent.sprite.*;
            spr.position = spr.position.add(ent.position.*);

            //var vel = scene.getOne(.velocity, ent.id);
            //if (vel != null) 
            //    spr.position = spr.position.add(vel.?.*.mul_f64(delta));

            try buffer.append(spr);
        }
    }

        {
        var ents = scene.iter(&.{ .interact, .position, .interact_anim });
        while (ents.next()) | ent | {
            var near = false;
            var middle = getPosition(scene, ent.id);

            if (ent.interact.* == .occupied) {
                // TODO: IMPLEMENT ANIMATION SYSTEM
                //var sprite = scene.getOne(.sprite, ent.id);
                //if (sprite != null) {
                //    sprite.?.* 
                //}

            } else if (ent.interact.* == .available)
                if (player != null) {
                    var pos = getPosition(scene, player.?);
                    near = middle.distance(pos) < 15;
                };

            var a = @as(f64, if (near) 1 else 0);
            ent.interact_anim.* = extra.lerp(f64, ent.interact_anim.*, a, delta * 6);

            var pos = ent.position.*;
            pos.x = middle.x - 8;
            //pos.y += 0.1;
            pos.z = ent.interact_anim.* * -12;

            try buffer.append(.{
                .position = pos,
                .origin = .{
                    .x=240, .y=0, .w=16, .h=16
                },
                .color = .{ .a=@floatCast(f32, ent.interact_anim.*) }
            });

            var dialogue = scene.getOne(.dialogue, ent.id);
            if (
                dialogue != null 
                and near 
                and input.down(.action) == 2 
                and !dialog.active
            ) {
                _ = try dialog.loadScript(assets.scripts.get(dialogue.?.*).?);
                ent.interact.* = .occupied;
            }
        }
    }

    var sprites = try buffer.toOwnedSlice();

    // the other sort just broke so i decided to use this one instead
    _ = std.sort.insertionSort(main.Sprite, sprites, false, sorter);

    for (sprites) | sprite | {
        main.render(sprite);
    }

    if (false and comptime main.DEBUGMODE) {
        var ents = scene.iter(&.{ .collider, .position });
        while (ents.next()) | ent | {
            var rect = ent.collider.*;
            rect.x += ent.position.x;
            rect.y += ent.position.y;

            main.rect(rect, .{.g=0, .b=0, .a=0.4});
        }
    }

    if (false and comptime main.DEBUGMODE) {
        var ents = scene.iter(&.{ .position });
        while (ents.next()) | ent | {
            main.rect(.{
                .x = ent.position.x-1,
                .y = ent.position.y-1,
                .w = 2, .h = 2
            }, .{.a=0.4});

            var p = getPosition(scene, ent.id);

            main.rect(.{
                .x = p.x-1,
                .y = p.y-1,
                .w = 2, .h = 2
            }, .{});
        }
    }

    {
        var ents = scene.iter(&.{ .camera_focus, .position, .sprite });
        while (ents.next()) | ent | {
            main.camera = ent.position.*;
            main.camera.x += ent.sprite.origin.w/2;
            main.camera.y += ent.sprite.origin.h/2;
        }
    }
}