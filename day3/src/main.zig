const std = @import("std");

pub fn main() !void {
    var path = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer path.close();

    var buf: [50]u8 = undefined;
    var buf_reader = std.io.bufferedReader(path.reader());
    var in_stream = buf_reader.reader();
    var total_matches: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var index: u8 = 0;
        var allocator = std.heap.page_allocator;
        var right = try allocator.alloc(u8, line.len / 2);
        defer allocator.free(right);

        line: while (index < line.len) {
            if (index < (line.len / 2)) {
                right[index] = line[index];
            } else {
                for (right) |item| {
                    if (item == line[index]) {
                        total_matches += calc_prio_value(item);
                        break :line;
                    }
                }
            }

            index += 1;
        }
    }

    std.debug.print("Total matches: {}\n", .{total_matches});
}

pub fn calc_prio_value(ch: u8) u8 {
    std.debug.print("ch: {c}, {d}\n", .{ ch, ch });
    var prio = switch (ch) {
        65...90 => ch - 38,
        97...122 => ch - 96,
        else => 0,
    };
    std.debug.print("prio: {d}\n", .{prio});

    return prio;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
