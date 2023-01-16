pub const c = @cImport({
    @cInclude("dr_mp3.h");
});

pub usingnamespace c;

pub const sr_rec = extern struct { x: f64, y: f64, width: f64, height: f64 };

pub const sr_vec2 = extern struct { x: f64, y: f64 };

pub extern fn sr_move_and_slide(obstacles: [*c]sr_rec, obstacles_length: c_int, hitbox: sr_vec2, vel: [*c]sr_vec2, pos: [*c]sr_vec2, delta: f64) void;

// const DRMP3_MAX_PCM_FRAMES_PER_MP3_FRAME  = 1152;
// const DRMP3_MAX_SAMPLES_PER_FRAME         = (DRMP3_MAX_PCM_FRAMES_PER_MP3_FRAME*2);
//
// pub const drmp3_frame_info = extern struct {
//     frame_bytes: c_int,
//     channels: c_int,
//     hz: c_int,
//     layer: c_int,
//     bitrate_kbps: c_int
// };
//
// pub const drmp3dec = extern struct {
//     mdct_overlap: [2][9*32]f32,
//     qmf_state: [15*2*32]f32,
//     reserv: c_int,
//     free_format_bytes: c_int,
//     header: [4]u8,
//     reserv_buf: [511]u8
// };
//
// pub const drmp3_seek_point = extern struct {
//     seekPosInBytes: u64,
//     pcmFrameIndex: u64,
//     mp3FramesToDiscard: u16,
//     pcmFramesToDiscard: u16
// };
//
// pub const drmp3_allocation_callbacks = extern struct {
//     a: [4]*anyopaque
// };
//
pub const drmp3_t = extern struct { decoder: c.drmp3dec, channels: u32, sampleRate: u32, onRead: c.drmp3_read_proc, onSeek: c.drmp3_seek_proc, pUserData: *anyopaque, allocationCallbacks: c.drmp3_allocation_callbacks, mp3FrameChannels: u32, mp3FrameSampleRate: u32, pcmFramesConsumedInMP3Frame: u32, pcmFramesRemainingInMP3Frame: u32, pcmFrames: [@sizeOf(f32) * c.DRMP3_MAX_SAMPLES_PER_FRAME]u8, currentPCMFrame: u64, streamCursor: u64, pSeekPoints: c.drmp3_seek_point, seekPointCount: u32, dataSize: usize, dataCapacity: usize, dataConsumed: usize, pData: *u8, atEnd: u32, memory: extern struct { pData: *const u8, dataSize: usize, currentReadPos: usize } };
