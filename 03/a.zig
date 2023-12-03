const std = @import("std");

const data = @embedFile("input.txt");

fn readFirstNumber(
    line: []const u8,
    start_index: *usize,
    end_index_exclusive: *usize,
) !?u32 {
    var i = end_index_exclusive.*;

    while (line.len > i and !std.ascii.isDigit(line[i])) {
        i += 1;
    }

    if (line.len <= i) {
        end_index_exclusive.* = i;
        return null;
    }

    var j = i;

    while (line.len > i and std.ascii.isDigit(line[j])) {
        j += 1;
    }

    start_index.* = i;
    end_index_exclusive.* = j;

    return try std.fmt.parseInt(u32, line[i..j], 10);
}

fn handleAround(around: [3]?[]const u8, sum: *u32) !void {
    if (around[1]) |center| {
        var i: usize = 0;
        var j: usize = 0;

        while (try readFirstNumber(center, &i, &j)) |num| {
            const lower_bound: usize =
                @intCast(@max(0, @as(isize, @intCast(i)) - 1));
            const upper_bound = @min(center.len - 1, j + 1);

            var success = false;

            for (around) |single_arround| {
                if (single_arround) |single_arround_not_null| {
                    for (lower_bound..upper_bound) |index| {
                        const c = single_arround_not_null[index];
                        if (!std.ascii.isDigit(c) and c != '.') {
                            success = true;
                            break;
                        }
                    }
                }

                if (success) {
                    break;
                }
            }

            if (success) {
                sum.* += num;
            }
        }
    }
}

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, data, '\n');
    var sum: u32 = 0;

    var around: [3]?[]const u8 = .{ null, null, null };

    while (lines.next()) |line| {
        around[0] = around[1];
        around[1] = around[2];
        around[2] = line;

        try handleAround(around, &sum);
    }

    around[0] = around[1];
    around[1] = around[2];
    around[2] = null;

    try handleAround(around, &sum);

    std.debug.print("{}\n", .{sum});
}
