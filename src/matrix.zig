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
    allocator: Allocator,
    // TODO: Add T (transpose) and I (inverse) of matrix as attributes
    // T: Matrix,
    // I: Matrix,

    pub fn from_array(xs: anytype, allocator: Allocator) (MatrixError || Allocator.Error)!Matrix {
        const rows = xs.len;
        const cols = xs[0].len;
        var retval = try Matrix.init(rows, cols, allocator);
        for (xs, 0..) |row, i| {
            for (row, 0..) |item, j| {
                try retval.insert(i, j, item);
            }
        }
        return retval;
    }

    pub fn from_string(str: []const u8) MatrixError!Matrix {
        _ = str;
        // TODO: Create matrix from a string
        // Example:
        // Matrix.from_string("1 2; 3 4")
        // Matrix.from_string("1 2;3 4")
        // Matrix.from_string("1.2 2.23; 3 4.0")
    }

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
        if (self.cols != other.cols or self.rows != other.rows) {
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

    pub fn max(self: Matrix) f64 {
        var cur_max = self.data.items[0];
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                const value = self.data.items[row * self.cols + col];
                if (value > cur_max) {
                    cur_max = value;
                }
            }
        }
        return cur_max;
    }

    pub fn max_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: Maximum value of matrix on given axis
    }

    pub fn min(self: Matrix) f64 {
        var cur_min = self.data.items[0];
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                const value = self.data.items[row * self.cols + col];
                if (value < cur_min) {
                    cur_min = value;
                }
            }
        }
        return cur_min;
    }

    pub fn min_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: Minimum value of matrix on given axis
    }

    pub fn mean(self: Matrix) f64 {
        var retval: f64 = 0.0;
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                retval += self.data.items[row * self.cols + col];
            }
        }
        return retval / @as(f64, @floatFromInt(self.rows * self.cols));
    }

    pub fn mean_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: mean of matrix on given axis
    }

    pub fn sum(self: Matrix) f64 {
        var retval: f64 = 0;
        for (0..self.rows) |row| {
            for (0..self.cols) |col| {
                retval += self.data.items[row * self.cols + col];
            }
        }
        return retval;
    }

    pub fn sum_axis(self: Matrix, axis: usize) MatrixError!f64 {
        _ = axis;
        _ = self;
        // TODO: sum of values in matrix on given axis
    }

    /// Multiply two matrices and return the output matrix
    pub fn mul(self: Matrix, other: Matrix) MatrixError!Matrix {
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

// TODO: deinitialization
fn create_array(n: usize, allocator: Allocator) Allocator.Error![][]f64 {
    var retval = try allocator.alloc([]f64, n);
    for (0..retval.len) |row| {
        retval[row] = try allocator.alloc(f64, n);
    }
    for (0..retval.len) |row| {
        for (0..retval[row].len) |col| {
            retval[row][col] = 0;
        }
    }
    return retval;
}

fn print_array(xs: [][]f64) void {
    for (0..xs.len) |row| {
        std.debug.print("|", .{});
        for (0..xs[row].len) |col| {
            std.debug.print(" {}", .{xs[row][col]});
        }
        std.debug.print("|\n", .{});
    }
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

test "matrix from array" {
    const allocator = std.heap.page_allocator;

    // Default matrix
    var mat2x2 = [2][2]f64{
        .{ 1, 2 },
        .{ 3, 4 },
    };
    var m1 = try Matrix.from_array(mat2x2, allocator);
    var res = try Matrix.init_square(2, allocator);
    try res.insert(0, 0, 1);
    try res.insert(0, 1, 2);
    try res.insert(1, 0, 3);
    try res.insert(1, 1, 4);

    try expect(try m1.is_equal(res) == true);

    // Identity Matrix
    var mat4x4 = [4][4]f64{
        .{ 1, 0, 0, 0 },
        .{ 0, 1, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ 0, 0, 0, 1 },
    };
    var m2 = try Matrix.from_array(mat4x4, allocator);
    res = try Matrix.eye(4, allocator);
    try expect(try m2.is_equal(res) == true);

    // Vector
    var mat3x1 = [3][1]f64{
        .{1},
        .{2},
        .{3},
    };
    var m3 = try Matrix.from_array(mat3x1, allocator);
    res = try Matrix.init(3, 1, allocator);
    try res.insert(0, 0, 1);
    try res.insert(1, 0, 2);
    try res.insert(2, 0, 3);
    try expect(try m3.is_equal(res) == true);

    // Zero initialized array
    var m_zero = [3][3]f64{
        .{ 0, 0, 0 },
        .{ 0, 0, 0 },
        .{ 0, 0, 0 },
    };
    var m4 = try Matrix.from_array(m_zero, allocator);
    res = try Matrix.init_square(3, allocator);
    try expect(try m4.is_equal(res) == true);

    // Slices
    var dyn_size: usize = 10;
    var m_variable = try create_array(dyn_size, allocator);
    defer allocator.free(m_variable);
    // print_array(m_variable);
    var m5 = try Matrix.from_array(m_variable, allocator);
    res = try Matrix.init_square(10, allocator);
    try expect(try m5.is_equal(res) == true);
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

test "matrix max" {
    const allocator = std.heap.page_allocator;
    var m1 = try Matrix.init_square(4, allocator);
    try m1.insert(0, 0, -2);
    try m1.insert(0, 1, 5);
    try m1.insert(0, 2, 9);
    try m1.insert(3, 2, 3);
    try expect(m1.max() == 9.0);

    var m2 = try Matrix.init_square(4, allocator);
    try m2.insert(0, 0, -2);
    try m2.insert(0, 1, 5);
    try m2.insert(0, 2, 9);
    try m2.insert(3, 2, 3);
    try m2.insert(3, 3, 11);
    try expect(m2.max() == 11.0);

    var m3 = try Matrix.init_square(4, allocator);
    try expect(m3.max() == 0.0);
}

test "matrix min" {
    const allocator = std.heap.page_allocator;
    var m1 = try Matrix.init_square(4, allocator);
    try m1.insert(0, 0, -2);
    try m1.insert(0, 1, 5);
    try m1.insert(0, 2, 9);
    try m1.insert(3, 2, 3);
    try expect(m1.min() == -2.0);

    var m2 = try Matrix.init_square(4, allocator);
    try m2.insert(0, 0, -10);
    try m2.insert(0, 1, -5);
    try m2.insert(0, 2, -11);
    try m2.insert(3, 2, -3);
    try m2.insert(3, 3, -1);
    try expect(m2.min() == -11.0);

    var m3 = try Matrix.init_square(4, allocator);
    try expect(m3.min() == 0.0);
}

test "matrix mean" {
    const allocator = std.heap.page_allocator;
    var m1 = try Matrix.init_square(2, allocator);
    try m1.insert(0, 0, 1);
    try m1.insert(0, 1, 2);
    try m1.insert(1, 0, 3);
    try m1.insert(1, 1, 4);
    try expect(m1.mean() == 2.5);
}

test "matrix sum" {
    const allocator = std.heap.page_allocator;
    var m1 = try Matrix.init_square(2, allocator);
    try m1.insert(0, 0, 1);
    try m1.insert(0, 1, 2);
    try m1.insert(1, 0, 3);
    try m1.insert(1, 1, 4);
    try expect(m1.sum() == 10.0);
}
