module main(clock, reset,
            SW, KEY, HEX7, HEX6, HEX5, HEX4,
            vga_x, vga_y, vga_colour, vga_write);
    // Global clock and reset
    input clock;
    input reset;

    input [17:0] SW;
    input [3:0] KEY;
    output [6:0] HEX4, HEX5, HEX6, HEX7;

    // Signals to VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    wire load_x;
    wire load_y;
    wire load_angle;
    wire [1:0] grid_access;
    wire level_loader_start, draw_grid_start, raytracer_start;
    wire level_loader_done, draw_grid_done, raytracer_done;
    _main_fsm mf0(
      .clock(clock),
      .reset(reset),
      .KEY(KEY),
      .grid_access(grid_access),
      .level_loader_done(level_loader_done),
      .draw_grid_done(draw_grid_done),
      .raytracer_done(raytracer_done),
      .level_loader_start(level_loader_start),
      .draw_grid_start(draw_grid_start),
      .raytracer_start(raytracer_start),
      .load_x(load_x),
      .load_y(load_y),
      .load_angle(load_angle));
    _main_datapath md0(
      .clock(clock),
      .reset(reset),
      .data(SW[17:4]),
      .level(SW[3:2]),
      .grid_access(grid_access),
      .level_loader_done(level_loader_done),
      .draw_grid_done(draw_grid_done),
      .raytracer_done(raytracer_done),
      .level_loader_start(level_loader_start),
      .draw_grid_start(draw_grid_start),
      .raytracer_start(raytracer_start),
      .vga_x(vga_x),
      .vga_y(vga_y),
      .vga_colour(vga_colour),
      .vga_write(vga_write),
      .HEX7(HEX7),
      .HEX6(HEX6),
      .HEX5(HEX5),
      .HEX4(HEX4),
      .load_x(load_x),
      .load_y(load_y),
      .load_angle(load_angle));
endmodule

module _main_fsm(clock, reset,
                 KEY,
                 grid_access,
                 load_x, load_y, load_angle,
                 level_loader_done, draw_grid_done, raytracer_done,
                 level_loader_start, draw_grid_start, raytracer_start);
    // Global clock and reset
    input clock;
    input reset;

    input [3:0] KEY;

    // Controls to datapath
    output load_x, load_y, load_angle;
    output level_loader_start, draw_grid_start, raytracer_start;
    output [1:0] grid_access;
    input level_loader_done, draw_grid_done, raytracer_done;

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam WAIT_FOR_X          = 4'd0,
               LOAD_X              = 4'd1,
               WAIT_FOR_Y          = 4'd2,
               LOAD_Y              = 4'd3,
               WAIT_FOR_ANGLE      = 4'd4,
               LOAD_ANGLE          = 4'd5,
               LOAD_LEVEL          = 4'd6,
               WAIT_FOR_LEVEL_DONE = 4'd7,
               DRAW_GRID           = 4'd8,
               WAIT_FOR_GRID_DONE  = 4'd9,
               RAYTRACER           = 4'd10,
               WAIT_FOR_RAY_DONE   = 4'd11,
               DONE                = 4'd12;

     // Transition table
     always @(posedge clock) begin
        if (reset)
          state <= WAIT_FOR_X;
        else begin
          case (state)
            WAIT_FOR_X:          state <= KEY[0] ? LOAD_X : WAIT_FOR_X;
            LOAD_X:              state <= WAIT_FOR_Y;
            WAIT_FOR_Y:          state <= KEY[1] ? LOAD_Y : WAIT_FOR_Y;
            LOAD_Y:              state <= WAIT_FOR_ANGLE;
            WAIT_FOR_ANGLE:      state <= KEY[2] ? LOAD_ANGLE : WAIT_FOR_ANGLE;
            LOAD_ANGLE:          state <= LOAD_LEVEL;
            LOAD_LEVEL:          state <= WAIT_FOR_LEVEL_DONE;
            WAIT_FOR_LEVEL_DONE: state <= level_loader_done ? DRAW_GRID : WAIT_FOR_LEVEL_DONE;
            DRAW_GRID:           state <= WAIT_FOR_GRID_DONE;
            WAIT_FOR_GRID_DONE:  state <= draw_grid_done ? RAYTRACER : WAIT_FOR_GRID_DONE;
            RAYTRACER:           state <= WAIT_FOR_RAY_DONE;
            WAIT_FOR_RAY_DONE:   state <= raytracer_done ? DONE : WAIT_FOR_RAY_DONE;
            DONE:                state <= WAIT_FOR_X;
            default:             state <= WAIT_FOR_X;
          endcase
        end
     end

     // Output signal logic
     assign load_x = state == LOAD_X;
     assign load_y = state == LOAD_Y;
     assign load_angle = state == LOAD_ANGLE;
     assign level_loader_start = state == LOAD_LEVEL;
     assign draw_grid_start = state == DRAW_GRID;
     assign raytracer_start = state == RAYTRACER;
