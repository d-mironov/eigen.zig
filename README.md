# eigen.zig

Matrix/Tensor/etc. library for Zig.

## Usage
### Creating a Matrix
```zig
// Creating a 0 initialized 2x3 matrix
var zero = Matrix.init(2, 3, allocator);
// Creating a Matrix from an array
var m1 = Matrix.from_array([2][2]f64{
    .{1, 2},
    .{3, 4},
}, allocator);
```

