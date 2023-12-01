const std = @import("std");

const Pair = struct {
    name: []const u8,
    value: u8,
};

fn makePair(name: []const u8, value: u8) Pair {
    return Pair{
        .name = name,
        .value = value,
    };
}

const lookup = [_]Pair{
    makePair("one", 1),
    makePair("two", 2),
    makePair("three", 3),
    makePair("four", 4),
    makePair("five", 5),
    makePair("six", 6),
    makePair("seven", 7),
    makePair("eight", 8),
    makePair("nine", 9),
};

const data = @embedFile("input.txt");

pub fn main() !void {
    var lines = std.mem.tokenize(u8, data, "\n");
    var sum: u64 = 0;

    while (lines.next()) |line| {
        var first_digit: ?u8 = null;
        var last_digit: ?u8 = null;

        for (line, 0..) |value, index| {
            var current_digit: ?u8 = null;
            if (std.ascii.isDigit(value)) {
                current_digit = value - '0';
            } else {
                // i know this is slow and can be faster
                // (also indentation hell)
                for (lookup) |pair| {
                    var success = true;

                    for (pair.name, 0..) |pair_char, pair_index| {
                        if (index + pair_index > line.len) {
                            success = false;
                            break;
                        }
                        if (line[index + pair_index] != pair_char) {
                            success = false;
                            break;
                        }
                    }

                    if (success) {
                        current_digit = pair.value;
                        break;
                    }
                }
            }

            if (current_digit != null) {
                if (first_digit == null) {
                    first_digit = current_digit;
                }

                last_digit = current_digit;
            }
        }

        sum += first_digit.? * 10 + last_digit.?;
    }

    std.debug.print("\n{}\n", .{sum});
}
