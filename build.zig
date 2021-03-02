const bld = @import("std").build;
const mem = @import("std").mem;
const zig = @import("std").zig;

fn macosAddSdkDirs(b: *bld.Builder, step: *bld.LibExeObjStep) !void {
    const sdk_dir = try zig.system.getSDKPath(b.allocator);
    const framework_dir = try mem.concat(b.allocator, u8, &[_][]const u8{ sdk_dir, "/System/Library/Frameworks" });
    const usrinclude_dir = try mem.concat(b.allocator, u8, &[_][]const u8{ sdk_dir, "/usr/include" });
    step.addFrameworkDir(framework_dir);
    step.addIncludeDir(usrinclude_dir);
}

pub fn buildSokol(b: *bld.Builder, comptime prefix_path: []const u8) *bld.LibExeObjStep {
    const lib = b.addStaticLibrary("sokol", null);
    lib.linkLibC();
    lib.setBuildMode(b.standardReleaseOptions());
    const sokol_path = prefix_path ++ "src/sokol/c/";
    const csources = [_][]const u8{
        "sokol_app_gfx.c",
        "sokol_time.c",
        "sokol_audio.c",
        "sokol_gl.c",
        "sokol_debugtext.c",
        "sokol_shape.c",
    };
    if (lib.target.isDarwin()) {
        macosAddSdkDirs(b, lib) catch unreachable;
        inline for (csources) |csrc| {
            lib.addCSourceFile(sokol_path ++ csrc, &[_][]const u8{ "-ObjC", "-DIMPL" });
        }
        lib.linkFramework("MetalKit");
        lib.linkFramework("Metal");
        lib.linkFramework("Cocoa");
        lib.linkFramework("QuartzCore");
        lib.linkFramework("AudioToolbox");
    } else {
        inline for (csources) |csrc| {
            lib.addCSourceFile(sokol_path ++ csrc, &[_][]const u8{"-DIMPL"});
        }
        if (lib.target.isLinux()) {
            lib.linkSystemLibrary("X11");
            lib.linkSystemLibrary("Xi");
            lib.linkSystemLibrary("Xcursor");
            lib.linkSystemLibrary("GL");
            lib.linkSystemLibrary("asound");
        }
    }
    return lib;
}

pub fn build(b: *bld.Builder) void {
    const e = b.addExecutable("metahome", "src/main.zig");
    e.linkLibrary(buildSokol(b, ""));
    e.addPackagePath("sokol", "src/sokol/sokol.zig");

    //e.linkSystemLibrary("c");

    e.addIncludeDir("src/fileformats/");
    e.addCSourceFile("src/fileformats/stb_image_impl.c", &[_][]const u8{"-std=c99"});
    e.addPackagePath("fileformats", "src/fileformats/glue.zig");

    e.addIncludeDir("src/filesystem/");
    e.addCSourceFile("src/filesystem/zip.c", &[_][]const u8{"-std=c99"});
    e.addPackagePath("fs", "src/filesystem/handler.zig");

    e.install();
    b.step("run", "Run metahome").dependOn(&e.run().step);
}
