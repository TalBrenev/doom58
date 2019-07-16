module enemy_updater(clock, reset,
                     start, done,
                     grid_x, grid_y, grid_out, grid_write, grid_in);
    // 50MHZ to 25Hz using rateDivider
    input clock;
    input reset;

    // For each start input need to store a counter to store if enough time has
    // passed
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
    wire increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, reset_counters;
    wire is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start;
    _enemy_updater_fsm euf0(.clock(clock),
                            .reset(reset),
                            .start(start),
                            .done(done),
                            .increment_grid_counter(increment_grid_counter),
                            .check_possible_position(check_possible_position),
                            .draw_new_position(draw_new_position),
                            .erase_last_position(erase_last_position),
                            .reset_counters(reset_counters),
                            .is_enemy(is_enemy),
                            .can_goto_new_position(can_goto_new_position),
                            .grid_counter_max(grid_counter_max),
                            .update_enemy_start(update_enemy_start));

    _enemy_updater_datapath eud0(.clock(clock),
                                 .reset(reset),
                                 .grid_x(grid_x),
                                 .grid_y(grid_y),
                                 .grid_out(grid_out),
                                 .grid_write(grid_write),
                                 .grid_in(grid_in),
                                 .increment_grid_counter(increment_grid_counter),
                                 .check_possible_position(check_possible_position),
                                 .draw_new_position(draw_new_position),
                                 .erase_last_position(erase_last_position),
                                 .reset_counters(reset_counters),
                                 .is_enemy(is_enemy),
                                 .can_goto_new_position(can_goto_new_position),
                                 .grid_counter_max(grid_counter_max),
                                 .update_enemy_start(update_enemy_start));

endmodule

module _enemy_updater_fsm(clock, reset,
                          start, done,
                          increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, reset_counters,
                          is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start);
    input clock, reset;
    input start;
    output done;

    // FSM controls
    output increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, reset_counters;
    input is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start;

    // Initialize FSM
    wire initialize;
    assign initialize = start && update_enemy_start;

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam WAIT                    = 4'd0,
               INITIALIZE              = 4'd1,
               CHECK_IF_ENEMY          = 4'd2,
               CHECK_POSSIBLE_POSITION = 4'd3,
               DRAW_NEW_POSITION       = 4'd4,
               ERASE_LAST_POSITION     = 4'd5,
               CHECK_DONE              = 4'd6,
               INCREMENT               = 4'd7,
               DONE                    = 4'd8;


    // Transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:                    state <= initialize ? INITIALIZE : WAIT;
                INITIALIZE:              state <= CHECK_IF_ENEMY;
                CHECK_IF_ENEMY:          state <= is_enemy ? CHECK_POSSIBLE_POSITION : CHECK_DONE;
                CHECK_POSSIBLE_POSITION: state <= can_goto_new_position ? DRAW_NEW_POSITION : CHECK_DONE;
                DRAW_NEW_POSITION:       state <= ERASE_LAST_POSITION;
                ERASE_LAST_POSITION:     state <= CHECK_DONE;
                CHECK_DONE:              state <= grid_counter_max ? DONE : INCREMENT;
                INCREMENT:               state <= CHECK_IF_ENEMY;
                DONE:                    state <= WAIT;
                default:                 state <= WAIT;
            endcase
        end
    end

    // Output signal logic
    assign increment_grid_counter = state == INCREMENT;
    assign check_possible_position = state == CHECK_POSSIBLE_POSITION;
    assign draw_new_position = state == DRAW_NEW_POSITION;
    assign erase_last_position = state == ERASE_LAST_POSITION;
    assign reset_counters = state == INITIALIZE;
endmodule


module _enemy_updater_datapath(clock, reset
                               grid_x, grid_y, grid_out, grid_write, grid_in,
                               increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, reset_counters,
                               is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start);
     input clock, reset;

     // Values of the counters
     output [5:0] grid_x;
     output [4:0] grid_y;
     // Check this for enemy (binary-value of 4)
     input [2:0] grid_out;
     output grid_write;
     output [2:0] grid_in;

     // FSM controls
     input increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, reset_counters;
     output is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start;


     // update_enemy_start: Check for whether enemies should be updated or not
     reg [31:0] check_counter;
     reg update_enemy_start;
     always @(posedge clock) begin
      // Counter starts again when we've redrawn the enemies
       if (reset_counters) begin
          update_enemy_start <= 0;
          check_counter <= 32'd200000;
       end
       if (check_counter != 32'b0)
          begin
              check_counter <= check_counter - 32'b1;
          end
       else begin
          update_enemy_start <= 1;
          check_counter <= 32'd200000;
       end
     end

     // is_enemy: Check whether the position in the grid is an enemy
     assign is_enemy = grid_out == 3'd4;

     // Who gets grid access: Checking possible position, draw new position, erase last position
     always @(posedge clock) begin
       if (check_possible_position) begin
         assign grid_x = grid_x + 1;
         assign right_grid_in = grid_in;
         assign can_goto_new_position = right_grid_in == 3'd0;
       end
       else if (draw_new_position) begin
          assign grid_x
       end
       else if (erase_last_position) begin
       end
     end

     // grid_counter_max:
     assign grid_counter_max = x_at_max & y_at_max;

     // Counter logic
     // Counters for iterating through grid
     reg [5:0] grid_x;
     reg [4:0] grid_y;
     wire x_at_max;
     wire y_at_max;
     assign x_at_max = grid_x == 6'd39;
     assign y_at_max = grid_y == 5'd29;
     always @(posedge clock) begin
       if (reset_counters | reset) begin
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

endmodule
