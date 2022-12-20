const audio = @import("sokol").audio;
const std = @import("std");
const c = @import("c");
const assets = @import("assets.zig");

pub const Source = struct {
    loop: bool = false,
    length: u64,
    mp3: c.drmp3_t,

    pub fn create(raw: []const u8, loop: bool) !Source {
        var mp3: c.drmp3_t = undefined;
        var status = c.drmp3_init_memory(@ptrCast(*c.drmp3, &mp3), raw.ptr, raw.len, null);

        if (status == 0)
            return error.couldNotDecode;

        return Source {
            .loop = loop,
            .length = c.drmp3_get_pcm_frame_count(@ptrCast(*c.drmp3, &mp3)),
            .mp3 = mp3,
        };
    }
};

pub var sources: std.ArrayList(Source) = undefined;

fn thread(buffer: [*c]f32, frames: i32, channels: i32) callconv(.C) void {
    //_ = buffer;
    //_ = frames;
    //_ = channels;

    //var this_buffer = allocator.alloc(f32, @intCast(usize, frames)) catch unreachable;
    
    var i: usize = 0;
    while (i < (frames*channels)) {
        buffer[i] = 0;
        i += 1;
    }

    for (sources.items) | *source, key | {
        var m = @ptrCast(*c.drmp3, &source.mp3);
        _ = c.drmp3_read_pcm_frames_f32(m, @intCast(u64, frames), buffer);

        if (source.mp3.currentPCMFrame == source.length) {
            if (source.loop) {
                std.log.info("{}", .{c.drmp3_seek_to_pcm_frame(m, 0)});
            } else {
                _ = sources.orderedRemove(key);
            }
        }
        //for (this_buffer) | val, k | {
        //    buffer[k] += val;
        //}

    }

    //allocator.free(this_buffer);
}

pub fn addSource(source: Source) !void {
    try sources.append(source);
}

var allocator: std.mem.Allocator = undefined;

pub fn init(alloc: std.mem.Allocator) !void {
    allocator = alloc;

    sources = std.ArrayList(Source).init(allocator);

    try addSource(try Source.create(assets.@"mus_await.mp3", true));

    audio.setup(.{ 
        .stream_cb = thread,  
        .num_channels = 2,
        .sample_rate = 48000
    });
}
