const std = @import("std");
const expect = std.testing.expect;
const matrix = @import("matrix.zig");
const Matrix = matrix.Matrix;
const MatrixError = matrix.MatrixError;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var m1 = try Matrix.init(2, 2, allocator);
    defer m1.deinit();
    try m1.insert(0, 0, 1.0);
    try m1.insert(0, 1, 2.0);
    try m1.insert(1, 0, 3.0);
    try m1.insert(1, 1, 4.0);
    std.debug.print("{s}\n", .{m1});
    std.debug.print("{}\n", .{m1.max()});

    var eye = try Matrix.eye(4, allocator);
    defer eye.deinit();
    std.debug.print("{s}\n", .{eye});
    std.debug.print("{}\n", .{eye.max()});

    var m2 = try Matrix.init(4, 5, allocator);
    defer m2.deinit();
    try m2.insert(1, 1, 4.567890);
    std.debug.print("{s}\n", .{m2});
    std.debug.print("{}\n", .{m2.max()});

    var m3 = try Matrix.init_square(4, allocator);
    try m3.insert(0, 0, 10);
    try m3.insert(0, 1, 5);
    try m3.insert(0, 2, 9);
    try m3.insert(3, 2, 3);
    try m3.insert(3, 3, 11);
    std.debug.print("{}\n", .{m3.min()});
    // var m3 = try Matrix.init_square(30, allocator);
    // defer m3.deinit();
    // try m3.insert(10, 10, 4.567890);
    // std.debug.print("{s}\n", .{m3});
}
