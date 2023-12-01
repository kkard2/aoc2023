const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // don't judge i have no idea how to do it properly
    const puzzle = b.option([]const u8, "n", "Select puzzle (e.g. `01a`)").?;
    var path = try b.allocator.dupe(u8, "99/main_X.zig");

    // i am aware how horrible this looks
    path[0] = puzzle[0];
    path[1] = puzzle[1];
    path[8] = puzzle[2];

    const exe = b.addExecutable(.{
        .name = "app",
        .root_source_file = .{ .path = path },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