endmodule


module _main_datapath(clock, reset,
                      data, level,
                      grid_access,
                      load_x, load_y, load_angle,
                      level_loader_done, draw_grid_done, raytracer_done,
                      level_loader_start, draw_grid_start, raytracer_start,
                      vga_x, vga_y, vga_colour, vga_write,
                      HEX7, HEX6, HEX5, HEX4);
    // Global clock and reset
    input clock;
    input reset;

    // Inputs
    input [13:0] data; // [13:0] x, [12:0] y, [7:0] angle
    input [1:0] level;

    // FSM controls
    input [1:0] grid_access;
    input load_x, load_y, load_angle;
    input level_loader_start, draw_grid_start, raytracer_start;
    output level_loader_done, draw_grid_done, raytracer_done;

    // Signals to VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    output [6:0] HEX4, HEX5, HEX6, HEX7;

    // Data
    reg [13:0] x;
    reg [12:0] y;
    reg [7:0] angle;

    // Grid
    wire [5:0] grid_x;
    wire [4:0] grid_y;
    wire grid_write;
    wire [2:0] grid_in;
    wire [2:0] grid_out;
    grid g0(
      .clock(clock),
      .x(grid_x),
      .y(grid_y),
      .write(grid_write),
      .in(grid_in),
      .out(grid_out));

    // Grid access control
    reg [5:0] ll_grid_x;
    reg [4:0] ll_grid_y;
    reg [2:0] ll_grid_in;
    reg ll_grid_write;
    reg [5:0] dg_grid_x;
    reg [4:0] dg_grid_y;
    reg [5:0] rt_grid_x;
    reg [4:0] rt_grid_y;
    always @(*) begin
        case (grid_access)
            2'd0: begin
                grid_x = ll_grid_x;
                grid_y = ll_grid_y;
                grid_write = ll_grid_write;
                grid_in = ll_grid_in;
            end
            2'd1: begin
                grid_x = dg_grid_x;
                grid_y = dg_grid_y;
                grid_write = 1'b0;
                grid_in = 3'b0;
            end
            2'd2: begin
                grid_x = rt_grid_x;
                grid_y = rt_grid_y;
                grid_write = 1'b0;
                grid_in = 3'b0;
            end
            default: begin
                grid_x = 6'b0;
                grid_y = 5'b0;
                grid_write = 1'b0;
                grid_in = 3'b0;
            end
        endcase
    end

    // Level loader
    level_loader ll0(
      .clock(clock),
      .reset(reset),
      .start(level_loader_start),
      .done(level_loader_done),
      .level(level),
      .grid_x(ll_grid_x),
      .grid_y(ll_grid_y),
      .grid_in(ll_grid_in),
      .grid_write(ll_grid_write));

    // Draw grid
    draw_grid dg0(
      .clock(clock),
      .reset(reset),
      .start(draw_grid_start),
      .done(draw_grid_done),
      .grid_x(dg_grid_x),
      .grid_y(dg_grid_y),
      .grid_out(grid_out),
      .vga_x(vga_x),
      .vga_y(vga_y),
      .vga_colour(vga_colour),
      .vga_write(vga_write)
      );

    // Raytracer
    wire [5:0] ray_x;
    wire [4:0] ray_y;
    raytracer r0(
      .clock(clock),
      .reset(reset),
      .start(raytracer_start),
      .done(raytracer_done),
      .x(x),
      .y(y),
      .angle(angle),
      .result_x(ray_x),
      .result_y(ray_y),
      .grid_x(rt_grid_x),
      .grid_y(rt_grid_y),
      .grid_out(grid_out)
      );

    // Load logic
    always @(posedge clock) begin
        if (reset) begin
            x <= 14'b0;
            y <= 13'b0;
            angle <= 8'b0;
        end
        else begin
            if (load_x)
                x <= data[13:0];
            if (load_y)
                y <= data[12:0];
            if (load_angle)
                angle <= data[7:0];
        end
    end

    // HEX: X
    hex h7(
      .c({2'b0, ray_x[5:4]}),
      .hex(HEX7)
      );
    hex h6(
      .c(ray_x[3:0]),
      .hex(HEX6)
      );

    // HEX: Y
    hex h5(
      .c({3'b0, ray_y[4:4]}),
      .hex(HEX5)
      );
    hex h4(
      .c(ray_y[3:0]),
      .hex(HEX4)
      );
endmodule
