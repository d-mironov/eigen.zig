/// Author: Daniel Mironov
const std = @import("std");
const expect = std.testing.expect;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const Array = struct {
    shape: []u32,
    data: ArrayList(f64),
    allocator: Allocator,

    pub fn from_array(xs: anytype, allocator: Allocator) !Array {
        _ = allocator;
        _ = xs;
    }

    pub fn from_string(str: []const u8) !Array {
        _ = str;
    }
};
