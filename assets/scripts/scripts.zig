const std = @import("std");

pub const Entry = std.meta.Tuple(&[_]type {[]const u8, []const u8});

pub const scripts = std.ComptimeStringMap([]const u8, blk: {
    const raw_entries = [_][]const u8 { 
        "env_door_enter.json", 
        "env_store_posters0.json",
        "npc_test01.json"
    };
    var out: [raw_entries.len]Entry = undefined;

    for (raw_entries) | file, key | {
        out[key] = .{
            file[0..file.len-5], @embedFile(file)
        };
    }

    break :blk out;
});