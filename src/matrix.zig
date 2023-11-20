const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const MatrixError = error{
    ShapeError,
    OutOfBound,
};

// pub fn Node(comptime T: type) type {
//     return struct {
//         const Self = @This();
//
//         data: T,
//         next: ?*Self = null,
//         prev: ?*Self = null,
//
//         pub fn new(data: T, next: ?*Self, prev: ?*Self) Self {
//             return Self{
//                 .data = data,
//                 .next = next,
//                 .prev = prev,
//             };
//         }
//
//         pub fn get(self: Self) T {
//             return self.data;
//         }
//     };
// }
//

pub const Shape = struct { usize, usize };

pub const Matrix = struct {
    rows: usize,
    cols: usize,
    data: ArrayList(f64),
    shape: Shape,

    fn to_str(self: Matrix) []u8 {
        _ = self;
        var buf = "";
        _ = buf;
    }

    pub fn init(rows: usize, cols: usize, allocator: std.mem.Allocator) (MatrixError || Allocator.Error)!Matrix {
        if (rows == 0 or cols == 0) {
            return MatrixError.ShapeError;
        }
        var data = ArrayList(f64).init(allocator);
        for (0..(rows * cols)) |_| {
            try data.append(0);
        }
        return Matrix{
            .shape = .{ rows, cols },
            .rows = rows,
            .cols = cols,
            .data = ArrayList(f64).init(allocator),
        };
    }

    pub fn init_square(size: usize, allocator: std.mem.Allocator) (MatrixError || Allocator.Error)!Matrix {
        if (size == 0) {
            return MatrixError.ShapeError;
        }
        var data = ArrayList(f64).init(allocator);
        for (0..(size * size)) |_| {
            try data.append(0);
        }
        return Matrix{
            .shape = .{ size, size },
            .rows = size,
            .cols = size,
            .data = ArrayList(f64).init(allocator),
        };
    }

    pub fn eye(size: usize, allocator: Allocator) (MatrixError || Allocator.Error)!Matrix {
        if (size == 0) {
            return MatrixError.ShapeError;
        }
        var data = ArrayList(f64).init(allocator);
        for (0..(size * size)) |i| {
            if (i % (size + 1) == 0) {
                try data.append(1);
            } else {
                try data.append(0);
            }
        }
        return Matrix{
            .shape = .{ size, size },
            .rows = size,
            .cols = size,
            .data = data,
        };
    }

    pub fn insert(self: *Matrix, row: usize, col: usize, val: f64) (MatrixError || Allocator.Error)!void {
        if (row >= self.rows or col >= self.cols) {
            return MatrixError.OutOfBound;
        }
        try self.data.insert(row * self.cols + col, val);
    }

    pub fn get(self: Matrix, row: usize, col: usize) (MatrixError || Allocator.Error)!f64 {
        if (row >= self.rows or col >= self.cols) {
            return MatrixError.OutOfBound;
        }
        return self.data.items[row * self.cols + col];
    }

    pub fn deinit(self: *Matrix) void {
        self.data.deinit();
    }
};

pub fn matrix(vector: ArrayList(f64), rows: usize, cols: usize, shape: Shape) MatrixError!Matrix {
    if (rows == 0 or cols == 0) {
        return MatrixError.ShapeError;
    }
    return Matrix{ .data = vector, .rows = rows, .cols = cols, .shape = shape };
}
