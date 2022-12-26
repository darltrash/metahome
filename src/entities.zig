const std = @import("std");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const znt = @import("znt.zig");
const extra = @import("extra.zig");
const world = @import("world.zig");
const dialog = @import("dialog.zig");

// TODO: Implement enemy AI through this thing :)
pub const Controller = enum {
    player
};

pub const Entity = struct {
    sprite:   main.Sprite,
    position: extra.Vector,
    velocity: extra.Vector,
    collider: extra.Rectangle,
    animation: f64,
    collider_state: world.ColliderState,
    camera_focus: bool,
    controller: Controller
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

    if (entity.collider != null) {

    }

    return entity;
}

const Anim = struct {

    pub const player = [3]extra.Rectangle{
        .{.x=136+0,  .y=0, .w=16, .h=24}, 
        .{.x=136+16, .y=0, .w=16, .h=24}, 
        .{.x=136+32, .y=0, .w=16, .h=24}
    };
};
// TODO: Do fixed timesteps 
// TODO: Figure out how the hell do I remove entities ._.
pub fn process(scene: Scene, map: *world.World, delta: f64) !void {
    if (!dialog.active) {
        var ents = scene.iter(&.{ .velocity, .controller, .sprite, .animation });
        while (ents.next()) | ent | {
            switch(ent.controller.*) {
                .player => {
                    var v: extra.Vector = .{};
                    const m = 60;

                    if (input.down(.up) > 0) 
                        v.y -= m;
                    
                    if (input.down(.down) > 0) 
                        v.y += m;

                    if (input.down(.left) > 0) 
                        v.x -= m;
                    
                    if (input.down(.right) > 0) 
                        v.x += m;

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

    {
        var buffer = std.ArrayList(main.Sprite).init(main.allocator);
        var ents = scene.iter(&.{ .sprite, .position });
        while (ents.next()) | ent | {
            var spr = ent.sprite.*;
            spr.position = spr.position.add(ent.position.*);

            //var vel = scene.getOne(.velocity, ent.id);
            //if (vel != null) 
            //    spr.position = spr.position.add(vel.?.*.mul_f64(delta));

            try buffer.append(spr);
        }

        var sprites = try buffer.toOwnedSlice();

        // the other sort just broke so i decided to use this one instead
        _ = std.sort.insertionSort(main.Sprite, sprites, false, sorter);

        for (sprites) | sprite | {
            main.render(sprite);
        }
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
            var rect: extra.Rectangle = .{
                .x = ent.position.x-1,
                .y = ent.position.y-1,
                .w = 2, .h = 2
            };

            main.rect(rect, .{});
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