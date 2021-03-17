// The MIT License (Expat)

// Copyright (c) 2015 Andrew Kelley

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

const std = @import("std");
const fs = @import("../filesystem/handler.zig");
const c = @cImport({
    @cInclude("stb_image.h");
});
pub const modplug = @cImport({
    @cInclude("modplug.h");
});

pub const Png = struct {
    width: u32,
    height: u32,
    pitch: u32,
    raw: []u8,

    pub fn destroy(pi: *PngImage) void {
        stbi_image_free(pi.raw.ptr);
    }

    pub fn create(compressed_bytes: []u8) !Png {
        var pi: Png = undefined;

        var width: c_int = undefined;
        var height: c_int = undefined;

        if (c.stbi_info_from_memory(compressed_bytes.ptr, @intCast(c_int, compressed_bytes.len), &width, &height, null) == 0) {
            return error.NotPngFile;
        }

        if (width <= 0 or height <= 0) return error.NoPixels;
        pi.width = @intCast(u32, width);
        pi.height = @intCast(u32, height);

        if (c.stbi_is_16_bit_from_memory(compressed_bytes.ptr, @intCast(c_int, compressed_bytes.len)) != 0) {
            return error.InvalidFormat;
        }
        const bits_per_channel = 8;
        const channel_count = 4;

        const image_data = c.stbi_load_from_memory(compressed_bytes.ptr, @intCast(c_int, compressed_bytes.len), &width, &height, null, channel_count);

        if (image_data == null) return error.NoMem;

        pi.pitch = pi.width * bits_per_channel * channel_count / 8;
        pi.raw = image_data[0 .. pi.height * pi.pitch];

        return pi;
    }

    pub fn fromFile(filename: [:0]const u8) !Png {
        var data = fs.load(filename);
        return Png.create(data);
    }
};
