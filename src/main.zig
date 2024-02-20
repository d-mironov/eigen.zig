const std = @import("std");
const expect = std.testing.expect;
const matrix = @import("matrix.zig");
const Matrix = matrix.Matrix;
const MatrixError = matrix.MatrixError;
const print = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var A = try Matrix.from_array([3][3]f64{
        .{ 1, 2, 3 },
        .{ 4, 5, 6 },
        .{ 7, 8, 9 },
    }, allocator);
    print("{}\n", .{A});

    var B = try Matrix.eye(3, allocator);
    var C = try A.mul(B, allocator);
    print("C == A -> {}\n", .{A.is_equal(C)});

    var A_T = try A.transposed(allocator);
    print("{}\n", .{A_T});

    A_T = try A.T();
    print("{}\n", .{A_T});

    try A.transpose();
    print("{}\n", .{A});
}
