const std = @import("std");
const testing = std.testing;

const Self = @This();
const Bool = @import("./dhall/bool.zig");

pub fn parse(_: []const u8) Self {
    return Self{};
}

test "Import tests" {
    _ = @import("./dhall/bool.zig");
}
