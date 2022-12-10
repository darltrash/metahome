const std = @import("std");

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