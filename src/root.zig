const std = @import("std");
const testing = std.testing;

pub const Dhall = struct {
    const Self = @This();

    pub fn parse(_: []const u8) Dhall {
        return Self{};
    }

    const Bool = @import("bool.zig");
};

test "Run tests in zhall" {
    _ = Dhall.Bool;
}
