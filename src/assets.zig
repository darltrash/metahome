const assets = @import("assets");

const std = @import("std");
const sg  = @import("sokol").gfx;
const c   = @import("c");

pub usingnamespace assets;

pub const Image = struct { 
    w: u32 = 0, h: u32 = 0, 
    handle: sg.Image,

    pub fn new(raw: []const u8) !Image {
        var a: Image = undefined;

        var w: c_int = 0;
        var h: c_int = 0;

        if (c.stbi_info_from_memory(raw.ptr, @intCast(c_int, raw.len), &w, &h, null) == 0)
            return error.NotPngFile;

        a.w = @intCast(u32, w);
        a.h = @intCast(u32, h);

        if (a.w <= 0 or a.h <= 0) 
            return error.NoPixels;

        if (c.stbi_is_16_bit_from_memory(raw.ptr, @intCast(c_int, raw.len)) != 0)
            return error.InvalidFormat;

        const bits_per_channel = 8;
        const channel_count = 4;

        const image_data = c.stbi_load_from_memory(raw.ptr, @intCast(c_int, raw.len), &w, &h, null, channel_count);

        if (image_data == null) 
            return error.NoMem;

        var img = sg.ImageDesc {
            .width  = @intCast(i32, a.w), 
            .height = @intCast(i32, a.h),
        };

        var pitch = a.w * bits_per_channel * channel_count / 8;

        img.data.subimage[0][0] = sg.asRange(image_data[0 .. a.h * pitch]);
        a.handle = sg.makeImage(img);

        std.c.free(image_data);

        return a;
    }

    pub fn fromFile(comptime file: []const u8) !Image {
        return new(@field(assets, file));
    }
};