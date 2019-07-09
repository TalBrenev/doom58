module main(clock, reset,
            SW, KEY, HEX4, HEX3, HEX1, HEX0,
            vga_x, vga_y, vga_colour, vga_write);
    // Global clock and reset
    input clock;
    input reset;


    input [17:0] SW;
    input [3:0] KEY;
    output [6:0] HEX0, HEX1, HEX3, HEX4;

    // Signals to VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    wire level_loader_done, draw_grid_done, raytrace_done;
    wire level_loader_start, draw_grid_start, raytrace_start;
    _main_fsm mf0(
      .clock(clock),
      .reset(reset),
      .load_x(KEY[0]),
      .load_y(KEY[1]),
      .load_angle(KEY[2]),
      .level_loader_done(level_loader_done),
      .draw_grid_done(draw_grid_done),
      .raytrace_done(raytrace_done),
      .level_loader_start(level_loader_start),
      .draw_grid_start(draw_grid_start),
      .raytrace_start(raytrace_start)
      );

    wire [5:0] ray_x;
    wire [4:0] ray_y;
    _main_datapath md0(
      .clock(clock),
      .reset(reset),
      .data(SW[17:4]),
      .level(SW[1:0]),
      .level_loader_done(level_loader_done),
      .draw_grid_done(draw_grid_done),
      .raytrace_done(raytrace_done),
      .level_loader_start(level_loader_start),
      .draw_grid_start(draw_grid_start),
      .raytrace_start(raytrace_start),
      .vga_x(vga_x),
      .vga_y(vga_y),
      .vga_colour(vga_colour),
      .vga_write(vga_write),
      .ray_x(ray_x),
      .ray_y(ray_y)
      );

    // HEX: X
    hex h1(
      .c(ray_x[5:2]),
      .hex(HEX1)
      );
    hex h0(
      .c(ray_x[1:0]),
      .hex(HEX0)
      );

    // HEX: Y
    hex h4(
      .c(ray_y[4:1]),
      .hex(HEX4)
      );
    hex h3(
      .c(ray_y[0]),
      .hex(HEX5)
      );
endmodule

module _main_fsm(clock, reset,
                 load_x, load_y, load_angle,
                 level_loader_done, draw_grid_done, raytrace_done,
                 level_loader_start, draw_grid_start, raytrace_start);
    // Global clock and reset
    input clock;
    input reset;

    // Load controls and done
    input load_x;
    input load_y;
    input load_angle;

    // Controls to datapath
    output level_loader_start;
    output draw_grid_start;
    output raytrace_start;
    input level_loader_done, draw_grid_done, raytrace_done;

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam WAIT_FOR_X         = 4'd0,
               LOAD_X             = 4'd1,
               WAIT_FOR_Y         = 4'd2,
               LOAD_Y             = 4'd3,
               WAIT_FOR_ANGLE     = 4'd4,
               LOAD_ANGLE         = 4'd5,
               LOAD_LEVEL         = 4'd6,
               WAIT_FOR_LEVEL_DONE= 4'd7,
               DRAW_GRID          = 4'd8,
               WAIT_FOR_GRID_DONE = 4'd9,
               RAYTRACER          = 4'd10,
               WAIT_FOR_RAY_DONE  = 4'd11,
               DONE               = 4'd12;

     // Transition table
     always @(posedge clock) begin
        if (reset)
          state <= WAIT_FOR_X;
        else begin
          case (state)
            WAIT_FOR_X:         state <= load_x ? LOAD_X : WAIT_FOR_X;
            LOAD_X:             state <= WAIT_FOR_Y;
            WAIT_FOR_Y:         state <= load_y ? LOAD_Y : WAIT_FOR_Y;
            LOAD_Y:             state <= WAIT_FOR_ANGLE;
            WAIT_FOR_ANGLE:     state <= load_angle ? LOAD_ANGLE : WAIT_FOR_ANGLE;
            LOAD_ANGLE:         state <= LOAD_LEVEL;
            LOAD_LEVEL:         state <= WAIT_FOR_LEVEL_DONE;
            WAIT_FOR_LEVEL_DONE:state <= level_loader_done ? DRAW_GRID : WAIT_FOR_LEVEL_DONE;
            DRAW_GRID:          state <= WAIT_FOR_GRID_DONE;
            WAIT_FOR_GRID_DONE: state <= draw_grid_done ? RAYTRACER : WAIT_FOR_GRID_DONE;
            RAYTRACER:          state <= WAIT_FOR_RAY_DONE;
            WAIT_FOR_RAY_DONE:  state <= raytrace_done ? DONE : WAIT_FOR_RAY_DONE;
            DONE:               state <= WAIT_FOR_X;
          endcase
        end
     end

     // Question: output logic of all datapath control signals. Need to

     // Output signal logic
     assign level_loader_start = state == LOAD_LEVEL;
     assign draw_grid_start = state == DRAW_GRID;
     assign raytrace_start = state == RAYTRACER;
endmodule


module _main_datapath(clock, reset,
                      data, level,
                      level_loader_done, draw_grid_done, raytrace_done,
                      level_loader_start, draw_grid_start, raytrace_start,
                      vga_x, vga_y, vga_colour, vga_write,
                      ray_x, ray_y);
      // Global clock and reset
      input clock;
      input reset;

      // Inputs for level loader and raytracer
      input [13:0] data; // [13:0] x, [12:0] y, [7:0] angle
      input [1:0] level;

      // FSM controls
      input level_loader_start;
      input draw_grid_start;
      input raytrace_start;
      output level_loader_done, draw_grid_done, raytrace_done;

      // Signals to VGA adapter
      output [7:0] vga_x;
      output [6:0] vga_y;
      output [2:0] vga_colour;
      output vga_write;

      // Output of raytracer
      output [5:0] ray_x;
      output [4:0] ray_y;

      // Level loader which connects to grid memory
      wire [5:0] llgrid_x;
      wire [4:0] llgrid_y;
      wire [2:0] llgrid_in;
      wire llgrid_write;
      level_loader ll0(
        .clock(clock),
        .reset(reset),
        .start(level_loader_start),
        .done(level_loader_done),
        .level(level),
        .grid_x(llgrid_x),
        .grid_y(llgrid_y),
        .grid_in(llgrid_in),
        .grid_write(llgrid_write));

     grid g0(
       .clock(clock),
       .x(llgrid_x),
       .y(llgrid_y),
       .write(llgrid_write),
       .in(llgrid_in),
       .out()); // Question Don't want the out value


    // Draw grid which connects to VGA adapter. Question: does it actually connect to VGA?
    wire [5:0] dggrid_x; // Question: Not sure nor here
    wire [4:0] dggrid_y; // Question: Not sure what to do here
    draw_grid dg0(
      .clock(clock),
      .reset(reset),
      .start(draw_grid_start),
      .done(draw_grid_done),
      .grid_x(dggrid_x),
      .grid_y(dggrid_y),
      .grid_out(), // Question: Not sure what to do here either
      .vga_x(vga_x),
      .vga_y(vga_y),
      .vga_colour(vga_colour),
      .vga_write(vga_write)
      );

  // Raytracer. Question, where to load, x, y, and angle?
  raytrace r0(
    .clock(clock),
    .reset(reset),
    .start(raytrace_start),
    .done(raytrace_done),
    .x(), // Question ?
    .y(), // Question?
    .angle(), // Question?
    .result_x(ray_x),
    .result_y(ray_y),
    .grid_x(), // Question?
    .grid_y(), // Question?
    .grid_ouy() //Question ?
    );


endmodule
