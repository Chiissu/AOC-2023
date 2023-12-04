const std = @import("std");

pub fn main() !void {
    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    // Find digits in each line
    var buf: [1024]u8 = undefined;
    var cardValues = initArray(u16, 209, 0);
    {
        var cardIdx: u8 = 0;
        while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            var point: u16 = 0;

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
                        point += 1;
                    }
                }
            }
            std.debug.print("This card has a total point of {d}\n", .{point});
            cardValues[cardIdx] = point;
            cardIdx += 1;
        }
    }

    var result: u32 = 0;
    var copiesStorage = initArray(u32, 209, 1);
    for (cardValues, 0..) |cardValue, cardIdx| {
        const copies = if (cardIdx == 0) 1 else copiesStorage[cardIdx];
        const valueCount: u16 = cardValue;
        var i: u16 = 1;
        std.debug.print("Card {d} has {d} copies\n", .{ cardIdx + 1, copies });
        while (valueCount >= i) {
            if (cardIdx + i > copiesStorage.len) continue;
            copiesStorage[cardIdx + i] += copies;
            i += 1;
        }
        result += copies;
    }

    std.debug.print("Result: {d}\n", .{result});
}

fn initArray(comptime numType: type, comptime len: u8, initialVal: numType) [len]numType {
    var array: [len]numType = undefined;
    for (array, 0..) |elem, elemIdx| {
        _ = elem;
        array[elemIdx] = initialVal;
    }
    return array;
}

fn toNumber(str: []const u8) u64 {
    var num: u64 = 0;
    for (str, 0..) |digitChar, digitIdx| {
        num += @truncate((digitChar - 48) * std.math.pow(u64, 10, str.len - digitIdx - 1));
    }
    return num;
}
