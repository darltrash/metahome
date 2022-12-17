const assets = @import("assets");

const std = @import("std");
const sg  = @import("sokol").gfx;
const png = @import("zpng.zig");

pub usingnamespace assets;

// TODO: MOVE TO ZPNG AND DELETE AS MUCH C DEPS
//       AS POSSIBLE!

pub const Image = struct { 
    const Pixel = packed struct { 
        r: u8, g: u8, b: u8, a: u8
    };

    w: u32 = 0, h: u32 = 0, 
    handle: sg.Image = undefined,

    pub fn new(raw: []const u8, allocator: std.mem.Allocator) !Image {
        var b = std.io.fixedBufferStream(raw);
        var i = try png.Image.read(allocator, b.reader());
        
        var o: Image = .{
            .w = i.width,
            .h = i.height
        };

        var img = sg.ImageDesc {
            .width  = @intCast(i32, i.width ), 
            .height = @intCast(i32, i.height)
        };

        var pixels = std.ArrayList(Pixel).init(allocator);
        for (i.pixels) | origin | {
            try pixels.append(.{
                .r = @floatToInt(u8, (@intToFloat(f64, origin[0])/65535) * 255),
                .g = @floatToInt(u8, (@intToFloat(f64, origin[1])/65535) * 255),
                .b = @floatToInt(u8, (@intToFloat(f64, origin[2])/65535) * 255),
                .a = @floatToInt(u8, (@intToFloat(f64, origin[3])/65535) * 255)
            });
        }

        img.data.subimage[0][0] = sg.asRange(pixels.toOwnedSlice());
        o.handle = sg.makeImage(img);

        i.deinit(allocator);
        
        return o;
    }

    pub fn fromFile(comptime file: []const u8, allocator: std.mem.Allocator) !Image {
        return new(@field(assets, file), allocator);
    }
};