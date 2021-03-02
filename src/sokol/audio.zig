// machine generated, do not edit

pub const Desc = extern struct {
    sample_rate: i32 = 0,
    num_channels: i32 = 0,
    buffer_frames: i32 = 0,
    packet_frames: i32 = 0,
    num_packets: i32 = 0,
    stream_cb: ?fn([*c] f32, i32, i32) callconv(.C) void = null,
    stream_userdata_cb: ?fn([*c] f32, i32, i32, ?*c_void) callconv(.C) void = null,
    user_data: ?*c_void = null,
};
pub extern fn saudio_setup([*c]const Desc) void;
pub fn setup(desc: Desc) callconv(.Inline) void {
    saudio_setup(&desc);
}
pub extern fn saudio_shutdown() void;
pub fn shutdown() callconv(.Inline) void {
    saudio_shutdown();
}
pub extern fn saudio_isvalid() bool;
pub fn isvalid() callconv(.Inline) bool {
    return saudio_isvalid();
}
pub extern fn saudio_userdata() ?*c_void;
pub fn userdata() callconv(.Inline) ?*c_void {
    return saudio_userdata();
}
pub extern fn saudio_query_desc() Desc;
pub fn queryDesc() callconv(.Inline) Desc {
    return saudio_query_desc();
}
pub extern fn saudio_sample_rate() i32;
pub fn sampleRate() callconv(.Inline) i32 {
    return saudio_sample_rate();
}
pub extern fn saudio_buffer_frames() i32;
pub fn bufferFrames() callconv(.Inline) i32 {
    return saudio_buffer_frames();
}
pub extern fn saudio_channels() i32;
pub fn channels() callconv(.Inline) i32 {
    return saudio_channels();
}
pub extern fn saudio_expect() i32;
pub fn expect() callconv(.Inline) i32 {
    return saudio_expect();
}
pub extern fn saudio_push([*c]const f32, i32) i32;
pub fn push(frames: *const f32, num_frames: i32) callconv(.Inline) i32 {
    return saudio_push(frames, num_frames);
}
