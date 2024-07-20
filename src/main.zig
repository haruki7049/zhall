const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Hello, world!!\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "parse string to dhall" {
    const dhall_str =
        \\{ home       = "/home/bill"
        \\, privateKey = "/home/bill/.ssh/id_ed25519"
        \\, publicKey  = "/home/blil/.ssh/id_ed25519.pub"
        \\}
    ;
    try std.testing.expectEqual(Dhall.parse(dhall_str).original_string, dhall_str);
}

const Dhall = struct {
    original_string: []const u8,

    pub fn parse(original_string: []const u8) Dhall {
        return Dhall{ .original_string = original_string };
    }
};
