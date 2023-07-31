const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello, world!\n", .{});

    var path = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer path.close();

    var buf: [4]u8 = undefined;
    var buf_reader = std.io.bufferedReader(path.reader());
    var in_stream = buf_reader.reader();
    var total: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{d}\n", .{line[0]});
        std.debug.print("{d}\n", .{line[2]});
        std.debug.print("{c}\n", .{line[1]});
        std.debug.print("{c}\n", .{line});
        var score = calc_score(line[0], line[2]);
        std.debug.print("{d}\n", .{score});
        total += score;
    }
    std.debug.print("total: {d}\n", .{total});
}

fn calc_score(opp: u8, you: u8) u8 {
    var action: u8 = you - 87;
    var score: u8 = switch (action) {
        1 => scr: {
            break :scr switch (opp - 64) {
                1 => 3,
                2 => 1,
                else => 2,
            };
        },
        2 => (opp - 64) + 3,
        3 => scr: {
            break :scr switch (opp - 64) {
                1 => 2 + 6,
                2 => 3 + 6,
                else => 1 + 6,
            };
        },
        else => 0,
    };

    return score;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
