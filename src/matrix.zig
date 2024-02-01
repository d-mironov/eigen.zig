/// Author: Daniel Mironow
/// TODO: Add hardware specialized support
/// TODO: GPU support?
/// TODO: Multithreading?
///
const std = @import("std");
const expect = std.testing.expect;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const MatrixError = error{
    ShapeError,
    OutOfBound,
    DimensionMismatch,
};

pub const Shape = struct { usize, usize };

// TODO: Make generic
pub const Matrix = struct {
    rows: usize,
    cols: usize,
    data: ArrayList(f64),
    shape: Shape,
    allocator: std.mem.Allocator,
    // TODO: Add T (transpose) and I (inverse) of matrix as attributes
    // T: Matrix,
    // I: Matrix,

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

    pub fn to_file(file: std.fs.File) (MatrixError || Allocator.Error) {
        _ = file;
        // TODO: Write matrix to file
    }

    /// Create a zero initialized Matrix
    pub fn init(
        rows: usize,
        cols: usize,
        allocator: std.mem.Allocator,
    ) (MatrixError || Allocator.Error)!Matrix {
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
            .allocator = allocator,
        };
    }

    /// Create a Zero initialized square Matrix
    pub fn init_square(
        size: usize,
        allocator: std.mem.Allocator,
    ) (MatrixError || Allocator.Error)!Matrix {
        return Matrix.init(size, size, allocator);
    }

    pub fn fill(self: Matrix, value: f64) !void {
        _ = value;
        _ = self;
        // TODO: Filling matrix with one value
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
            .allocator = allocator,
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

    pub fn is_equal(self: Matrix, other: Matrix) MatrixError!bool {
        if (self.cols != other.rows or self.rows != other.cols) {
            return MatrixError.DimensionMismatch;
        }
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                const idx = row * self.cols + col;
                if (self.data.items[idx] != other.data.items[idx]) {
                    return false;
                }
            }
        }
        return true;
    }

    pub fn max(self: Matrix) MatrixError!f64 {
        _ = self;
        // TODO: Maximum value of matrix
    }

    pub fn max_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: Maximum value of matrix on given axis
    }

    pub fn min(self: Matrix) MatrixError!f64 {
        _ = self;
        // TODO: Minimum value of matrix
    }

    pub fn min_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: Minimum value of matrix on given axis
    }

    pub fn mean(self: Matrix) MatrixError!f64 {
        _ = self;
        // TODO: mean of matrix
    }

    pub fn mean_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: mean of matrix on given axis
    }

    pub fn sum(self: Matrix) MatrixError!f64 {
        _ = self;
        // TODO: sum of values in matrix
    }

    pub fn sum_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: sum of values in matrix on given axis
    }

    /// Multiply two matrices and return the output matrix
    pub fn mult(self: Matrix, other: Matrix) MatrixError!Matrix {
        if (self.cols != other.rows or self.rows != other.cols) {
            return MatrixError.DimensionMismatch;
        }
        // TODO: matrix multiplication
    }

    pub fn transpose(self: Matrix) MatrixError!Matrix {
        _ = self;
        // TODO: Matrix transpose
    }

    pub fn inverse(self: Matrix) MatrixError!Matrix {
        _ = self;
        // TODO: Matrix inverse
    }

    /// Add two matrices and return the resulting matrix
    pub fn add(self: Matrix, other: Matrix) (MatrixError || Allocator.Error)!Matrix {
        if (self.rows != other.rows and self.cols != other.rows) {
            return MatrixError.DimensionMismatch;
        }
        var retval = try Matrix.init(self.rows, self.cols, self.allocator);
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                const idx = row * self.cols + col;
                retval.data.items[idx] = self.data.items[idx] + other.data.items[idx];
            }
        }
        return retval;
    }

    /// Subtract two matrices and return the resulting matrix
    pub fn sub(self: Matrix, other: Matrix) (MatrixError || Allocator.Error)!Matrix {
        if (self.rows != other.rows and self.cols != other.rows) {
            return MatrixError.DimensionMismatch;
        }
        var retval = try Matrix.init(self.rows, self.cols, self.allocator);
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                const idx = row * self.cols + col;
                retval.data.items[idx] = self.data.items[idx] - other.data.items[idx];
            }
        }
        return retval;
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

test "matrix equal" {
    const allocator = std.heap.page_allocator;

    var m1 = try Matrix.init_square(4, allocator);
    defer m1.deinit();
    var m2 = try Matrix.init_square(4, allocator);
    defer m2.deinit();

    try m1.insert(0, 0, 1.0);
    try m2.insert(0, 0, 1.0);
    try m2.insert(1, 1, 5.0);

    // Check for equality false
    try expect(try m1.is_equal(m2) == false);

    // Check for equality true
    try m1.insert(1, 1, 5.0);
    try expect(try m1.is_equal(m2) == true);

    // Check for dimension mismatch
    var m3 = try Matrix.init_square(3, allocator);
    try expect(m1.is_equal(m3) == MatrixError.DimensionMismatch);

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
    try expect(try res.is_equal(m3) == true);

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
    const m3 = try m1.sub(m2);
    var res = try Matrix.init_square(2, allocator);

    try expect(res.rows == 2);
    try expect(res.cols == 2);
    try expect(try res.is_equal(m3) == true);

    // Check for different matrix dimensions
    m1 = try Matrix.eye(2, allocator);
    m2 = try Matrix.eye(3, allocator);
    try expect(m1.sub(m2) == MatrixError.DimensionMismatch);
}
