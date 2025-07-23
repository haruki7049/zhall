const std = @import("std");
const testing = std.testing;

const Self = @This();

value: bool,

pub fn new(value: bool) Self {
    return Self{ .value = value };
}

pub fn parse(text: []const u8) Self.ParseError!Self {
    if (std.mem.eql(u8, text, "True")) {
        return Self.new(true);
    } else if (std.mem.eql(u8, text, "False")) {
        return Self.new(false);
    }

    return error.NotBool;
}

const ParseError = error{
    NotBool,
};

test "Bool type" {
    const True = Self.new(true);
    const False = Self.new(false);

    try testing.expect(True.value == true);
    try testing.expect(False.value == false);
}

test "Bool parse" {
    const ParsedTrue = try Self.parse("True");
    const ParsedFalse = try Self.parse("False");
    const ParsedNotBool = Self.parse("FooFoo");

    try testing.expect(ParsedTrue.value == true);
    try testing.expect(ParsedFalse.value == false);
    try testing.expect(ParsedNotBool == ParseError.NotBool);
}
