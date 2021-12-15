const std = @import("std");
const print = @import("std").debug.print;
const PriorityQueue = std.PriorityQueue;
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

const Point = struct {
    x: i32,
    y: i32,
    distance: u64,
};

fn min_compare(a: Point, b: Point) std.math.Order {
    return std.math.order(a.distance, b.distance);
}

pub fn solve(list: ArrayList(ArrayList(u8)), visited: ArrayList(ArrayList(bool))) !u64 {
    var cols = list.items[0].items.len;
    var rows = list.items.len;

    // Ugly Dijkstra's
    var distances = ArrayList(ArrayList(u64)).init(test_allocator);
    {
        var r: usize = 0;
        while (r < rows) : (r += 1) {
            var c: usize = 0;
            var distance_row = ArrayList(u64).init(test_allocator);
            while (c < cols) : (c += 1) {
                try distance_row.append(999999);
            }
            try distances.append(distance_row);
        }
    }
    distances.items[0].items[0] = 0;

    var pq = PriorityQueue(Point).init(test_allocator, min_compare);
    defer pq.deinit();

    try pq.add(Point{ .x = 0, .y = 0, .distance = 0 });

    while (pq.count() != 0) {
        const curr = pq.remove();
        var crow = @intCast(usize, curr.y);
        var ccol = @intCast(usize, curr.x);
        visited.items[crow].items[ccol] = true;

        var to_check = std.ArrayList(Point).init(test_allocator);
        try to_check.append(Point{ .x = curr.x - 1, .y = curr.y, .distance = 999999 });
        try to_check.append(Point{ .x = curr.x + 1, .y = curr.y, .distance = 999999 });
        try to_check.append(Point{ .x = curr.x, .y = curr.y - 1, .distance = 999999 });
        try to_check.append(Point{ .x = curr.x, .y = curr.y + 1, .distance = 999999 });

        for (to_check.items) |point| {
            var signed_nrow = point.y;
            var signed_ncol = point.x;
            if (signed_nrow >= 0 and signed_ncol >= 0 and signed_nrow < rows and signed_ncol < cols) {
                var nrow = @intCast(usize, signed_nrow);
                var ncol = @intCast(usize, signed_ncol);
                var point_distance = distances.items[nrow].items[ncol];

                if (!visited.items[nrow].items[ncol]) {
                    var new_distance: u64 = distances.items[crow].items[ccol] + list.items[ncol].items[nrow];
                    if (new_distance < point_distance) {
                        try pq.add(Point{ .x = @intCast(i32, ncol), .y = @intCast(i32, nrow), .distance = new_distance });
                        distances.items[nrow].items[ncol] = new_distance;
                    }
                }
            }
        }
    }

    return distances.items[rows - 1].items[cols - 1];
}

pub fn part_one(f: []const u8) !void {
    var file = try std.fs.cwd().openFile(f, .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [100]u8 = undefined;

    var list = ArrayList(ArrayList(u8)).init(test_allocator);
    var visited = ArrayList(ArrayList(bool)).init(test_allocator);

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var l = line.len;
        var i: u32 = 0;
        var row = ArrayList(u8).init(test_allocator);
        var visited_row = ArrayList(bool).init(test_allocator);

        while (i < l) : (i += 1) {
            var ch: []u8 = line[i..(i + 1)];
            var value = try std.fmt.parseUnsigned(u8, ch, 10);
            try row.append(value);
            try visited_row.append(false);
        }
        try list.append(row);
        try visited.append(visited_row);
    }

    print("Part 1 - Risk: {d}\n", .{solve(list, visited)});
}

pub fn part_two(f: []const u8) !void {
    var list = ArrayList(ArrayList(u8)).init(test_allocator);
    var visited = ArrayList(ArrayList(bool)).init(test_allocator);

    var k: u8 = 0;
    while (k < 5) : (k += 1) {
        var file = try std.fs.cwd().openFile(f, .{});
        var buf_reader = std.io.bufferedReader(file.reader());
        var in_stream = buf_reader.reader();
        var buf: [100]u8 = undefined;
        while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            var l = line.len;
            var j: u8 = 0;
            var row = ArrayList(u8).init(test_allocator);
            var visited_row = ArrayList(bool).init(test_allocator);

            while (j < 5) : (j += 1) {
                var i: u32 = 0;
                while (i < l) : (i += 1) {
                    var ch: []u8 = line[i..(i + 1)];
                    var value = (try std.fmt.parseUnsigned(u8, ch, 10)) + j + k;
                    if (value >= 10) {
                        try row.append(value - 10 + 1);
                    } else {
                        try row.append(value);
                    }
                    try visited_row.append(false);
                }
            }
            try list.append(row);
            try visited.append(visited_row);
        }
        file.close();
    }

    print("Part 2 - Risk: {d}\n", .{solve(list, visited)});
}

pub fn main() !void {
    const f = "input.txt";
    part_one(f) catch |err| {};
    part_two(f) catch |err| {};
}
