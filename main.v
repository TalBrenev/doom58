module main(clock, reset,
            HEX7, HEX6, HEX5, HEX4,
            vga_x, vga_y, vga_colour, vga_write);
    // Global clock and reset
    input clock;
    input reset;

    output [6:0] HEX4, HEX5, HEX6, HEX7;

    // Signals to VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    wire reset_player;
    wire [1:0] grid_access;
    wire [1:0] vga_access;
    wire level_loader_start, draw_grid_start, draw_player_start, raytracer_start;
    wire level_loader_done, draw_grid_done, draw_player_done, raytracer_done;
    _main_fsm mf0(
      .clock(clock),
      .reset(reset),
      .grid_access(grid_access),
      .vga_access(vga_access),
      .level_loader_done(level_loader_done),
      .draw_grid_done(draw_grid_done),
      .draw_player_done(draw_player_done),
      .raytracer_done(raytracer_done),
      .level_loader_start(level_loader_start),
      .draw_grid_start(draw_grid_start),
      .draw_player_start(draw_player_start),
      .raytracer_start(raytracer_start),
      .reset_player(reset_player));
    _main_datapath md0(
      .clock(clock),
      .reset(reset),
      .grid_access(grid_access),
      .vga_access(vga_access),
      .level_loader_done(level_loader_done),
      .draw_grid_done(draw_grid_done),
      .draw_player_done(draw_player_done),
      .raytracer_done(raytracer_done),
      .level_loader_start(level_loader_start),
      .draw_grid_start(draw_grid_start),
      .draw_player_start(draw_player_start),
      .raytracer_start(raytracer_start),
      .vga_x(vga_x),
      .vga_y(vga_y),
      .vga_colour(vga_colour),
      .vga_write(vga_write),
      .HEX7(HEX7),
      .HEX6(HEX6),
      .HEX5(HEX5),
      .HEX4(HEX4),
      .reset_player(reset_player));
endmodule

module _main_fsm(clock, reset,
                 grid_access, vga_access,
                 reset_player,
                 level_loader_done, draw_grid_done, draw_player_done, raytracer_done,
                 level_loader_start, draw_grid_start, draw_player_start, raytracer_start);
    // Global clock and reset
    input clock;
    input reset;

    // Controls to datapath
    output reset_player;
    output level_loader_start, draw_grid_start, draw_player_start, raytracer_start;
    output [1:0] grid_access;
    output [1:0] vga_access;
    input level_loader_done, draw_grid_done, draw_player_done, raytracer_done;

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam RESET_PLAYER              = 4'd0,
               LOAD_LEVEL                = 4'd1,
               WAIT_FOR_LEVEL_DONE       = 4'd2,
               DRAW_GRID                 = 4'd3,
               WAIT_FOR_GRID_DONE        = 4'd4,
               DRAW_PLAYER               = 4'd5,
               WAIT_FOR_DRAW_PLAYER_DONE = 4'd6,
               RAYTRACER                 = 4'd7,
               WAIT_FOR_RAY_DONE         = 4'd8;

     // Transition table
     always @(posedge clock) begin
        if (reset)
          state <= RESET_PLAYER;
        else begin
          case (state)
            RESET_PLAYER:              state <= LOAD_LEVEL;
            LOAD_LEVEL:                state <= WAIT_FOR_LEVEL_DONE;
            WAIT_FOR_LEVEL_DONE:       state <= level_loader_done ? DRAW_GRID : WAIT_FOR_LEVEL_DONE;

            DRAW_GRID:                 state <= WAIT_FOR_GRID_DONE;
            WAIT_FOR_GRID_DONE:        state <= draw_grid_done ? DRAW_PLAYER : WAIT_FOR_GRID_DONE;

            DRAW_PLAYER:               state <= WAIT_FOR_DRAW_PLAYER_DONE;
            WAIT_FOR_DRAW_PLAYER_DONE: state <= draw_player_done ? RAYTRACER : WAIT_FOR_DRAW_PLAYER_DONE;

            RAYTRACER:                 state <= WAIT_FOR_RAY_DONE;
            WAIT_FOR_RAY_DONE:         state <= raytracer_done ? DRAW_GRID : WAIT_FOR_RAY_DONE;

            default:                   state <= RESET_PLAYER;
          endcase
        end
     end

     // Output signal logic
     assign reset_player = state == RESET_PLAYER;
     assign level_loader_start = state == LOAD_LEVEL;
     assign draw_grid_start = state == DRAW_GRID;
     assign draw_player_start = state == DRAW_PLAYER;
     assign raytracer_start = state == RAYTRACER;
     reg [1:0] grid_access;
     always @(*) begin
         case (state)
             WAIT_FOR_LEVEL_DONE: grid_access = 2'd0;
             WAIT_FOR_GRID_DONE:  grid_access = 2'd1;
             WAIT_FOR_RAY_DONE:   grid_access = 2'd2;
             default:             grid_access = 2'd3;
         endcase
     end
     reg [1:0] vga_access;
     always @(*) begin
         case (state)
             WAIT_FOR_GRID_DONE:        vga_access = 2'd0;
             WAIT_FOR_DRAW_PLAYER_DONE: vga_access = 2'd1;
             default:                   vga_access = 2'd2;
         endcase
     end
