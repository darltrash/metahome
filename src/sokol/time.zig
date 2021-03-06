// machine generated, do not edit

pub extern fn stm_setup() void;
pub fn setup() callconv(.Inline) void {
    stm_setup();
}
pub extern fn stm_now() u64;
pub fn now() callconv(.Inline) u64 {
    return stm_now();
}
pub extern fn stm_diff(u64, u64) u64;
pub fn diff(new_ticks: u64, old_ticks: u64) callconv(.Inline) u64 {
    return stm_diff(new_ticks, old_ticks);
}
pub extern fn stm_since(u64) u64;
pub fn since(start_ticks: u64) callconv(.Inline) u64 {
    return stm_since(start_ticks);
}
pub extern fn stm_laptime([*c] u64) u64;
pub fn laptime(last_time: * u64) callconv(.Inline) u64 {
    return stm_laptime(last_time);
}
pub extern fn stm_round_to_common_refresh_rate(u64) u64;
pub fn roundToCommonRefreshRate(frame_ticks: u64) callconv(.Inline) u64 {
    return stm_round_to_common_refresh_rate(frame_ticks);
}
pub extern fn stm_sec(u64) f64;
pub fn sec(ticks: u64) callconv(.Inline) f64 {
    return stm_sec(ticks);
}
pub extern fn stm_ms(u64) f64;
pub fn ms(ticks: u64) callconv(.Inline) f64 {
    return stm_ms(ticks);
}
pub extern fn stm_us(u64) f64;
pub fn us(ticks: u64) callconv(.Inline) f64 {
    return stm_us(ticks);
}
pub extern fn stm_ns(u64) f64;
pub fn ns(ticks: u64) callconv(.Inline) f64 {
    return stm_ns(ticks);
}
