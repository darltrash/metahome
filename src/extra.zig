const std = @import("std");

const real_lerp = lerp;
pub fn lerp(comptime T: type, a: T, b: T, t: T) T {
    comptime {
        const info = @typeInfo(T);
        if (info != .Float)
            @panic("Not a valid type! Must be a float!");
    }

    return a * (1.0 - t) + b * t;
}

pub fn roundTo(comptime T: type, a: T, to: T) T {
    comptime {
        const info = @typeInfo(T);
        if (info != .Float)
            @panic("Not a valid type! Must be a float!");
    }   

    return @round(a*to)/to;
}

pub const Color = extern struct {
    r: f32 = 1, 
    g: f32 = 1,
    b: f32 = 1, 
    a: f32 = 1,

    pub fn fromHex(n: u32) Color {
        return .{
            .r = @intToFloat(f32, (n >> 24) & 0xFF) / 255,
            .g = @intToFloat(f32, (n >> 16) & 0xFF) / 255,
            .b = @intToFloat(f32, (n >> 8 ) & 0xFF) / 255,
            .a = @intToFloat(f32,  n        & 0xFF) / 255
        };
    }
};

pub const Vector = struct {
    x: f64 = 0, y: f64 = 0,
    z: f64 = 0,

    pub fn lerp(a: Vector, b: Vector, t: f64) Vector {
        return .{
            .x = real_lerp(f64, a.x, b.x, t),
            .y = real_lerp(f64, a.y, b.y, t),
            .z = real_lerp(f64, a.z, b.z, t)
        };
    }

    pub fn distance(a: Vector, b: Vector) f64 {
        return std.math.sqrt (
              std.math.pow(f64, b.x - a.x,  2) 
            + std.math.pow(f64, b.y - a.y,  2) 
            + std.math.pow(f64, b.z - a.z,  2)
        );
    }

    pub fn add(a: Vector, b: Vector) Vector {
        return .{
            .x = a.x + b.x,
            .y = a.y + b.y,
            .z = a.z + b.z
        };
    }

    pub fn mul_f64(a: Vector, b: f64) Vector {
        return .{
            .x = a.x * b,
            .y = a.y * b,
            .z = a.z * b
        };
    }
};

pub const Rectangle = struct {
    pub const clip = Rectangle {
        .x = -1, .y = -1,
        .w =  2, .h =  2
    }; // Clip space min and max. [Pos, Size] format

    x: f64 = 0, y: f64 = 0,
    w: f64 = 0, h: f64 = 0,

    pub fn colliding(self: Rectangle, other: Rectangle) bool {
        return self.x  < (other.x+other.w) and
               other.x < (self.x+self.w) and
               self.y  < (other.y+other.h) and
               other.y < (self.y+self.h);
    }

    pub fn grow(self: Rectangle, width: f64, height: f64) Rectangle {
        return .{
            .x = self.x - (width/2), .y = self.y - (height/2), 
            .w = self.w + width, .h = self.y + height
        };
    }

    pub fn visible(self: Rectangle, width: f64, height: f64, camera: Vector) ?Rectangle {
        const w = width  / camera.z / 2;
        const h = height / camera.z / 2;

        var n: Rectangle = .{};
        n.x = (self.x - camera.x) / w;
        n.y = (self.y - camera.y) / h;
        n.w = self.w / w;
        n.h = self.h / h;

        return if (n.colliding(Rectangle.clip)) n else null;
    }
};

// great name, neil.
pub fn optionate(comptime T: type) type {
    const raw_fields = std.meta.fields(T);
    const fields: [raw_fields.len]std.builtin.Type.StructField = undefined;

    for (raw_fields) | field, k | {
        fields[k] = .{
            .name = field.name,
            .type = ?field.type,
            .default_value = &null,
            .is_comptime = false,
            .alignment = @alignOf(?field.type),
        };
    }

    return @Type(.{ .Struct = .{
        .is_tuple = false,
        .layout = .Auto,
        .decls = &.{},
        .fields = &fields,
    } });
}