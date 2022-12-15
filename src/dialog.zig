const main = @import("rewrite.zig");

fn init() !void {

}

fn loop(delta: f64) !void {
    main.rect(.{.w=10, .h=10, .x=delta}, .{});
}

pub const state = main.State {
    .init = &init,
    .loop = &loop
};

