const std = @import("std");

pub fn main() !void {
    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    // Find digits in each line
    var buf: [1024]u8 = undefined;
    var gameID: u8 = 0;
    var result: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        gameID = gameID + 1;

        var blueCount: u16 = 0;
        var greenCount: u8 = 0;
        var redCount: u8 = 0;

        var fmtItr = std.mem.split(u8, line, ": ");
        _ = fmtItr.next();
        const gameInfo: []const u8 = fmtItr.next().?;

        var roundItr = std.mem.split(u8, gameInfo, "; ");
        while (roundItr.next()) |roundInfo| {
            var pollItr = std.mem.split(u8, roundInfo, ", ");
            while (pollItr.next()) |pollInfo| {
                var infoItr = std.mem.split(u8, pollInfo, " ");
                const numStr = infoItr.next().?;
                var num: u8 = undefined;
                if (numStr.len > 1)
                    num = (numStr[0] - 48) * 10 + numStr[1] - 48
                else
                    num = numStr[0] - 48;
                const color = infoItr.next().?;

                if (std.mem.eql(u8, color, "red")) {
                    if (redCount < num) redCount = num;
                } else if (std.mem.eql(u8, color, "blue")) {
                    if (blueCount < num) blueCount = num;
                } else if (std.mem.eql(u8, color, "green")) {
                    if (greenCount < num) greenCount = num;
                }
            }
        }
        const gameResult: u16 = greenCount * blueCount * redCount;
        std.debug.print("Game {d} result: {d}\n", .{ gameID, gameResult });
        result = result + gameResult;
    }
    std.debug.print("Result: {d}\n", .{result});
}
