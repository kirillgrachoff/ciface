const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Modules
    const ciface_mod = b.addModule("ciface", .{
        .root_source_file = b.path("src/ciface.zig"),
    });

    // Dependencies
    const chameleon = b.dependency("chameleon", .{});
    const clap = b.dependency("clap", .{});


    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "ciface",
        .root_source_file = b.path("src/main.zig"),
        .pic = true,
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("chameleon", chameleon.module("chameleon"));
    exe.root_module.addImport("clap", clap.module("clap"));
    exe.root_module.addImport("ciface", ciface_mod);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/ciface.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
