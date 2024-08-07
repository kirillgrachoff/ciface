const testing = @import("std").testing;

pub const success = [_][]const u8{
    "(⌐■‿■)",
    "(c-‿◦)",
    "◝(^⌣^)◜",
    "ಠ◡ಠ",
};

pub const fail = [_][]const u8{
    "( ノ・・)ノ︵ ┻━┻",
    "(╯’□’)╯︵ ┻━┻",
    "(ಥ﹏ಥ)",
    "(つ﹏⊂)",
    "(༎ຶ⌑༎ຶ)",
    "(ಠ_ಠ)",
};

fn check(data: anytype) !void {
    try testing.expect(data.len > 0);
    inline for (data) |face| {
        try testing.expect(@hasField(@TypeOf(face), "len"));
    }
}

test "size and index" {
    try check(success);
    try check(fail);
}
