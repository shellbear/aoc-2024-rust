const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // You'll need an allocator for dynamic lists
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const file: []const u8 = @embedFile("./day-01.txt");
    var lines = std.mem.split(u8, file, "\n");

    var first_list = std.ArrayList(u32).init(allocator);
    defer first_list.deinit();

    var second_list = std.ArrayList(u32).init(allocator);
    defer second_list.deinit();

    while (lines.next()) |line| {
        var it = std.mem.tokenize(u8, line, " ");

        const first_number = try std.fmt.parseUnsigned(u32, it.next().?, 10);
        const second_number = try std.fmt.parseUnsigned(u32, it.next().?, 10);

        try first_list.append(first_number);
        try second_list.append(second_number);
    }

    std.mem.sort(u32, first_list.items, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, second_list.items, {}, comptime std.sort.asc(u32));

    var result: u32 = 0;
    for (first_list.items, second_list.items) |first, second| {
        result += if (first > second) first - second else second - first;
    }

    print("Result: {}\n", .{result});
}
