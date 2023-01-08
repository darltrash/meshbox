const std = @import("std");
const Sdk = @import("lib/SDL.zig/Sdk.zig"); // Import the Sdk at build time
const sokol = @import("lib/sokol-zig/build.zig");
const lua = @import("lib/ziglua/build.zig");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});
  
    const sdk = Sdk.init(b);

    const exe = b.addExecutable("meshbox", "src/main.zig");
    exe.setTarget(target); 
    exe.setBuildMode(mode);
    exe.install();
    
    sdk.link(exe, .dynamic);

    const s = sokol.buildSokol(b, target, mode, .{.backend=.gles2}, "lib/sokol-zig/");
    exe.linkLibrary(s);

    exe.addPackage(lua.linkAndPackage(b, exe, .{}));
    exe.addPackage(sdk.getWrapperPackage("sdl2"));
    exe.addPackagePath("sokol", "lib/sokol-zig/src/sokol/sokol.zig");
    exe.addPackagePath("known-folders", "lib/known-folders/known-folders.zig");
        
    exe.addCSourceFile("lib/c/meta.c", &[_][]u8 {""});
    exe.addPackagePath("c", "lib/c/c.zig");
    exe.addIncludePath("lib/c");
    
    exe.install();

    const run_cmd = exe.run();
    //run_cmd.addArg("demo/");
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
