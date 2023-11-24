const std = @import("std");
const expect = std.testing.expect;
const matrix = matrixlib.matrix;
const matrixlib = @import("matrix.zig");
const Matrix = matrixlib.Matrix;
const MatrixError = matrixlib.MatrixError;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var m1 = try Matrix.init(2, 2, allocator);
    defer m1.deinit();

    try m1.insert(0, 0, 1.0);
    try m1.insert(0, 1, 2.0);
    try m1.insert(1, 0, 3.0);
    try m1.insert(1, 1, 4.0);
    std.debug.print("{s}\n", .{m1});

    var eye = try Matrix.eye(4, allocator);
    defer eye.deinit();
    std.debug.print("{s}\n", .{eye});

    var m2 = try Matrix.init(4, 5, allocator);
    defer m2.deinit();
    std.debug.print("{s}\n", .{m2});
}

test "matrix test" {
    const allocator = std.heap.page_allocator;

    var m1 = try Matrix.init(2, 2, allocator);
    defer m1.deinit();

    try m1.insert(0, 0, 1.0);
    try m1.insert(0, 1, 2.0);
    try m1.insert(1, 0, 3.0);
    try m1.insert(1, 1, 4.0);
    try expect(m1.insert(2, 0, 1.0) == MatrixError.OutOfBound);
}
