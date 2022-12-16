const std = @import("std");
const sokol = @import("lib/sokol-zig/build.zig");
const ecs = @import("lib/zig-ecs/build.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
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
    
    exe.linkLibrary(sokol_build);
    exe.addIncludePath("lib/c/");
    exe.addCSourceFile("lib/c/meta.c", &[_][]const u8 {
        "-DSTBI_ONLY_PNG", "-DSTBI_NO_STDIO"
    });

    exe.addPackagePath("c", "lib/c/c.zig");
    exe.addPackagePath("sokol", "lib/sokol-zig/src/sokol/sokol.zig");
    exe.addPackagePath("assets", "assets/assets.zig");

    //ecs.linkArtifact(b, exe, target, .static, "lib/zig-ecs");
    //exe.addPackage(ecs.getPackage("lib/zig-ecs"));

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
