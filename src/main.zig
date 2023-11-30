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
    try m2.insert(1, 1, 4.567890);
    std.debug.print("{s}\n", .{m2});

    // var m3 = try Matrix.init_square(30, allocator);
    // defer m3.deinit();
    // try m3.insert(10, 10, 4.567890);
    // std.debug.print("{s}\n", .{m3});
}

test "matrix insert" {
    const allocator = std.heap.page_allocator;

    var m1 = try Matrix.init(2, 2, allocator);
    defer m1.deinit();

    try m1.insert(0, 0, 1.0);
    try m1.insert(0, 1, 2.0);
    try m1.insert(1, 0, 3.0);
    try m1.insert(1, 1, 4.0);
    try expect(m1.insert(2, 0, 1.0) == MatrixError.OutOfBound);
}
test "matrix add" {
    const allocator = std.heap.page_allocator;
    var m1 = try Matrix.eye(2, allocator);
    var m2 = try Matrix.eye(2, allocator);
    const m3 = try m1.add(m2);
    var res = try Matrix.init(2, 2, allocator);
    try res.insert(0, 0, 2.0);
    try res.insert(1, 1, 2.0);

    try expect(res.rows == 2);
    try expect(res.cols == 2);
    try expect(try res.equal(m3) == true);

    // Check for different matrix dimensions
    m1 = try Matrix.eye(2, allocator);
    m2 = try Matrix.eye(3, allocator);
    try expect(m1.add(m2) == MatrixError.DimensionMismatch);
}

test "matrix sub" {
    const allocator = std.heap.page_allocator;

    // Default subtraction case
    var m1 = try Matrix.eye(2, allocator);
    var m2 = try Matrix.eye(2, allocator);
    const m3 = try m1.add(m2);
    var res = try Matrix.init_square(2, allocator);

    try expect(res.rows == 2);
    try expect(res.cols == 2);
    try expect(try res.equal(m3) == true);

    // Check for different matrix dimensions
    m1 = try Matrix.eye(2, allocator);
    m2 = try Matrix.eye(3, allocator);
    try expect(m1.sub(m2) == MatrixError.DimensionMismatch);
}
