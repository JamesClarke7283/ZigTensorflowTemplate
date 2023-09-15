const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ZigTensorflowTemplate Executable
    const exe = b.addExecutable(.{
        .name = "ZigTensorflowTemplate",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    exe.linkSystemLibrary("tensorflow");
    b.installArtifact(exe);

    // Prepare Dataset Executable
    const prepare_dataset = b.addExecutable(.{
        .name = "prepare_dataset",
        .root_source_file = .{ .path = "src/prepare_dataset.zig" },
        .target = target,
        .optimize = optimize,
    });
    prepare_dataset.linkLibC();
    prepare_dataset.linkSystemLibrary("tensorflow");
    b.installArtifact(prepare_dataset);

    // Train Executable
    const train = b.addExecutable(.{
        .name = "train",
        .root_source_file = .{ .path = "src/train.zig" },
        .target = target,
        .optimize = optimize,
    });
    train.linkLibC();
    train.linkSystemLibrary("tensorflow");
    b.installArtifact(train);

    // Predict Executable
    const predict = b.addExecutable(.{
        .name = "predict",
        .root_source_file = .{ .path = "src/predict.zig" },
        .target = target,
        .optimize = optimize,
    });
    predict.linkLibC();
    predict.linkSystemLibrary("tensorflow");
    b.installArtifact(predict);

    // Add Run Steps
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // Add Custom Steps
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
