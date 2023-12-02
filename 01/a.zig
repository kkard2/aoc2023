const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("01/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream: std.io.Reader = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var sum: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var first_digit: ?u8 = null;
        var last_digit: ?u8 = null;

        for (line) |value| {
            if (std.ascii.isDigit(value)) {
                last_digit = value - '0';

                if (first_digit == null) {
                    first_digit = value - '0';
                }
            }
        }

        sum += first_digit.? * 10 + last_digit.?;
    }

    std.debug.print("\n{}\n", .{sum});
}
