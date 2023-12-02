const std = @import("std");

pub fn main() !void {
    // Read input
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
    var buf_reader = std.io.bufferedReader(input.reader());
    var in_stream = buf_reader.reader();

    const limits = .{
        .red = 12,
        .green = 13,
        .blue = 14,
    };

    // Find digits in each line
    var buf: [1024]u8 = undefined;
    var game: u8 = 0;
    var result: u16 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| gameInfoLoop: {
        game = game + 1;

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

                var max: u8 = undefined;
                if (std.mem.eql(u8, color, "red")) {
                    max = limits.red;
                } else if (std.mem.eql(u8, color, "blue")) {
                    max = limits.blue;
                } else if (std.mem.eql(u8, color, "green")) {
                    max = limits.green;
                }
                if (num > max) break :gameInfoLoop;
            }
        }
        std.debug.print("Game {} added\n", .{game});
        result = result + game;
    }
    std.debug.print("Result: {d}\n", .{result});
}
