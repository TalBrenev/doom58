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

    wire draw_line_start;
    wire draw_line_done;
    wire raytracer_start;
    wire raytracer_done;
    wire reset_x;
    wire increment_x;
    wire x_at_max;
    wire rt_grid_access;
    draw_fpv_fsm dfpvfsm0 (.clock(clock),
                           .reset(reset),
                           .start(start),
                           .done(done),
                           .draw_line_start(draw_line_start),
                           .draw_line_done(draw_line_done),
                           .raytracer_start(raytracer_start),
                           .raytracer_done(raytracer_done),
                           .reset_x(reset_x),
                           .increment_x(increment_x),
                           .x_at_max(x_at_max),
                           .rt_grid_access(rt_grid_access));
    draw_fpv_datapath dfpvdp0 (.clock(clock),
                               .reset(reset),
                               .draw_line_start(draw_line_start),
                               .draw_line_done(draw_line_done),
                               .raytracer_start(raytracer_start),
                               .raytracer_done(raytracer_done),
                               .reset_x(reset_x),
                               .increment_x(increment_x),
                               .x_at_max(x_at_max),
                               .rt_grid_access(rt_grid_access),
                               .player_pos_x(player_pos_x),
                               .player_pos_y(player_pos_y),
                               .player_angle(player_angle),
                               .grid_x(grid_x),
                               .grid_y(grid_y),
                               .grid_out(grid_out),
                               .vga_x(vga_x),
                               .vga_y(vga_y),
                               .vga_colour(vga_colour),
                               .vga_write(vga_write));
endmodule

module draw_fpv_fsm(clock, reset,
                    start, done,
                    draw_line_start, draw_line_done, raytracer_start, raytracer_done,
                    reset_x, increment_x, x_at_max, rt_grid_access);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // Controls to/from datapath
    output draw_line_start;
    input draw_line_done;
    output raytracer_start;
    input raytracer_done;
    output reset_x;
    output increment_x;
    input x_at_max;
    output rt_grid_access;

    // State assignments
    reg [2:0] state;
    localparam WAIT                    = 3'd0,
               INITIALIZE              = 3'd1,
               RAYTRACER               = 3'd2,
               WAIT_FOR_RAYTRACER_DONE = 3'd3,
               DRAW_LINE               = 3'd4,
               WAIT_FOR_DRAW_LINE_DONE = 3'd5,
               INCREMENT_X             = 3'd6,
               DONE                    = 3'd7;

    // State transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:                     state <= start ? INITIALIZE : WAIT;
                INITIALIZE:               state <= RAYTRACER;

                RAYTRACER:                state <= WAIT_FOR_RAYTRACER_DONE;
                WAIT_FOR_RAYTRACER_DONE:  state <= raytracer_done ? DRAW_LINE : WAIT_FOR_RAYTRACER_DONE;

                DRAW_LINE:                state <= WAIT_FOR_DRAW_LINE_DONE;
                WAIT_FOR_DRAW_LINE_DONE:  state <= draw_line_done ? (x_at_max ? DONE : INCREMENT_X) : WAIT_FOR_DRAW_LINE_DONE;

                INCREMENT_X:              state <= RAYTRACER;

                DONE:                     state <= WAIT;

                default:                  state <= WAIT;
            endcase
        end
    end

    // Output signal logic
    assign raytracer_start = state == RAYTRACER;
    assign draw_line_start = state == DRAW_LINE;
    assign reset_x = state == INITIALIZE;
    assign increment_x = state == INCREMENT_X;
    assign rt_grid_access = (state == RAYTRACER) | (state == WAIT_FOR_RAYTRACER_DONE);
    assign done = state == DONE;
endmodule

module draw_fpv_datapath(clock, reset,
                         draw_line_start, draw_line_done, raytracer_start, raytracer_done,
                         reset_x, increment_x, x_at_max, rt_grid_access,
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
    wire [8:0] angle_mag;
    assign angle_mag = angle_signed[8] ? (-angle_signed) : angle_signed;
    assign angle = angle_mag[7:0];

    // x counter logic
    always @(posedge clock) begin
        if (reset | reset_x)
            x <= 8'b0;
        else if (increment_x)
            x <= x + 1;
    end
    assign x_at_max = x == 8'd119;

    // Grid access logic
    always @(*) begin
        if (rt_grid_access) begin
            grid_x = rt_grid_x;
            grid_y = rt_grid_y;
        end
        else begin
            grid_x = rt_result_x;
            grid_y = rt_result_y;
        end
    end

    // Colour logic
    always @(*) begin
        if (vertical)
            colour = { {6{grid_out[2]}} , {6{grid_out[1]}} , {6{grid_out[0]}} };
        else
            colour = { {{2{grid_out[2]}}, 4'b0} , {{2{grid_out[1]}}, 4'b0} , {{2{grid_out[0]}}, 4'b0} };
    end
endmodule
