const std = @import("std");
const ArrayList = std.ArrayList;
const assert = std.debug.assert;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const N = f64;

const Vec3 = struct {
    x: N,
    y: N,
    z: N,

    const ZERO: Vec3 = Vec3.init(0, 0, 0);

    pub fn init(x: N, y: N, z: N) Vec3 {
        return .{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        const x = self.x + other.x;
        const y = self.y + other.y;
        const z = self.z + other.z;
        return Vec3.init(x, y, z);
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        const x = self.x - other.x;
        const y = self.y - other.y;
        const z = self.z - other.z;
        return Vec3.init(x, y, z);
    }

    pub fn dot(self: Vec3, other: Vec3) N {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        const x = self.y * other.z - self.z * other.y;
        const y = self.z * other.x - self.x * other.z;
        const z = self.x * other.y - self.y * other.x;
        return Vec3.init(x, y, z);
    }

    pub fn mul(self: Vec3, n: N) Vec3 {
        const x = self.x * n;
        const y = self.y * n;
        const z = self.z * n;
        return Vec3.init(x, y, z);
    }

    pub fn div(self: Vec3, n: N) Vec3 {
        const x = self.x / n;
        const y = self.y / n;
        const z = self.z / n;
        return Vec3.init(x, y, z);
    }
};

const Particle = struct {
    p0: Vec3,
    velocity: Vec3,

    pub fn position_at(self: Particle, t: N) Vec3 {
        return self.p0.add(self.velocity.mul(t));
    }
};

const Plane = struct {
    point: Vec3,
    normal: Vec3,
};

pub fn run() !void {
    const hailstones = try read_input();
    defer hailstones.deinit();

    const h0 = hailstones.items[0];
    const h1 = hailstones.items[1];
    const h2 = hailstones.items[2];
    const h3 = hailstones.items[3];

    const v0 = h0.velocity;

    const plane = find_plane(normalize_velocity(h0, v0), normalize_velocity(h1, v0));

    const t2 = intersection_time(normalize_velocity(h2, v0), plane);
    const t3 = intersection_time(normalize_velocity(h3, v0), plane);

    const p2 = h2.position_at(t2);
    const p3 = h3.position_at(t3);

    const velocity = p2.sub(p3).div(t2 - t3);
    const pos = p2.sub(velocity.mul(t2));

    const result = std.math.round(pos.x + pos.y + pos.z);

    std.debug.print("Part 2: {d}\n", .{result});
}

fn intersection_time(line: Particle, plane: Plane) N {
    // Thank you Wikipedia! https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection#Algebraic_form
    return plane.point.sub(line.p0).dot(plane.normal) / line.velocity.dot(plane.normal);
}

fn find_plane(h0: Particle, h1: Particle) Plane {
    assert(std.meta.eql(h0.velocity, Vec3.ZERO));
    return Plane{
        .point = h0.p0,
        .normal = h1.velocity.cross(h1.p0.sub(h0.p0)),
    };
}

fn normalize_velocity(hailstone: Particle, v0: Vec3) Particle {
    return .{ .p0 = hailstone.p0, .velocity = hailstone.velocity.sub(v0) };
}

fn read_line(reader: *std.fs.File.Reader) !?Particle {
    var line = ArrayList(u8).init(allocator);
    defer line.deinit();

    reader.streamUntilDelimiter(line.writer(), '\n', 1000) catch {};
    if (line.items.len == 0) {
        return null;
    }
    var words = std.mem.tokenizeAny(u8, line.items, ", @\r");

    const x0 = try std.fmt.parseFloat(N, words.next().?);
    const y0 = try std.fmt.parseFloat(N, words.next().?);
    const z0 = try std.fmt.parseFloat(N, words.next().?);
    const dx = try std.fmt.parseFloat(N, words.next().?);
    const dy = try std.fmt.parseFloat(N, words.next().?);
    const dz = try std.fmt.parseFloat(N, words.next().?);

    return Particle{
        .p0 = Vec3.init(x0, y0, z0),
        .velocity = Vec3.init(dx, dy, dz),
    };
}

fn read_input() !ArrayList(Particle) {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    var reader = file.reader();

    var input = ArrayList(Particle).init(allocator);
    errdefer input.deinit();

    while (try read_line(&reader)) |hailstone| {
        try input.append(hailstone);
    }

    return input;
}
