const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello, world!\n", .{});

    var path = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer path.close();

    var buf: [4]u8 = undefined;
    var buf_reader = std.io.bufferedReader(path.reader());
    var in_stream = buf_reader.reader();

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{d}\n", .{line[0]});
        std.debug.print("{d}\n", .{line[2]});
        std.debug.print("{c}\n", .{line[1]});
    }
}

fn calc_score(opp: u8, you: u8) u8 {
    var score: u8 = you - 87;
    if (opp - 64 == score) {
        score += 3;
    }

    return score;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
