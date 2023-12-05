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
    const allocator = std.heap.page_allocator;
    var card_count = std.ArrayList(u32).init(allocator);
    defer card_count.deinit();
    var line_index: usize = 0;

    while (lines.next()) |line| {
        var colon = false;
        var pipe = false;

        var num_start: ?usize = null;

        var winning_list = std.ArrayList(u8).init(allocator);
        defer winning_list.deinit();
        var winning_count: usize = 0;

        for (line, 0..) |c, idx| {
            if (!colon) {
                if (c == ':') {
                    colon = true;
                }
                continue;
            }

            if (c == ' ') {
                if (num_start) |num_start_nn| {
                    const num = try std.fmt.parseInt(
                        u8,
                        line[num_start_nn..idx],
                        10,
                    );
                    num_start = null;

                    if (!pipe) {
                        try winning_list.append(num);
                    } else {
                        for (winning_list.items) |winning| {
                            if (num == winning) {
                                winning_count += 1;
                                break;
                            }
                        }
                    }
                }
                continue;
            }

            if (c == '|') {
                pipe = true;
                continue;
            }

            if (std.ascii.isDigit(c) and num_start == null) {
                num_start = idx;
            }
        }

        if (num_start) |num_start_nn| {
            const num = try std.fmt.parseInt(
                u8,
                line[num_start_nn .. line.len - 1],
                10,
            );

            for (winning_list.items) |winning| {
                if (num == winning) {
                    winning_count += 1;
                    break;
                }
            }
        }

        if (winning_count > 0) {
            if (card_count.items.len < line_index + 1 + winning_count) {
                const to_append = line_index + winning_count - card_count.items.len;
                try card_count.appendNTimes(1, to_append + 1);
            }

            for (line_index + 1..line_index + 1 + winning_count) |win_idx| {
                card_count.items[win_idx] += card_count.items[line_index];
            }
        }

        line_index += 1;
    }

    var sum: u32 = 0;

    for (card_count.items, 0..) |card, index| {
        if (index < line_index) {
            sum += card;
        }
    }

    std.debug.print("{}\n", .{sum});
}
