module draw_vertical_line(clock, reset,
                          start, done,
                          x, min_y, max_y, colour,
                          vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // Inputs
    input [7:0] x;        // Horizontal position of line
    input [6:0] max_y;    // Starting y-coordinates
    input [6:0] min_y;    // Ending y-coordinate
    input [17:0] colour;  // Colour of line

    // Signals to the VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [17:0] vga_colour;
    output vga_write;
endmodule
