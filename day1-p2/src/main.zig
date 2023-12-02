const std = @import("std");

pub fn main() !void {

    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    var numNames: [10][]const u8 = undefined;
    numNames[0] = "zero";
    numNames[1] = "one";
    numNames[2] = "two";
    numNames[3] = "three";
    numNames[4] = "four";
    numNames[5] = "five";
    numNames[6] = "six";
    numNames[7] = "seven";
    numNames[8] = "eight";
    numNames[9] = "nine";
    var result: u64 = 0;

    // Iterate through each line
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("Processing: {s}\n", .{line});

        var firstNumFound = false;
        var firstNum: u8 = 0;
        var lastNum: u8 = 0;

        // Iterate through each character
        for (line, 0..) |char, i| charCalc: {
            var num: u8 = 0;

            if (57 < char) {
                // Process character
                var checkNum: u8 = 0;
                switch (char) {
                    101 => checkNum = 8,
                    102 => {
                        // F, might be 4 or 5
                        if (line.len < i + 4) break :charCalc;
                        switch (line[i + 1]) {
                            111 => checkNum = 4,
                            105 => checkNum = 5,
                            else => break :charCalc,
                        }
                    },
                    110 => checkNum = 9,
                    111 => checkNum = 1,
                    115 => {
                        // S, might be 6 or 7
                        if (line.len < i + 3) break :charCalc;
                        switch (line[i + 1]) {
                            105 => checkNum = 6,
                            101 => checkNum = 7,
                            else => break :charCalc,
                        }
                    },
                    116 => {
                        if (line.len < i + 3) break :charCalc;
                        switch (line[i + 1]) {
                            119 => checkNum = 2,
                            104 => checkNum = 3,
                            else => break :charCalc,
                        }
                    },
                    122 => checkNum = 0,
                    else => break :charCalc,
                }

                const checkNumStr: []const u8 = numNames[checkNum];
                if (line.len < i + checkNumStr.len) break :charCalc;

                const slice = line[i .. i + checkNumStr.len];
                if (!std.mem.eql(u8, slice, checkNumStr)) break :charCalc;

                num = checkNum;
            } else {
                // Process number
                num = @truncate(char);
                num = num - 48;
            }

            // store the result
            if (!firstNumFound) {
                firstNumFound = true;
                firstNum = num;
            }
            lastNum = num;
        }

        std.debug.print("Number: {d}{d}\n", .{ firstNum, lastNum });
        // Add the result up
        result = result + firstNum * 10 + lastNum;
    }

    // Show result
    std.debug.print("Final answer: {d}\n", .{result});
    for ("abcdefg") |c| {
        std.debug.print("{d} ", .{c});
    }
}