endmodule

module _main_datapath(clock, reset,
                      grid_access, vga_access,
                      reset_player,
                      level_loader_done, draw_grid_done, draw_player_done, raytracer_done,
                      level_loader_start, draw_grid_start, draw_player_start, raytracer_start,
                      vga_x, vga_y, vga_colour, vga_write,
                      HEX7, HEX6, HEX5, HEX4);
    // Global clock and reset
    input clock;
    input reset;

    // FSM controls
    input [1:0] grid_access;
    input [1:0] vga_access;
    input reset_player;
    input level_loader_start, draw_grid_start, draw_player_start, raytracer_start;
    output level_loader_done, draw_grid_done, draw_player_done, raytracer_done;

    // Signals to VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    // Frame rate limiter
    reg [20:0] limiter;
    always @(posedge clock) begin
        if (reset | limiter == 0)
            limiter = 21'd1700000;
        else
            limiter = limiter - 1;
    end

    output [6:0] HEX4, HEX5, HEX6, HEX7;

    // Grid
    reg [5:0] grid_x;
    reg [4:0] grid_y;
    reg grid_write;
    reg [2:0] grid_in;
    wire [2:0] grid_out;
    grid g0(
      .clock(clock),
      .x(grid_x),
      .y(grid_y),
      .write(grid_write),
      .in(grid_in),
      .out(grid_out));

    // Grid access control
    wire [5:0] ll_grid_x;
    wire [4:0] ll_grid_y;
    wire [2:0] ll_grid_in;
    wire ll_grid_write;
    wire [5:0] dg_grid_x;
    wire [4:0] dg_grid_y;
    wire [5:0] rt_grid_x;
    wire [4:0] rt_grid_y;
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

    // VGA access control
    reg [7:0] vga_x;
    reg [6:0] vga_y;
    reg [2:0] vga_colour;
    reg vga_write;
    wire [7:0] dg_vga_x;
    wire [6:0] dg_vga_y;
    wire [2:0] dg_vga_col;
    wire dg_vga_w;
    wire [7:0] dp_vga_x;
    wire [6:0] dp_vga_y;
    wire [2:0] dp_vga_col;
    wire dp_vga_w;
    always @(posedge clock) begin
        if (limiter < 21'd60000) begin
            case (vga_access)
                2'd0: begin
                    vga_x = dg_vga_x;
                    vga_y = dg_vga_y;
                    vga_colour = dg_vga_col;
                    vga_write = dg_vga_w;
                end
                2'd1: begin
                    vga_x = dp_vga_x;
                    vga_y = dp_vga_y;
                    vga_colour = dp_vga_col;
                    vga_write = dp_vga_w;
                end
                default: begin
                    vga_x = 8'b0;
                    vga_y = 7'b0;
                    vga_colour = 3'b0;
                    vga_write = 1'b0;
                end
            endcase
        end
        else begin
            vga_x = 8'b0;
            vga_y = 7'b0;
            vga_colour = 3'b0;
            vga_write = 1'b0;
        end
    end

    // Player position and angle
    reg [13:0] player_pos_x;
    reg [12:0] player_pos_y;
    reg [7:0] player_angle;

    // Level loader
    level_loader ll0(
      .clock(clock),
      .reset(reset),
      .start(level_loader_start),
      .done(level_loader_done),
      .level(2'd0),
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
      .vga_x(dg_vga_x),
      .vga_y(dg_vga_y),
      .vga_colour(dg_vga_col),
      .vga_write(dg_vga_w)
      );

    // Draw player
    draw_player dp0(
        .clock(clock),
        .reset(reset),
        .start(draw_player_start),
        .done(draw_player_done),
        .x(player_pos_x),
        .y(player_pos_y),
        .vga_x(dp_vga_x),
        .vga_y(dp_vga_y),
        .vga_colour(dp_vga_col),
        .vga_write(dp_vga_w)
    );

    // Raytracer
    wire [5:0] ray_x;
    wire [4:0] ray_y;
    raytracer r0(
      .clock(clock),
      .reset(reset),
      .start(raytracer_start),
      .done(raytracer_done),
      .x(player_pos_x),
      .y(player_pos_y),
      .angle(player_angle),
      .result_x(ray_x),
      .result_y(ray_y),
      .grid_x(rt_grid_x),
      .grid_y(rt_grid_y),
      .grid_out(grid_out)
      );

    // Load logic
    always @(posedge clock) begin
        if (reset) begin
            player_pos_x <= 14'd0;
            player_pos_y <= 13'd0;
            player_angle <= 8'd0;
        end
        else if (reset_player) begin
            player_pos_x <= 14'd384;
            player_pos_y <= 13'd384;
            player_angle <= 8'd0;
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
