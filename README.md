# eigen.zig

Matrix/Tensor/etc. library for Zig.

## Usage
### Creating a Matrix
```zig
var m1 = Matrix.from_array([2][2]f64{
    .{1, 2},
    .{3, 4},
}, allocator);
```

