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
        for (center, 0..) |c, index| {
            if (c != '*') {
                continue;
            }

            const i: usize =
                @intCast(@max(0, @as(isize, @intCast(index)) - 1));
            const j = @min(center.len - 1, index + 2);

            var first_num: ?u32 = null;
            var second_num: ?u32 = null;

            for (around) |single_around| {
                if (single_around) |single_around_nn| {
                    var skip: ?usize = null;

                    for (i..j) |char_index| {
                        if (skip) |skip_nn| {
                            if (char_index <= skip_nn) {
                                continue;
                            }
                        }

                        if (std.ascii.isDigit(single_around_nn[char_index])) {
                            var ci: isize = @intCast(char_index);

                            while (ci >= 0 and std.ascii.isDigit(single_around_nn[@intCast(ci)])) {
                                ci -= 1;
                            }

                            ci += 1;
                            var ci_usize: usize = @intCast(ci);
                            var start: usize = undefined;

                            const num = try readFirstNumber(single_around_nn, &start, &ci_usize);
                            skip = ci_usize;

                            if (first_num != null) {
                                second_num = num;
                                break;
                            } else {
                                first_num = num;
                            }
                        }

                        if (first_num != null and second_num != null) {
                            break;
                        }
                    }
                }
            }

            if (first_num != null and second_num != null) {
                sum.* += first_num.? * second_num.?;
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
