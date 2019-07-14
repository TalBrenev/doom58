module raytracer(clock, reset,
                 start, done,
                 x, y, angle,
                 result_x, result_y,
                 grid_x, grid_y, grid_out);
    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // External inputs (coordinate of start position and angle of ray)
    input [13:0] x;
    input [12:0] y;
    input [7:0] angle;

    // Output (grid coordinates of first obstacle hit by ray)
    output [5:0] result_x;
    output [4:0] result_y;

    // Signals to/from the grid memory
    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;

    wire load_values, go_to_next_pos, on_obstacle;
    _raytracer_fsm rf0 (.clock(clock),
                        .reset(reset),
                        .start(start),
                        .done(done),
                        .load_values(load_values),
                        .go_to_next_pos(go_to_next_pos),
                        .on_obstacle(on_obstacle));
    _raytracer_datapath rd0 (.clock(clock),
                             .reset(reset),
                             .x(x),
                             .y(y),
                             .angle(angle),
                             .grid_x(grid_x),
                             .grid_y(grid_y),
                             .grid_out(grid_out),
                             .result_x(result_x),
                             .result_y(result_y),
                             .load_values(load_values),
                             .go_to_next_pos(go_to_next_pos),
                             .on_obstacle(on_obstacle));
endmodule

module _raytracer_fsm(clock, reset,
                      start, done,
                      load_values, go_to_next_pos, on_obstacle);
    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // Controls to datapath
    output load_values;
    output go_to_next_pos;
    input on_obstacle;

    // State register
    reg [2:0] state;

    // Flip-flop assignments
    localparam WAIT            = 3'd0,
               INITIALIZE      = 3'd1,
               CHECK_OBSTACLE  = 3'd2,
               GO_TO_NEXT_POS  = 3'd3,
               DONE            = 3'd4;

    // Transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:            state <= start ? INITIALIZE : WAIT;
                INITIALIZE:      state <= CHECK_OBSTACLE;
                CHECK_OBSTACLE:  state <= on_obstacle ? DONE : GO_TO_NEXT_POS;
                GO_TO_NEXT_POS:  state <= CHECK_OBSTACLE;
                DONE:            state <= WAIT;
                default:         state <= WAIT;
            endcase
        end
    end

    // Output signal logic
    assign load_values = state == INITIALIZE;
    assign go_to_next_pos = state == GO_TO_NEXT_POS;
    assign done = state == DONE;
endmodule

module _raytracer_datapath(clock, reset,
                           x, y, angle,
                           grid_x, grid_y, grid_out,
                           result_x, result_y,
                           load_values, go_to_next_pos, on_obstacle);
    // Global clock and reset
    input clock;
    input reset;

    // Signals to/from the grid memory
    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;

    // External inputs (coordinate of start position and angle of ray)
    input [13:0] x;
    input [12:0] y;
    input [7:0] angle;

    // Output (grid coordinates of first obstacle hit by ray)
    output [5:0] result_x;
    output [4:0] result_y;

    // Controls from FSM
    input load_values;
    input go_to_next_pos;
    output on_obstacle;

    // Direction vector of ray
    reg [14:0] dir_x;
    reg [13:0] dir_y;

    // Current position
    reg [13:0] pos_x;
    reg [12:0] pos_y;

    wire [14:0] angle_vector_x;
    wire [13:0] angle_vector_y;
    bytian_to_vector btv0 (.bytian(angle),
                           .x(angle_vector_x),
                           .y(angle_vector_y));

    wire [5:0] grid_coord_x;
    wire [4:0] grid_coord_y;
    coordinate_to_grid ctg0 (.coord_x(pos_x),
                             .coord_y(pos_y),
                             .grid_x(grid_coord_x),
                             .grid_y(grid_coord_y));

    always @(posedge clock) begin
        if (reset) begin
            dir_x <= 15'b0;
            dir_y <= 14'b0;
            pos_x <= 14'b0;
            pos_y <= 13'b0;
        end
        else begin
            if (load_values) begin
                pos_x <= x;
                pos_y <= y;
                dir_x <= angle_vector_x;
                dir_y <= angle_vector_y;
            end
            if (go_to_next_pos) begin
                if (dir_x[14])
                    pos_x <= pos_x - dir_x[13:0];
                else
                    pos_x <= pos_x + dir_x[13:0];
                if (dir_y[13])
                    pos_y <= pos_y - dir_y[12:0];
                else
                    pos_y <= pos_y + dir_y[12:0];
            end
        end
    end

    assign result_x = grid_coord_x;
    assign result_y = grid_coord_y;
    assign grid_x = grid_coord_x;
    assign grid_y = grid_coord_y;
    assign on_obstacle = grid_out != 3'b0;
endmodule
