const std = @import("std");
const testing = std.testing;
pub const faces = @import("faces.zig");

pub fn getSuccess(r: std.Random) []const u8 {
    return getOneOf(r, &faces.success);
}

pub fn getFail(r: std.Random) []const u8 {
    return getOneOf(r, &faces.fail);
}

fn getOneOf(r: std.Random, alternatives: []const []const u8) []const u8 {
    const len = alternatives.len;
    const index = std.rand.uintLessThan(r, usize, len);
    return alternatives[index];
}

test "works" {
    var prng = std.rand.DefaultPrng.init(0);
    const r = prng.random();
    const a = getSuccess(r);
    var ok = false;
    inline for (faces.success) |face| {
        ok = ok or std.mem.eql(u8, face, a);
    }
    try testing.expect(ok);
}
