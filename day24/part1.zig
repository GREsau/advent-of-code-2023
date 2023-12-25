const std = @import("std");
const ArrayList = std.ArrayList;
const sign = std.math.sign;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const Hailstone = struct {
    x0: f128,
    y0: f128,
    z0: f128,
    dx: f128,
    dy: f128,
    dz: f128,
};

pub fn run() !void {
    const hailstones = try read_input();
    defer hailstones.deinit();

    const rangeFrom = 7;
    const rangeTo = 27;

    var result: u32 = 0;

    for (hailstones.items, 0..) |h1, index| {
        for (hailstones.items[(index + 1)..]) |h2| {
            const intersection = find_intersection(h1, h2) orelse continue;
            if (intersection.x >= rangeFrom and intersection.y >= rangeFrom and intersection.x <= rangeTo and intersection.y <= rangeTo) {
                result += 1;
            }
        }
    }

    std.debug.print("Part 1: {d}\n", .{result});
}

fn find_intersection(h1: Hailstone, h2: Hailstone) ?struct { x: f128, y: f128 } {
    if (h1.dy * h2.dx == h1.dx * h2.dy) {
        return null;
    }

    const x = (h1.x0 * h1.dy * h2.dx - h2.x0 * h2.dy * h1.dx + (h2.y0 - h1.y0) * h1.dx * h2.dx) / (h1.dy * h2.dx - h2.dy * h1.dx);
    const y = (x - h1.x0) * h1.dy / h1.dx + h1.y0;

    if (sign(h1.dx) != sign(x - h1.x0) or sign(h1.dy) != sign(y - h1.y0) or sign(h2.dx) != sign(x - h2.x0) or sign(h2.dy) != sign(y - h2.y0)) {
        // in the past
        return null;
    }

    return .{ .x = x, .y = y };
}

fn read_line(reader: *std.fs.File.Reader) !?Hailstone {
    var line = ArrayList(u8).init(allocator);
    defer line.deinit();

    var result: Hailstone = undefined;

    reader.streamUntilDelimiter(line.writer(), '\n', 1000) catch {};
    if (line.items.len == 0) {
        return null;
    }
    var words = std.mem.tokenizeAny(u8, line.items, ", @\r");

    result.x0 = try std.fmt.parseFloat(f128, words.next().?);
    result.y0 = try std.fmt.parseFloat(f128, words.next().?);
    result.z0 = try std.fmt.parseFloat(f128, words.next().?);
    result.dx = try std.fmt.parseFloat(f128, words.next().?);
    result.dy = try std.fmt.parseFloat(f128, words.next().?);
    result.dz = try std.fmt.parseFloat(f128, words.next().?);

    return result;
}

fn read_input() !ArrayList(Hailstone) {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    var reader = file.reader();

    var input = ArrayList(Hailstone).init(allocator);
    errdefer input.deinit();

    while (try read_line(&reader)) |hailstone| {
        try input.append(hailstone);
    }

    return input;
}
