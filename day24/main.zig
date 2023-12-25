const part1 = @import("./part1.zig");
const part2 = @import("./part2.zig");

pub fn main() !void {
    try part1.run();
    try part2.run();
}
