module main(clock, reset,
            SW, KEY, HEX4, HEX3, HEX1, HEX0,
            vga_x, vga_y, vga_colour, vga_write);
    input clock;
    input reset;

    input [17:0] SW;
    input [3:0] KEY;

    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;
endmodule
