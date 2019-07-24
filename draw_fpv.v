module draw_fpv(clock, reset,
                start, done,
                player_pos_x, player_pos_y, player_angle,
                grid_x, grid_y, grid_out,
                vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // The current position and angle of the player
    input [13:0] player_pos_x;
    input [12:0] player_pos_y;
    input [7:0] player_angle;

    // Signals to/from the grid memory
    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;

    // Signals to the VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [17:0] vga_colour;
    output vga_write;
endmodule

module draw_fpv_datapath(clock, reset,
                         player_pos_x, player_pos_y, player_angle,
                         grid_x, grid_y, grid_out,
                         vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // The current position and angle of the player
    input [13:0] player_pos_x;
    input [12:0] player_pos_y;
    input [7:0] player_angle;

    // Signals to/from the grid memory
    output reg [5:0] grid_x;
    output reg [4:0] grid_y;
    input [2:0] grid_out;

    // Signals to the VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [17:0] vga_colour;
    output vga_write;

    // Controls to/from fsm
    input draw_line_start;
    output draw_line_done;
    input raytracer_start;
    output raytracer_done;
    input reset_x;
    input increment_x;
    output x_at_max;
    input rt_grid_access;

    // The current x-coordinate on the screen being drawn
    reg [7:0] x;

    // Line drawer
    reg [17:0] colour;
    draw_vertical_line dvl0 (.clock(clock),
                             .reset(reset),
                             .start(draw_line_start),
                             .done(draw_line_done),
                             .x(x),
                             .min_y(7'd0),
                             .max_y(7'd119),
                             .colour(colour),
                             .vga_x(vga_x),
                             .vga_y(vga_y),
                             .vga_colour(vga_colour),
                             .vga_write(vga_write));

    // Raytracer
    wire [7:0] angle;
    wire [5:0] rt_grid_x;
    wire [4:0] rt_grid_y;
    wire [5:0] rt_result_x;
    wire [4:0] rt_result_y;
    wire vertical;
    raytracer rt1 (.clock(clock),
                   .reset(reset),
                   .start(raytracer_start),
                   .done(raytracer_done),
                   .x(player_pos_x),
                   .y(player_pos_y),
                   .angle(angle),
                   .result_x(rt_result_x),
                   .result_y(rt_result_y),
                   .result_dir(vertical),
                   .grid_x(rt_grid_x),
                   .grid_y(rt_grid_y),
                   .grid_out(grid_out));

    // Compute current angle based on column being drawn
    wire [8:0] angle_signed;
    assign angle_signed = {1'b0, player_angle} + (({1'b0, x} - 9'd80) >>> 1);
    wire [8:0] angle_unsigned;
    assign angle_mag = angle_signed[8] ? (-angle_signed) : angle_signed;
    assign angle = angle_mag[7:0];

    // x counter logic
    always @(posedge clock) begin
        if (reset | reset_x)
            x <= 7'b0;
        else if (increment_x)
            x <= x + 1;
    end
    assign x_at_max = x == 8'd119;

    // Grid access logic
    always @(*) begin
        if (rt_grid_access) begin
            grid_x <= rt_grid_x;
            grid_y <= rt_grid_y;
        end
        else begin
            grid_x <= rt_result_x;
            grid_y <= rt_result_y;
        end
    end

    // Colour logic
    always @(*) begin
        if (vertical)
            colour <= { {6{grid_out[2]}} , {6{grid_out[1]}} , {6{grid_out[0]}} };
        else
            colour <= { {2{grid_out[2]}, 4'b0} , {2{grid_out[1]}, 4'b0} , {2{grid_out[0]}, 4'b0} };
    end
endmodule
