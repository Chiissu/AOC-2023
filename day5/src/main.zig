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

    var isParsingSeed = true;
    var seedList: [20]u32 = undefined;
    var seedIdx: u8 = 0;
    var seedMapped: [20]bool = undefined;
    for (seedMapped, 0..) |elem, index| {
        _ = elem;
        seedMapped[index] = false;
    }

    var sectionItr = std.mem.split(u8, file_buffer, "\n\n");
    while (sectionItr.next()) |section| {
        var lineItr = std.mem.split(u8, section, "\n");
        while (lineItr.next()) |s2| {
            var spaceItr = std.mem.split(u8, s2, " ");
            while (spaceItr.next()) |s3| {
                if (std.mem.eql(u8, s3, "map:") or std.mem.eql(u8, s3, "") or std.mem.eql(u8, s3, "seeds:")) continue;

                const num = std.fmt.parseUnsigned(u32, s3, 10) catch {
                    std.debug.print("\n>>> Next section <<<\n", .{});
                    isParsingSeed = false;
                    for (seedMapped, 0..) |elem, index| {
                        _ = elem;
                        seedMapped[index] = false;
                    }
                    continue;
                };

                if (isParsingSeed) {
                    std.debug.print("Parsed seed number: {d}\n", .{num});
                    seedList[seedIdx] = num;
                    seedIdx += 1;
                    continue;
                }

                const dest: u64 = num;
                const src = try std.fmt.parseUnsigned(u64, spaceItr.next().?, 10);
                const rng = try std.fmt.parseUnsigned(u32, spaceItr.next().?, 10);

                std.debug.print("Mapping: {d} {d} {d}\n", .{ dest, src, rng });
                for (seedList, 0..) |elem, index| {
                    if (seedMapped[index]) continue;
                    if (elem > src + rng or elem < src) continue;
                    seedMapped[index] = true;
                    seedList[index] = @truncate(dest + elem - src);
                    std.debug.print("  Seed {d}: {d} => {d}\n", .{ index + 1, elem, seedList[index] });
                }
            }
        }
    }
    std.debug.print("Result: {d}\n", .{findMin(&seedList)});
}

fn findMin(list: []u32) u32 {
    var min: u32 = list[0];

    for (list) |value| {
        if (value < min) {
            min = value;
        }
    }

    return min;
}
