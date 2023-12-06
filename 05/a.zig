const std = @import("std");

const data = @embedFile("input.txt");

fn readNum(line: []const u8, last_idx_in_out: *usize) !?u64 {
    var start = last_idx_in_out.*;

    while (line.len > start and !std.ascii.isDigit(line[start])) {
        start += 1;
    }

    var end = start;

    while (line.len > end and std.ascii.isDigit(line[end])) {
        end += 1;
    }

    last_idx_in_out.* = end;

    if (start == end) {
        return null;
    }

    return try std.fmt.parseInt(u64, line[start..end], 10);
}

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, data, '\n');

    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();

    const first_line = lines.next().?;

    var map = std.ArrayList(u64).init(allocator.allocator());
    var map_swap = std.ArrayList(u64).init(allocator.allocator());

    var first_line_c_idx: usize = 0;

    while (try readNum(first_line, &first_line_c_idx)) |num| {
        try map.append(num);
    }

    try map_swap.appendSlice(map.items);

    while (lines.next()) |line| {
        var c_idx: usize = 0;
        var dest_range_start: ?u64 = null;
        var src_range_start: ?u64 = null;
        var range_len: ?u64 = null;

        dest_range_start = try readNum(line, &c_idx);
        src_range_start = try readNum(line, &c_idx);
        range_len = try readNum(line, &c_idx);

        if (dest_range_start == null or src_range_start == null or range_len == null) {
            for (map_swap.items, 0..) |item, i| {
                map.items[i] = item;
            }

            continue;
        }

        for (map.items, 0..) |item, i| {
            if (item >= src_range_start.? and item < src_range_start.? + range_len.?) {
                map_swap.items[i] = dest_range_start.? + item - src_range_start.?;
            }
        }
    }

    var min: u64 = std.math.maxInt(u64);

    for (map_swap.items) |item| {
        if (item < min) {
            min = item;
        }
    }

    std.debug.print("{}\n", .{min});
}
