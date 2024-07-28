const std = @import("std");
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    // try bf_com("++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>>++++.---.+++++++..+++.");
    // std.log.info("{s}", .{});
    try stdout.print("content-type: text/html\n\n", .{});
    try readFile();
}

fn bf_com(text: []const u8) !void {
    var arr = std.mem.zeroes([30_000]u8);
    var ptr: usize = 0;
    var i: usize = 0;
    var offset: usize = 0;
    var loop_start: usize = 0;
    var loop_start_ptr: usize = 0;

    // const stdin = std.io.getStdIn().reader();
    // std.log.info("{any}", .{a});
    while (true) {
        if (i - offset < text.len) {
            // const operation = std.meta.stringToEnum(BfCase, text[i - offset]);
            const operation = text[i - offset];
            switch (operation) {
                '>' => ptr += 1,
                '<' => ptr -= 1,
                '+' => arr[ptr] += 1,
                '-' => arr[ptr] -= 1,
                '.' => try stdout.print("{c}", .{arr[ptr]}),
                '[' => {
                    loop_start = i;
                    loop_start_ptr = ptr;
                },
                ']' => {
                    if (arr[loop_start_ptr] != 0) {
                        offset = i - loop_start;
                        ptr = loop_start_ptr;
                    }
                },
                else => {},
            }
        } else {
            break;
        }
        i += 1;
    }
}

fn readFile() !void {
    const data = @embedFile("code.bf");
    const lines = std.mem.tokenize(u8, data, "\n");

    try bf_com(lines.buffer);
}
