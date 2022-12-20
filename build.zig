const std = @import("std");
const sokol = @import("lib/sokol-zig/build.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var config: sokol.Config = .{};
    if (target.isLinux()) {
        config.backend = .gles2;
        config.use_egl = true;
    }

    const sokol_build = sokol.buildSokol(b, target, mode, config, "lib/sokol-zig/");

    const exe = b.addExecutable("metahome", "src/rewrite.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    
    exe.addCSourceFile("lib/c/meta.c", &[_][]u8 {""});
    exe.addPackagePath("c", "lib/c/c.zig");
    exe.addIncludePath("lib/c");

    exe.linkLibrary(sokol_build);
    exe.addPackagePath("sokol", "lib/sokol-zig/src/sokol/sokol.zig");
    exe.addPackagePath("assets", "assets/assets.zig");

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const map_step = b.step("maps", "Compile maps (REQUIRES LUA, *NIX)");
    map_step.dependOn(
        &b.addSystemCommand(&[_][]const u8 {
            "sh", "assets/compile_maps.sh"
        }).step
    );

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
