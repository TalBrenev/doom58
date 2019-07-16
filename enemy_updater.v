// Question: Needs an input to tell it when to stop
module enemy_updater(clock, reset,
                     start, done,
                     grid_x, grid_y, grid_out, grid_write, grid_in);
    // 50MHZ to 25Hz using rateDivider
    input clock;
    input reset;

    input start;
    // Question: input continue;
    output done;

    // xy-coordinates go into grid and whatever is stored in the grid comes out
    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;
    // If we're updating enemy movement these will be used
    output grid_write;
    output [2:0] grid_in;

    // FSM datapath controls
    wire update_enemy, increment_counter, update_enemy_done, reset_counter;
    _enemy_updater_fsm euf0(.clock(clock),
                            .reset(reset),
                            .start(start),
                            .done(done),
                            .update_enemy(update_enemy),
                            .increment_counter(increment_counter),
                            .reset_counter(reset_counter),
                            .update_enemy_done(update_enemy_done));

    _enemy_updater_datapath eud0(.clock(clock),
                                 .reset(reset),
                                 .grid_x(grid_x),
                                 .grid_y(grid_y),
                                 .grid_out(grid_out),
                                 .grid_write(grid_write),
                                 .grid_in(grid_in),
                                 .update_enemy(update_enemy),
                                 .increment_counter(increment_counter),
                                 .reset_counter(reset_counter),
                                 .update_enemy_done(update_enemy_done));

endmodule

module _enemy_updater_fsm(clock, reset,
                          start, done,
                          update_enemy, increment_counter, reset_counter, update_enemy_done);
    input clock, reset;
    input start;
    output done;

    // FSM controls
    output update_enemy, increment_counter, reset_counter;
    input update_enemy_done;

    // State register
    reg [2:0] state;

    // Flip-flop assignments
    localparam WAIT                  = 3'd0,
               INITIALIZE            = 3'd1,
               UPDATE_ENEMY          = 3'd2,
               WAIT_FOR_UPDATE_ENEMY = 3'd3,
               INCREMENT             = 3'd4,
               DONE                  = 3'd5;

    // Transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:             state <= start ? INITIALIZE : WAIT;
                INITIALIZE:       state <= UPDATE_ENEMY;
                UPDATE_ENEMY:     state <= WAIT_FOR_UPDATE_ENEMY;
                // Question: This will loop forever right now
                WAIT_FOR_UPDATE_ENEMY: state <= update_enemy_done ? INCREMENT : WAIT_FOR_UPDATE_ENEMY;
                INCREMENT:        state <= UPDATE_ENEMY;
                DONE:             state <= WAIT;
                default:          state <= WAIT;
            endcase
        end
    end

    // Output signal logic
    assign update_enemy = state == UPDATE_ENEMY;
    assign increment_counter = state = INCREMENT;
    assign reset_counter = state == INITIALIZE;

endmodule


module _enemy_updater_datapath(clock, reset
                               grid_x, grid_y, grid_out, grid_write, grid_in,
                               update_enemy, increment_counter, reset_counter, update_enemy_done);
     input clock, reset;

     // Values of the counters
     output [5:0] grid_x;
     output [4:0] grid_y;
     // Check this for enemy (binary-value of 4)
     input [2:0] grid_out;
     output grid_write;
     output [2:0] grid_in;

     // FSM controls
     input update_enemy, increment_counter, reset_counter;
     output update_enemy_done;

     wire slow_clock;
     // 25 Hz clock
     rateDivider rD0(
       .CLOCK_50(clock),
       .slow_clock(slow_clock),
       .select(2'b01));

     // Update enemy logic
     always @(posedge clock) begin
     end

     // Counter logic
     // Counters for iterating through grid
     reg [5:0] grid_x;
     reg [4:0] grid_y;
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
           if (x_at_max && y_at_max) begin
               grid_x <= 0;
               grid_y <= 0;
           end
           else if (x_at_max) begin
               grid_x <= 0;
               grid_y <= grid_y + 1;
           end
           else
               grid_x <= grid_x + 1;
       end
     end

endmodule
