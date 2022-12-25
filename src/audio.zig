const audio = @import("sokol").audio;
const extra = @import("extra.zig");
const main = @import("rewrite.zig");
const std = @import("std");
const c = @import("c");
const assets = @import("assets.zig");

pub const Source = struct {
    loop: bool = false,
    length: u64,
    mp3: c.drmp3_t,

    volume: f32 = 1,
    position: ?extra.Vector = null,

    pub fn create(raw: []const u8) !Source {
        var mp3: c.drmp3_t = undefined;
        var status = c.drmp3_init_memory(@ptrCast(*c.drmp3, &mp3), raw.ptr, raw.len, null);

        if (status == 0)
            return error.couldNotDecode;

        return Source {
            .length = c.drmp3_get_pcm_frame_count(@ptrCast(*c.drmp3, &mp3)),
            .mp3 = mp3,
        };
    }
};

pub var sources: std.ArrayList(Source) = undefined;

fn thread(buffer: [*c]f32, frames: i32, channels: i32) callconv(.C) void {
    var i: usize = 0;
    while (i < (frames*channels)) {
        buffer[i] = 0;
        i += 1;
    }

    //var a = main.allocator.alloc(f32, @intCast(usize, frames*channels)) catch unreachable;
    //defer allocator.free(a);

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

        var vol = source.volume;
        if (source.position != null)
            vol *= @floatCast(f32, source.position.?.distance(main.real_camera));


        //for (a) | val, k | {
        //    buffer[k] += val * vol;
        //}
    }

    //allocator.free(this_buffer);
}

pub fn addSource(source: Source) !*Source {
    try sources.append(source);
    return &sources.items[sources.items.len-1];
}

pub fn init(allocator: std.mem.Allocator) !void {
    sources = std.ArrayList(Source).init(allocator);

    audio.setup(.{ 
        .stream_cb = thread,  
        .num_channels = 2,
        .sample_rate = 48000
    });

    var a = try addSource(try Source.create(assets.@"mus_await.mp3"));
    a.volume = 0.1;
}
