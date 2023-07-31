const std = @import("std");

pub fn main() !void {
    var path = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer path.close();

    var buf: [50]u8 = undefined;
    var buf_reader = std.io.bufferedReader(path.reader());
    var in_stream = buf_reader.reader();

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var half = line.len / 2;
        std.debug.print("{d}\n", .{line.len});
        std.debug.print("{d}\n", .{half});
        var left: []u8 = line[0..half];
        var right: []u8 = sort(line[half..]);

        std.debug.print("{s}\n", .{line});
        std.debug.print("{s}\n", .{left});
        std.debug.print("{s}", .{right});

        std.debug.print("\n", .{});
    }
}

pub fn sort(arr: []u8) []u8 {
    var prev: u8 = 0;
    var i: u8 = 0;

    while (i < arr.len) {
        // 65 - 90? - needs (- 64)
        // 97 - 122 - needs (- 96)
        var workingPrev: u8 = toStandardChar(arr[prev]);
        var workingI: u8 = toStandardChar(arr[i]);

        if (workingPrev > workingI) {
            var holding = arr[i];
            arr[i] = arr[prev];
            arr[prev] = holding;
            prev = i;
        }

        i += 1;
    }

    return arr;
}

pub fn toStandardChar(ch: u8) u8 {
    return switch (ch) {
        65...90 => ch - 64,
        97...122 => ch - 96,
        else => ch,
    };
}

// struct Vec {
//
// }

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
