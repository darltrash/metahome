const std = @import("std");

// TODO: Compress assets with zip, then decompress as needed.
pub const @"atl_main.png" = @embedFile("atl_main.png");
pub const @"map_test.json" = @embedFile("map_test.json");
pub const @"noise.bin" = @embedFile("noise.bin");
pub const @"mus_await.mp3" = @embedFile("mus_await.mp3");
pub const @"snd_dialog.mp3" = @embedFile("snd_dialog.mp3");

//fn encode() []const u8 {
//    var alloc = std.heap.HeapAllocator.allocator();
//    var reader = std.io.limitedReader(inner_reader: anytype, bytes_left: u64)
//    std.compress.gzip.gzipStream(alloc, )
//}