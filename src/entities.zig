const std = @import("std");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const znt = @import("znt.zig");
const extra = @import("extra.zig");

// TODO: Implement enemy AI through this thing :)
pub const Controller = enum {
    player
};

pub const Entity = struct {
    sprite:   main.Sprite,
    position: extra.Vector,
    velocity: extra.Vector,
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
        entity.velocity = extra.Vector{};
        entity.camera_focus = true;
    }
    return entity;
}

// TODO: Do fixed timesteps 
// TODO: Figure out how the hell do I remove entities ._.
pub fn process(scene: Scene, delta: f64) !void {
    {
        var ents = scene.iter(&.{ .velocity, .controller });
        while (ents.next()) | ent | {
            switch(ent.controller.*) {
                .player => {
                    var v: extra.Vector = .{};
                    const m = 30;

                    if (input.down(.up) > 0) 
                        v.y -= m;
                    
                    if (input.down(.down) > 0) 
                        v.y += m;

                    if (input.down(.left) > 0) 
                        v.x -= m;
                    
                    if (input.down(.right) > 0) 
                        v.x += m;

                    ent.velocity.* = v;
                }
            }
        }
    }

    {
        var ents = scene.iter(&.{ .position, .velocity });
        while (ents.next()) | ent | {
            ent.position.* = ent.position.add(ent.velocity.mul_f64(delta));
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

    {
        var ents = scene.iter(&.{ .camera_focus, .position });
        while (ents.next()) | ent | {
            main.camera = ent.position.*;
        }
    }
}