const std = @import("std");

pub fn main() !void {
    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    const allocator = std.heap.page_allocator;

    // Step 1: Convert file to 2d array, and create list of numbers
    var buf: [1024]u8 = undefined;
    var schematic: [140][140]u8 = undefined;
    var partNumbers = std.AutoArrayHashMap(u64, PartInfo).init(allocator);
    defer partNumbers.deinit();
    var partLength: usize = 0;
    {
        var lineIndex: u8 = 0;
        while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            if (line.len == 0) break;
            std.mem.copyForwards(u8, schematic[lineIndex][0..line.len], line);
            var skipMem: u8 = 0;
            for (line, 0..) |char, charIndex| {
                if (skipMem > 0) {
                    skipMem -= 1;
                    continue;
                }
                if (char < 48 or 57 < char) continue;

                // The currnet position is a character

                const nextLetterIdx = findNextLetter(line[charIndex..]);

                var numberLength: usize = 0;

                if (nextLetterIdx == null)
                    numberLength = 140 - charIndex
                else
                    numberLength = nextLetterIdx.?;
                const val = schematic[lineIndex][charIndex .. charIndex + numberLength];
                skipMem = @truncate(numberLength);
                try partNumbers.put(partLength, PartInfo{ .pos = .{ .x = lineIndex, .y = @truncate(charIndex) }, .val = val });
                partLength += 1;
            }
            lineIndex += 1;
        }
    }

    // Step 2: Look for valid part numbers
    var partItr = partNumbers.iterator();
    var result: u64 = 0;
    while (partItr.next()) |partPtr| {
        const part = partPtr.value_ptr.*;
        const bounds = .{
            .top = if (part.pos.x == 0) 0 else part.pos.x - 1,
            .bottom = if (part.pos.x > 138) 139 else part.pos.x + 1,
            .left = if (part.pos.y == 0) 0 else part.pos.y - 1,
            .right = if (part.pos.y + part.val.len > 138) 139 else part.pos.y + part.val.len,
        };

        // Check for engine part marker in scan area
        for (schematic[bounds.top .. bounds.bottom + 1]) |line| {
            for (line[bounds.left .. bounds.right + 1]) |char| {
                for ("@#$%&*-=+/") |searchChar| {
                    if (char == searchChar) {
                        // There is a marker in scan area, add the part number to result
                        std.debug.print("Found valid part number: {s}\n", .{part.val});
                        for (part.val, 0..) |digitChar, digitIdx| {
                            result += (digitChar - 48) * std.math.pow(u64, 10, part.val.len - digitIdx - 1);
                        }
                    }
                }
            }
        }
    }

    std.debug.print("Result: {d}\n", .{result});
}

const PartInfo = struct {
    pos: struct {
        x: u8,
        y: u8,
    },
    val: []u8,
};

fn findNextLetter(input: []u8) ?usize {
    const searchChars = "@#$%&*-=+./";
    for (input, 0..) |char, charIndex| {
        for (searchChars) |searchChar| {
            if (searchChar == char) return charIndex;
        }
    }
    return null;
}
