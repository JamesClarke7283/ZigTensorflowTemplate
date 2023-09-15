const std = @import("std");
const c = @cImport({
    @cInclude("tensorflow/c/c_api.h");
});

pub fn main() void {
    const version = c.TF_Version();
    std.debug.print("Hello from TensorFlow C library version {s}\n", .{version});
}
