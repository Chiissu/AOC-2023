const std = @import("std");

pub fn main() !void {

    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    var result: u32 = 0;

    // Iterate through each line
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("Processing: {s}\n", .{line});

        var firstNum: ?u8 = null;
        var lastNum: u8 = 0;

        // Iterate through each character
        for (line, 0..) |char, i| charCalc: {
            var num: u8 = 0;

            if (57 < char) {
                // The current character is a letter
                const numCheckRes = checkForNum(line, @truncate(i));

                // The current position does not have a number
                if (numCheckRes == null) break :charCalc;

                // Save the result
                num = numCheckRes.?;
            } else {
                // The current character is a number, save the result
                num = @truncate(char);
                num = num - 48;
            }

            // Store the result
            if (firstNum == null) {
                firstNum = num;
            }
            lastNum = num;
        }

        std.debug.print("Number: {d}{d}\n", .{ firstNum.?, lastNum });

        // Add the result up
        result = result + firstNum.? * 10 + lastNum;
    }

    // Show result
    std.debug.print("Final answer: {d}\n", .{result});
}

fn checkForNum(line: []u8, position: u8) ?u8 {
    const numNames: [10][]const u8 = .{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    if (line.len > position + 4) {
        const slice = line[position .. position + 5];
        if (std.mem.eql(u8, slice, numNames[3])) return 3;
        if (std.mem.eql(u8, slice, numNames[7])) return 7;
        if (std.mem.eql(u8, slice, numNames[8])) return 8;
    }
    if (line.len > position + 3) {
        const slice = line[position .. position + 4];
        if (std.mem.eql(u8, slice, numNames[0])) return 0;
        if (std.mem.eql(u8, slice, numNames[4])) return 4;
        if (std.mem.eql(u8, slice, numNames[5])) return 5;
        if (std.mem.eql(u8, slice, numNames[9])) return 9;
    }
    if (line.len > position + 2) {
        const slice = line[position .. position + 3];
        if (std.mem.eql(u8, slice, numNames[1])) return 1;
        if (std.mem.eql(u8, slice, numNames[2])) return 2;
        if (std.mem.eql(u8, slice, numNames[6])) return 6;
    }
    return null;
}
