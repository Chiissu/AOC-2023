const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    const file_buffer = try in_stream.readAllAlloc(allocator, 10000);
    defer allocator.free(file_buffer);

    // Disect the file

    const SeedRange = struct { start: u32, end: u32, processed: bool };

    var isParsingSeed = true;
    var seedList = std.ArrayList(SeedRange).init(std.heap.page_allocator);

    var sectionItr = std.mem.split(u8, file_buffer, "\n\n");
    while (sectionItr.next()) |section| {
        var lineItr = std.mem.split(u8, section, "\n");
        while (lineItr.next()) |s2| {
            var spaceItr = std.mem.split(u8, s2, " ");
            while (spaceItr.next()) |s3| {
                if (std.mem.eql(u8, s3, "map:") or std.mem.eql(u8, s3, "") or std.mem.eql(u8, s3, "seeds:")) continue;

                const num = std.fmt.parseUnsigned(u32, s3, 10) catch {
                    std.debug.print("\n>>> Next section <<<\n", .{});
                    for (seedList.items, 0..) |seed, index| {
                        _ = seed;
                        seedList.items[index].processed = false;
                    }
                    isParsingSeed = false;
                    continue;
                };

                if (isParsingSeed) {
                    const len = try std.fmt.parseUnsigned(u32, spaceItr.next().?, 10);
                    try seedList.append(SeedRange{ .start = num, .end = num + len, .processed = false });
                    continue;
                }

                const dest: u64 = num;
                const src = try std.fmt.parseUnsigned(u64, spaceItr.next().?, 10);
                const rng = try std.fmt.parseUnsigned(u32, spaceItr.next().?, 10);

                std.debug.print("Mapping: {d} {d} {d}\n", .{ dest, src, rng });
                for (seedList.items, 0..) |seedGroup, i| {
                    const outOfBound = seedGroup.end < src or src + rng < seedGroup.start;
                    if (seedGroup.processed or outOfBound) continue;

                    const items = seedList.items;
                    const isEndExtruding = src + rng < seedGroup.end;
                    const end: u32 = @truncate(dest + if (isEndExtruding) rng else (seedGroup.end - src));

                    if (isEndExtruding)
                        try seedList.append(SeedRange{ .start = @truncate(src + rng + 1), .end = seedGroup.end, .processed = false });

                    if (seedGroup.start < src) {
                        items[i] = SeedRange{ .start = seedGroup.start, .end = @truncate(src - 1), .processed = false };
                        try seedList.append(SeedRange{ .start = @truncate(dest), .end = end, .processed = true });
                    } else items[i] = SeedRange{ .start = @truncate(dest + seedGroup.start - src), .end = end, .processed = true };
                }
            }
        }
    }

    // Get the lowest value and print
    var result: u32 = std.math.maxInt(u32);
    for (seedList.items) |seed| {
        if (seed.start < result)
            result = seed.start;
    }
    std.debug.print("Result: {d}\n", .{result});
}
