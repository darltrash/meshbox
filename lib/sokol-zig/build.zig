const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;
const CrossTarget = std.zig.CrossTarget;
const Mode = std.builtin.Mode;

pub const Backend = enum {
    auto,   // Windows: D3D11, macOS/iOS: Metal, otherwise: GL
    d3d11,
    metal,
    gl,
    gles2,
    gles3,
    wgpu,
};

pub const Config = struct {
    backend: Backend = .auto
};

// build sokol into a static library
pub fn buildSokol(b: *Builder, target: CrossTarget, mode: Mode, config: Config, comptime prefix_path: []const u8) *LibExeObjStep {
    const lib = b.addStaticLibrary("sokol", null);
    lib.setBuildMode(mode);
    lib.setTarget(target);
    
    lib.linkLibC();
    const sokol_path = prefix_path ++ "src/sokol/c/";
    const csources = [_][]const u8 {
        "sokol_gfx.c",
        "sokol_time.c",
        "sokol_debugtext.c",
    };
    var _backend = config.backend;
    if (_backend == .auto) {
        if (lib.target.isDarwin()) { _backend = .metal; }
        else if (lib.target.isWindows()) { _backend = .d3d11; }
        else { _backend = .gl; }
    }
    const backend_option = switch (_backend) {
        .d3d11 => "-DSOKOL_D3D11",
        .metal => "-DSOKOL_METAL",
        .gl => "-DSOKOL_GLCORE33",
        .gles2 => "-DSOKOL_GLES2",
        .gles3 => "-DSOKOL_GLES3",
        .wgpu => "-DSOKOL_WGPU",
        else => unreachable,
    };

    if (lib.target.isDarwin()) {
        inline for (csources) |csrc| {
            lib.addCSourceFile(sokol_path ++ csrc, &[_][]const u8{"-ObjC", "-DIMPL", backend_option});
        }
        lib.linkFramework("Cocoa");
        lib.linkFramework("QuartzCore");
        lib.linkFramework("AudioToolbox");
        if (.metal == _backend) {
            lib.linkFramework("MetalKit");
            lib.linkFramework("Metal");
        }
        else {
            lib.linkFramework("OpenGL");
        }
    } else {
        inline for (csources) |csrc| {
            lib.addCSourceFile(sokol_path ++ csrc, &[_][]const u8{"-DIMPL", backend_option});
        }

        if (lib.target.isLinux()) {
            if (.gles2 == _backend) {
                lib.linkSystemLibrary("glesv2");
            } else {
                lib.linkSystemLibrary("GL");
            }
        }
        else if (lib.target.isWindows()) {
            lib.linkSystemLibrary("kernel32");
            lib.linkSystemLibrary("user32");
            lib.linkSystemLibrary("gdi32");
            lib.linkSystemLibrary("ole32");
            if (.d3d11 == _backend) {
                lib.linkSystemLibrary("d3d11");
                lib.linkSystemLibrary("dxgi");
            }
        }
    }
    return lib;
}