const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const root = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{ .name = "git-dash", .root_module = root });
    b.installArtifact(exe);

    // zig build run -- <repo> [days]
    const run = b.addRunArtifact(exe);
    run.step.dependOn(b.getInstallStep());
    run.addPassthruArgs();
    b.step("run", "git-dash'i çalıştır").dependOn(&run.step);

    const tests = b.addTest(.{ .root_module = root });
    b.step("test", "Birim testleri").dependOn(&b.addRunArtifact(tests).step);
}
