const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const path = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer path.close();

    var buf_reader = std.io.bufferedReader(path.reader());
    var in_stream = buf_reader.reader();

    // Write the contents of the file todo
    var buf: [1024]u8 = undefined;
    var max: [3]u64 = .{ 0, 0, 0 };
    var working: u64 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            var walker: u64 = working;
            for (max, 0..) |val, i| {
                if (walker >= val) {
                    var tmp = val;
                    max[i] = walker;
                    walker = tmp;
                }
            }

            working = 0;
        } else {
            var line_val: u64 = try std.fmt.parseUnsigned(u64, line, 10);
            working += line_val;
        }
    }

    std.debug.print("Max: {d}\n", .{max[0]});
    var sum: u64 = max[0] + max[1] + max[2];
    std.debug.print("Total: {d}", .{sum});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
