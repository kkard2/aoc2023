const std = @import("std");

const data = @embedFile("input.txt");

fn readFirstNumber(line: []const u8, end_index: *usize) !?u32 {
    var i: usize = end_index.*;

    while (line.len > i and !std.ascii.isDigit(line[i])) {
        i += 1;
    }

    if (line.len <= i) {
        end_index.* = i;
        return null;
    }

    var j = i;

    while (std.ascii.isDigit(line[j])) {
        j += 1;
    }

    end_index.* = j;

    return try std.fmt.parseInt(u32, line[i..j], 10);
}

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, data, '\n');
    var sum: u32 = 0;

    while (lines.next()) |line| {
        var pos: usize = 0;
        const game_index = (try readFirstNumber(line, &pos)).?;

        var success = true;

        while (line.len > pos) {
            var r: u32 = 0;
            var g: u32 = 0;
            var b: u32 = 0;

            while (line.len > pos and line[pos] != ';') {
                const num = try readFirstNumber(line, &pos) orelse break;

                pos += 1;
                const color_letter = line[pos];

                if (color_letter == 'r') {
                    r = @max(num, r);
                } else if (color_letter == 'g') {
                    g = @max(num, g);
                } else if (color_letter == 'b') {
                    b = @max(num, b);
                }
            }

            if (r > 12 or g > 13 or b > 14) {
                success = false;
                break;
            }
        }

        if (success) {
            sum += game_index;
        }
    }

    std.debug.print("{}\n", .{sum});
}
