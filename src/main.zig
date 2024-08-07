const std = @import("std");
const ciface = @import("root.zig");
const Chameleon = @import("chameleon");

pub fn main() !void {
    var buffer: [1024]u8 = undefined;
    var alloc = std.heap.FixedBufferAllocator.init(&buffer);
    // var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer alloc.deinit();

    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    var stdout = std.io.getStdOut().writer();

    var chameleon = Chameleon.initRuntime(.{ .allocator = alloc.allocator() });

    try stdout.print("{s};{s};\n", .{
        try chameleon.greenBright().fmt("{s}", .{ciface.getSuccess(rand)}),
        try chameleon.redBright().fmt("{s}", .{ciface.getFail(rand)}),
    });
}
