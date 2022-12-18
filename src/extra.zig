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