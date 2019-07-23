module draw_vertical_line(clock, reset,
                      start, done,
                      curr_x, min_y, max_y,
                      vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // The center of the crosshair to be drawn
    // IMPORTANT NOTE: This is already in pixels, i.e. the location on the VGA display
    input [7:0] curr_x;
    input [6:0] max_y;
    input [6:0] min_y;

    // Signals to the VGA adapter
    output reg [7:0] vga_x;
    output reg [6:0] vga_y;
    output [17:0] vga_colour; assign vga_colour = 18'b000111000111000111;
    output vga_write;




endmodule