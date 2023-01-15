const std = @import("std");
const main = @import("rewrite.zig");
const input = @import("input.zig");
const znt = @import("znt.zig");
const extra = @import("extra.zig");
const world = @import("world.zig");
const dialog = @import("dialog.zig");
const assets = @import("assets.zig");
const c = @import("c");

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
    animated: Animated,
    interact: Interaction,
    interact_anim: f64,
    dialogue: []const u8,
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
            .x = 3,  .y = 20, 
            .w = 10, .h = 4
        };
        entity.animated = Animated.player;
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

const Animated = struct {
    pub const player: Animated = .{
        .tracks = &[_][]const extra.Rectangle {
            &[_]extra.Rectangle {
                .{.x=136+0,  .y=0, .w=16, .h=24}, 
                .{.x=136+16, .y=0, .w=16, .h=24}, 
                .{.x=136+32, .y=0, .w=16, .h=24}
            },

            &[_]extra.Rectangle {
                .{.x=136+0,  .y=24, .w=16, .h=24}, 
                .{.x=136+16, .y=24, .w=16, .h=24}, 
                .{.x=136+32, .y=24, .w=16, .h=24}
            },

            &[_]extra.Rectangle {
                .{.x=136+0,  .y=48, .w=16, .h=24}, 
                .{.x=136+16, .y=48, .w=16, .h=24}, 
                .{.x=136+32, .y=48, .w=16, .h=24}
            },
        }
    };

    tracks: []const[]const extra.Rectangle,
    track: usize = 0,
    frame: f64 = 0
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
pub fn process(scene: Scene, map: *world.Level, delta: f64) !void {
    { // Controller
        var ents = scene.iter(&.{ .velocity, .controller, .sprite, .animated });
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
                        if (ent.animated.*.frame < 1)
                            ent.animated.*.frame = 1;
                        ent.animated.*.frame += delta * 5;

                        if (ent.animated.*.frame >= 3)
                            ent.animated.*.frame = 1;
                    } else 
                        ent.animated.*.frame = 0;

                    if (v.y < 0) {
                        ent.animated.*.track = 2;
                    } else if (v.y > 0) {
                        ent.animated.*.track = 0;
                    } else if (v.x != 0) {
                        ent.animated.*.track = 1;
                    }

                    if (v.x != 0) {
                        ent.sprite.*.scale.x = std.math.sign(v.x);
                    }

                    ent.sprite.*.from_center = true;

                    ent.velocity.* = v;
                }
            }
        }
    }

    { // Velocity + Collision
        var ents = scene.iter(&.{ .position, .velocity });
        while (ents.next()) | ent | {
            var vel = ent.velocity.*;

            var raw_coll = scene.getOne(.collider, ent.id);
            if (raw_coll != null) {
                var collider: extra.Rectangle = .{
                    .x = raw_coll.?.x+ent.position.x,
                    .y = raw_coll.?.y+ent.position.y,
                    .w = raw_coll.?.w,
                    .h = raw_coll.?.h
                };
                var size = @as(f64, world.chunk_size);

                // TODO: OPTIMIZE THIS HELLISH ABOMINATION.
                {
                    var colliders = std.ArrayList(extra.Collision).init(main.allocator);
                    var iter = map.eachChunk(collider.grow(size, size));

                    while (iter.next()) | chunk | {
                        for (chunk.colls.items) | coll, key | {
                            if (coll.id == ent.id) { // Deletes itself
                                _ = chunk.colls.swapRemove(key);
                                continue;
                            }
                        }

                        for (chunk.colls.items) | coll | {
                            var collision = coll.collider.vsKinematic(collider, vel, delta);
                            if (collision != null) {
                                var coll_now: extra.Collision = collision.?;
                                coll_now.collider = coll.collider;
                                try colliders.append(coll_now);
                            } else { // TODO: FIX THIS HACK
                                if (coll.collider.colliding(collider))
                                    vel = .{};
                            }
                        }
                    }

                    var last: extra.Rectangle = .{};
                    for (colliders.items) | coll | {
                        if (last.equals(coll.collider)) continue;

                        last = coll.collider;

                        var collision = collider.solveCollision(coll.collider, vel, delta);
                        if (collision != null)
                            vel = collision.?.velocity;

                        if ((comptime main.DEBUGMODE) and ent.id == player)
                            main.rect(coll.collider, .{.g=0, .b=0, .a=0.1});
                    }

                    colliders.deinit();
                }

                {
                    collider.x += vel.x * delta;
                    collider.y += vel.y * delta;

                    var iter = map.eachChunk(collider);
                
                    while (try iter.nextOrCreate(main.allocator)) | chunk | {
                        try chunk.colls.append(.{
                            .id = ent.id,
                            .collider = collider
                        });
                    }
                }
            }
            
            var pos = ent.position.add(vel.mul_f64(delta));

            ent.position.* = pos;
            //if (scene.getOne(comptime comp: Component, eid: EntityId))
        }
    }

    { // Animation
        var ents = scene.iter(&.{ .sprite, .animated });
        while (ents.next()) | ent | {
            const track = ent.animated.tracks[ent.animated.track];
            const frame = @mod(@floatToInt(usize, ent.animated.frame), track.len);
            ent.sprite.*.origin = track[frame];
        }
    }

    var buffer = std.ArrayList(main.Sprite).init(main.allocator);
    { // Drawing 
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

    { // NPC/Dialogue
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
            pos.y += 0.1;
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
    // the other sort just broke so i decided to use this one instead
    _ = std.sort.insertionSort(main.Sprite, buffer.items, false, sorter);

    for (buffer.items) | sprite | {
        main.render(sprite);
    }

    buffer.deinit();

    if (false and comptime main.DEBUGMODE) { // DEBUG 
        {
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
            var ents = scene.iter(&.{ .position, .collider });
            while (ents.next()) | ent | {
                main.rect(.{
                    .x = ent.collider.x + ent.position.x,
                    .y = ent.collider.y + ent.position.y,
                    .w = ent.collider.w, 
                    .h = ent.collider.h
                }, .{.a=0.4});
            }
        }
    }

    { // CAMERA
        var ents = scene.iter(&.{ .camera_focus, .position, .sprite });
        while (ents.next()) | ent | {
            main.camera = ent.position.*;
            main.camera.x += ent.sprite.origin.w/2;
            main.camera.y += ent.sprite.origin.h/2;
        }
    }
}