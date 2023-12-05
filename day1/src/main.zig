const std = @import("std");
const Zigstr = @import("Zigstr");

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
        std.debug.print("Processing: {s}\n", .{line});

        var firstNumFound = false;
        var firstNum: u8 = 0;
        var lastNum: u8 = 0;
        for (line) |char| charCalc: {
            if (char < 48 or 57 < char) break :charCalc;
            var num: u8 = @truncate(char);
            num = num - 48;
            if (!firstNumFound) {
                firstNumFound = true;
                firstNum = num;
            }
            lastNum = num;
        }
        std.debug.print("Number: {d}{d}\n", .{ firstNum, lastNum });
        result = result + firstNum * 10 + lastNum;
    }
    std.debug.print("Final answer: {d}\n", .{result});
}
