// Neil, stop trying to make it "efficient"
// just get it done, for love's sake...

// TODO: Change library name...
const std = @import("std");

pub fn World(comptime RawEntity: type) type {
    return struct {
        pub const Entity = blk: {
            const raw_fields = std.meta.fields(RawEntity);
            var fields = [_]std.builtin.Type.StructField{undefined} ** (raw_fields.len + 2);

            if (@hasField(RawEntity, "zecs_id"))
                @panic("Declaration 'zecs_id' is reserved.");

            if (@hasField(RawEntity, "zecs_bitfield"))
                @panic("Declaration 'zecs_id' is reserved.");

            if ((raw_fields.len+2) > 64)
                @panic("Only up to 64 properties supported.");

            fields[0] = .{
                .name = "zecs_id",
                .field_type = ?usize,
                .default_value = &null,
                .is_comptime = false,
                .alignment = @alignOf(?usize),
            };

            fields[1] = .{
                .name = "zecs_bitfield",
                .field_type = u64,
                .default_value = &0,
                .is_comptime = false,
                .alignment = @alignOf(?usize),
            };

            for (raw_fields) | field, key | {
                fields[key+2] = .{
                    .name = field.name,
                    .field_type = ?field.field_type,
                    .default_value = &null,
                    .is_comptime = false,
                    .alignment = @alignOf(?field.field_type),
                };
            }

            break :blk @Type(.{ 
                .Struct = .{
                    .is_tuple = false,
                    .layout = .Auto,
                    .decls = &.{},
                    .fields = &fields
                }
            });
        };

        pub const FieldEnum = std.meta.FieldEnum(Entity);
        const List = std.MultiArrayList(Entity);
        const This = @This();

        allocator: std.mem.Allocator,
        list: List,
        generation: usize = 0,

        pub fn init(allocator: std.mem.Allocator) This {
            return .{
                .allocator = allocator,
                .list = List{}
            };
        }

        pub fn addEntity(self: *This, entity: Entity) !usize {
            var ent = entity;
            ent.zecs_id = self.generation;

            for (self.list.items(.zecs_id)) | val, key | {
                if (val != null) continue;

                self.list.set(key, ent);
                return key;
            }

            try self.list.append(self.allocator, ent);
            self.generation += 1;

            return ent.zecs_id orelse unreachable;
        }

        pub fn searchEntity(self: *This, entity: usize) ?*Entity {
            for (self.list.items(.zecs_id)) | *val | {
                if (val.*.zecs_id == entity)
                    return val;
            }
            return null;
        }

        fn bitpack(ent: Entity) u64 {  // 64 properties allowed.
            var fields = std.meta.fields(Entity);
            var out: u64 = 0;
            for (fields) | field, key | {
                if (@field(ent, field.name) == null) continue;

                out ^= (-1 ^ out) & (@as(1, u64) << key);
            }
            return out;
        }

        pub const Filter = struct {
            pub const Instance = struct {
                entity: usize,
                world: *This,

                pub fn getPointer(self: Instance, comptime what: []const u8) *@TypeOf(@field(Entity, what)) {
                    var i = self.world.list.items(comptime std.meta.stringToEnum(FieldEnum, what));
                    return &(i[self.entity] orelse unreachable);
                }
            };

            world: *This,
            bits: u64,

            pub fn iter(self: Filter) ?Instance {
                for (self.world.list.items(.zecs_id)) | val, key | {
                    if (val == null) continue;
                    
                    var ent = self.world.list.get(key);
                    if (ent.zecs_bitfield & self.bits == self.bits)
                        return Instance {
                            .world = self.world,
                            .entity = key
                        };
                }
                return null;
            }
        };

        const Fields = std.meta.Tuple(&.{ FieldEnum, FieldEnum });

        pub fn filter(self: *This, comptime fields: Fields) Filter {
            var check: u64 = 0;

            comptime for (std.meta.fields(fields)) | field | {
                check ^= (-1 ^ check) & (@as(1, u64) << @enumToInt(std.meta.stringToEnum(FieldEnum, field.name)));
            };

            return Filter {
                .bits = check,
                .world = self
            };  
        }
    };
}