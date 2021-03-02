const DEBUGMODE = true;
const ISWINDOWS = @import("builtin").os.tag == .windows;
const std = @import("std");
const panic = std.debug.panic;

pub const raw = @cImport({
    @cInclude("zip.h");
});

pub var zipfs: *raw.zip_t = undefined;

pub fn init() void {
    if (comptime !DEBUGMODE) {
        // Posix-only support rn, I am sorry :(
        zipfs = raw.zip_open("DATA.zip", 0, 'r') orelse @panic("Could not load ZIPFS");
        std.debug.warn("kuba--/zip loaded", .{});
    } 
}

pub fn deinit() void {
    if (comptime !DEBUGMODE) {
        raw.zip_close(zipfs);
    }
}

pub fn load(path: [:0]const u8) []u8 {
    var output: []u8 = undefined;
    if (comptime !DEBUGMODE) {
        std.debug.warn("UND_UND_ ", .{});
        var buffer: [*c]?*c_void = undefined;
        var buffersize: usize = undefined;

        if (raw.zip_entry_open(zipfs, path) == 0) {
            if (raw.zip_entry_read(zipfs, buffer, &buffersize) != 0) {
                panic("Error trying to read {s}, The data may be corrupted", .{path});
            }
            if (raw.zip_entry_close(zipfs) == 0) {
                panic("Error trying to close {s}, I am not sure what happened here.", .{path});
            }
        } else {
            panic("Error trying to open {s}, The file may not exist or the data is corrupted", .{path});
        }

        output = @ptrCast([*]u8, buffer)[0..buffersize];
    } else {
        var buffer = std.ArrayList(u8).init(std.heap.c_allocator);
        defer output = buffer.toOwnedSlice();

        var file = std.fs.cwd().openFile(path, .{.read = true}) catch panic("Error trying to load {s}!", .{path});
        defer file.close();
        file.reader().readAllArrayList(&buffer, 99999999) catch panic("Could not read {s}1", .{path}); // that's a lot, i know 
    }

    return output;
}
