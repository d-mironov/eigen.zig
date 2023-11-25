/// Author: Daniel Mironow
///
///
const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const MatrixError = error{
    ShapeError,
    OutOfBound,
};

pub const Shape = struct { usize, usize };

pub const Matrix = struct {
    rows: usize,
    cols: usize,
    data: ArrayList(f64),
    shape: Shape,

    pub fn from_file(file: std.fs.File) (MatrixError || Allocator.Error)!Matrix {
        _ = file;
        // TODO: Create a matrix from a file
        //
        // Example:
        // 4 5
        // 1 6 7 2 6
        // 9 5 2 2 1
        // 8 3 4 9 2
        // 3 4 7 6 3
    }

    /// Create a zero initialized Matrix
    pub fn init(rows: usize, cols: usize, allocator: std.mem.Allocator) (MatrixError || Allocator.Error)!Matrix {
        if (rows == 0 or cols == 0) {
            return MatrixError.ShapeError;
        }
        // Create an ArrayList and fill with zeros
        var data = ArrayList(f64).init(allocator);
        for (0..(rows * cols)) |_| {
            try data.append(0);
        }
        return Matrix{
            .shape = .{ rows, cols },
            .rows = rows,
            .cols = cols,
            .data = data,
        };
    }

    /// Create a Zero initialized square Matrix
    pub fn init_square(size: usize, allocator: std.mem.Allocator) (MatrixError || Allocator.Error)!Matrix {
        return Matrix.init(size, size, allocator);
    }

    /// Create a zero initialized square matrix with ones on the diagonal
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

    pub fn format(
        self: Matrix,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        try writer.writeAll("[[");
        for (0..self.rows) |i| {
            if (i != 0) {
                try writer.writeAll(" [");
            }
            for (0..self.cols) |j| {
                // var val = try self.get(i, j);
                const val = self.data.items[i * self.cols + j];
                if (j == self.cols - 1) {
                    try writer.print(" {}", .{val});
                } else {
                    try writer.print(" {},", .{val});
                }
            }
            if (i < self.rows - 1) {
                try writer.writeAll("],\n");
            } else {
                try writer.writeAll("]");
            }
        }
        try writer.writeAll("]");
    }

    /// Insert an element into the Matrix
    pub fn insert(self: *Matrix, row: usize, col: usize, val: f64) (MatrixError || Allocator.Error)!void {
        if (row >= self.rows or col >= self.cols) {
            return MatrixError.OutOfBound;
        }
        try self.data.insert(row * self.cols + col, val);
    }

    /// Get an element from the Matrix
    pub fn get(self: Matrix, row: usize, col: usize) (MatrixError || Allocator.Error)!f64 {
        if (row >= self.rows or col >= self.cols) {
            return MatrixError.OutOfBound;
        }
        return self.data.items[row * self.cols + col];
    }

    /// Release the allocated memory
    pub fn deinit(self: *Matrix) void {
        self.data.deinit();
    }
};

// pub fn matrix(vector: ArrayList(f64), rows: usize, cols: usize, shape: Shape) MatrixError!Matrix {
//     if (rows == 0 or cols == 0) {
//         return MatrixError.ShapeError;
//     }
//     return Matrix{ .data = vector, .rows = rows, .cols = cols, .shape = shape };
// }
