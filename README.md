# eigen.zig

Matrix/Tensor/etc. library for Zig.

## Usage
### Creating a Matrix
```zig
// Creating a 0 initialized 2x3 matrix
var zero = try Matrix.init(2, 3, allocator);

// Or if you want a 3x3 square matrix
var zero_square = try Matrix.init_square(3, allocator);

// Creating a Matrix from an array
var m1 = try Matrix.from_array([2][2]f64{
    .{1, 2},
    .{3, 4},
}, allocator);
```

