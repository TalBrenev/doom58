module level_loader(clock, reset,
                    start, done,
                    level,
                    grid_x, grid_y, grid_in, grid_write);
    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // Level select for 4 levels to obtain the grid values
    input [1:0] level;

    // Outputs for the grid given by the level
    output [5:0] grid_x;
    output [4:0] grid_y;
    output [2:0] grid_in;
    output grid_write;

    // Signals to be sent from FSM to datapath
    wire reset_counter, increment_counter;
    // Signals to be sent from datapath to FSM
    wire counter_at_max;
    _level_loader_fsm llf0(.clock(clock),
                           .reset(reset),
                           .start(start),
                           .done(done),
                           .reset_counter(reset_counter),
                           .increment_counter(increment_counter),
                           .grid_write(grid_write),
                           .counter_at_max(counter_at_max));

    _level_loader_datapath lld0(.clock(clock),
                                .reset(reset),
                                .level(level),
                                .grid_x(grid_x),
                                .grid_y(grid_y),
                                .grid_in(grid_in),
                                .reset_counter(reset_counter),
                                .increment_counter(increment_counter),
                                .counter_at_max(counter_at_max));

endmodule

module _level_loader_fsm(clock, reset,
                         start, done,
                         reset_counter, increment_counter, grid_write, counter_at_max);
    // Global clock and reset
    input clock;
    input reset;

    // External controls
    input start;
    output done;

    // Controls to datapath
    output reset_counter, increment_counter, grid_write;
    input counter_at_max;

    // State register
    reg [2:0] state;

    // Flip-flop assignments
    localparam WAIT          = 3'd0,
               INITIALIZE    = 3'd1,
               STORE_IN_GRID = 3'd2,
               INCREMENT     = 3'd3,
               DONE          = 3'd4;

    // Transition table
    always @(posedge clock) begin
       if (reset)
           state <= WAIT;
       else begin
           case (state)
               WAIT:           state <= start ? INITIALIZE : WAIT;
               INITIALIZE:     state <= STORE_IN_GRID;
               STORE_IN_GRID:  state <= counter_at_max ? DONE : INCREMENT;
               INCREMENT:      state <= STORE_IN_GRID;
               DONE:           state <= WAIT;
               default:        state <= WAIT;
           endcase
       end
    end

    // Output signal logic based on what state we're in
    assign reset_counter = state == INITIALIZE;
    assign increment_counter = state == INCREMENT;
    assign grid_write = state == STORE_IN_GRID;
    assign done = state == DONE;
endmodule

module _level_loader_datapath(clock, reset, level,
                            grid_x, grid_y, grid_in,
                            reset_counter, increment_counter, counter_at_max);
    // Global clock and reset
    input clock;
    input reset;

    // Level select for 4 levels to obtain the grid values
    input [1:0] level;

    // Levels
    localparam LEVEL_0 = 2'd0,
               LEVEL_1 = 2'd1,
               LEVEL_2 = 2'd2,
               LEVEL_3 = 2'd3;

    // Signals from the level module chosen
    output [5:0] grid_x;
    output [4:0] grid_y;
    output [2:0] grid_in;
    reg [2:0] grid_in;

    // FSM controls
    input reset_counter;
    input increment_counter;
    output counter_at_max;

    // Counters for iterating through grid
    reg [5:0] grid_x;
    reg [4:0] grid_y;

    // Counter logic
    wire x_at_max;
    wire y_at_max;
    assign x_at_max = grid_x == 6'd39;
    assign y_at_max = grid_y == 5'd29;
    always @(posedge clock) begin
        if (reset_counter | reset) begin
            grid_x <= 6'b0;
            grid_y <= 5'b0;
        end
        else if (increment_counter) begin
            if (x_at_max) begin
                grid_x <= 0;
                grid_y <= grid_y + 1;
            end
            else
                grid_x <= grid_x + 1;
        end
    end
    assign counter_at_max = x_at_max & y_at_max;

    // Logic for the 4 levels
    wire [2:0] grid_in0, grid_in1, grid_in2, grid_in3;
    level_0 lvl0(.x(grid_x), .y(grid_y), .value(grid_in0));
    level_1 lvl1(.x(grid_x), .y(grid_y), .value(grid_in1));
    level_2 lvl2(.x(grid_x), .y(grid_y), .value(grid_in2));
    level_3 lvl3(.x(grid_x), .y(grid_y), .value(grid_in3));

    always @(*) begin
        case (level)
            LEVEL_0: grid_in = grid_in0;
            LEVEL_1: grid_in = grid_in1;
            LEVEL_2: grid_in = grid_in2;
            LEVEL_3: grid_in = grid_in3;
            default: grid_in = grid_in0;
        endcase
    end
endmodule
