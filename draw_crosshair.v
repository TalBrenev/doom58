module draw_crosshair(clock, reset,
                      start, done,
                      center_x, center_y,
                      vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // The center of the crosshair to be drawn
    // IMPORTANT NOTE: This is already in pixels, i.e. the location on the VGA display
    input [7:0] center_x;
    input [6:0] center_y;

    // Signals to the VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [17:0] vga_colour;
    output vga_write;
endmodule
