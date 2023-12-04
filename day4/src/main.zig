const std = @import("std");

pub fn main() !void {
    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    // Find digits in each line
    var buf: [1024]u8 = undefined;
    var result: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var point: u32 = 0;

        var fmtItr1 = std.mem.split(u8, line, ": ");
        std.debug.print("Processing: {s}\n", .{fmtItr1.next().?});
        var fmtItr2 = std.mem.split(u8, fmtItr1.next().?, " | ");

        const winNumbersStr = fmtItr2.next().?;
        const numbersStr = fmtItr2.next().?;

        var winNumberItr = std.mem.split(u8, winNumbersStr, " ");
        while (winNumberItr.next()) |winNumStr| {
            if (winNumStr.len == 0) continue;
            const winNum = toNumber(winNumStr);
            var numberItr = std.mem.split(u8, numbersStr, " ");
            while (numberItr.next()) |numStr| {
                if (numStr.len == 0) continue;
                const num = toNumber(numStr);
                if (num == winNum) {
                    std.debug.print("Found win number: {d}\n", .{winNum});
                    if (point == 0) {
                        point = 1;
                    } else {
                        point *= 2;
                    }
                }
            }
        }
        std.debug.print("This card has a total point of {d}\n", .{point});
        result += point;
    }
    std.debug.print("Result: {d}\n", .{result});
}

fn toNumber(str: []const u8) u64 {
    var num: u64 = 0;
    for (str, 0..) |digitChar, digitIdx| {
        num += @truncate((digitChar - 48) * std.math.pow(u64, 10, str.len - digitIdx - 1));
    }
    return num;
}
