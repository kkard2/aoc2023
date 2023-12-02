const std = @import("std");

const Colors = struct {
    r: u32,
    g: u32,
    b: u32,
};

const Game = struct {
    index: u32,
    list: std.ArrayList(Colors),
};

const data = @embedFile("input.txt");

pub fn main() !void {
    var lines = std.mem.tokenize(u8, data, "\n");
    //var arena = std.heap.ArenaAllocator.init(std.mem.Allocator);
    //defer arena.deinit();
    //var games = std.ArrayList(Game).init(arena);

    while (lines.next()) |line| {
        var i: u32 = 0;

        while (!std.ascii.isDigit(line[i])) {
            i += 1;
        }

        var j = i;

        while (std.ascii.isDigit(line[j])) {
            j += 1;
        }

        std.debug.print("{},{}\n", .{ i, j });
        var game_index = try std.fmt.parseInt(u32, line[i .. j - 1], 10);
        std.debug.print("{}\n", .{game_index});
    }
}
