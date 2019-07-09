module hex(c, hex);
    input [3:0] c; // 4-digit binary number input
    output [6:0] hex; // 7-segment display output

    assign hex[0] = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & c[2] & ~c[1] & ~c[0] | c[3] & (c[2] ^ c[1]) & c[0];
    assign hex[1] = c[3] & c[1] & c[0]           | c[2] & c[1] & ~c[0]          | c[3] & c[2] & ~c[0]           | ~c[3] & c[2] & ~c[1] & c[0];
    assign hex[2] = c[3] & c[2] & c[1]           | c[3] & c[2] & ~c[0]          | ~c[3] & ~c[2] & c[1] & ~c[0];
    assign hex[3] = c[2] & c[1] & c[0]           | ~c[3] & c[2] & ~c[1] & ~c[0] | ~c[3] & ~c[2] & ~c[1] & c[0]  | c[3] & ~c[2] & c[1] & ~c[0];
    assign hex[4] = ~c[3] & c[0]                 | ~c[3] & c[2] & ~c[1]         | ~c[2] & ~c[1] & c[0];
    assign hex[5] = ~c[3] & ~c[2] & c[0]         | ~c[3] & ~c[2] & c[1]         | ~c[3] & c[1] & c[0]           | c[3] & c[2] & ~c[1] & c[0];
    assign hex[6] = ~c[3] & ~c[2] & ~c[1]        | ~c[3] & c[2] & c[1] & c[0]   | c[3] & c[2] & ~c[1] & ~c[0];
endmodule
