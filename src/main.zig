const std = @import("std");
const ciface = @import("ciface");
const Chameleon = @import("chameleon");
const clap = @import("clap");

pub fn main() !void {
    var buffer: [1024]u8 = undefined;
    var fixedBufAlloc = std.heap.FixedBufferAllocator.init(&buffer);
    const alloc = fixedBufAlloc.allocator();

    const params = comptime clap.parseParamsComptime(
        \\-h, --help                 Display this help and exit.
        \\--seed <x64>               Random seed (hex).
        \\<TYPE> (default: success)  Face type (s/f/success/fail).
    );

    const FaceType = enum { s, success, f, fail };
    const parsers = comptime .{
        .TYPE = clap.parsers.enumeration(FaceType),
        .x64 = clap.parsers.int(u64, 16),
    };

    var diag = clap.Diagnostic{};
    const res = try clap.parse(clap.Help, &params, parsers, .{
        .allocator = alloc,
        .diagnostic = &diag,
    });
    defer res.deinit();

    if (res.args.help != 0) {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &params, .{});
    }

    var prng = std.rand.DefaultPrng.init(blk: {
        if (res.args.seed) |seed| {
            break :blk seed;
        }
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    var stdout = std.io.getStdOut().writer();

    var chameleon = Chameleon.initRuntime(.{ .allocator = alloc });

    try stdout.print("{s}\n", .{switch (res.positionals[0]) {
        .s, .success => try chameleon.greenBright().fmt("{s}", .{ciface.getSuccess(rand)}),
        .f, .fail => try chameleon.redBright().fmt("{s}", .{ciface.getFail(rand)}),
    }});
}
