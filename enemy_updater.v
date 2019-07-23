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
    wire increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, get_next_position, check_if_enemy, reset_counters;
    wire is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start;
    _enemy_updater_fsm euf0(.clock(clock),
                            .reset(reset),
                            .start(start),
                            .done(done),
                            .increment_grid_counter(increment_grid_counter),
                            .check_possible_position(check_possible_position),
                            .draw_new_position(draw_new_position),
                            .erase_last_position(erase_last_position),
                            .get_next_position(get_next_position),
                            .check_if_enemy(check_if_enemy),
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
                                 .get_next_position(get_next_position),
                                 .check_if_enemy(check_if_enemy),
                                 .reset_counters(reset_counters),
                                 .is_enemy(is_enemy),
                                 .can_goto_new_position(can_goto_new_position),
                                 .grid_counter_max(grid_counter_max),
                                 .update_enemy_start(update_enemy_start));

endmodule

module _enemy_updater_fsm(clock, reset,
                          start, done,
                          increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, get_next_position, check_if_enemy, reset_counters,
                          is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start);
    input clock, reset;
    input start;
    output done;

    // FSM controls
    output increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, get_next_position, check_if_enemy, reset_counters;
    input is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start;

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam WAIT                    = 4'd0,
               INITIALIZE              = 4'd1,
               ENEMY_CAN_BE_CHECKED    = 4'd10,
               CHECK_IF_ENEMY          = 4'd2,
               GET_NEXT_POSITION       = 4'd3,
               CHECK_POSSIBLE_POSITION = 4'd4,
               DRAW_NEW_POSITION       = 4'd5,
               ERASE_LAST_POSITION     = 4'd6,
               CHECK_DONE              = 4'd7,
               INCREMENT               = 4'd8,
               DONE                    = 4'd9;


    // Transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:                    state <= start ? ENEMY_CAN_BE_CHECKED : WAIT;
                ENEMY_CAN_BE_CHECKED:    state <= update_enemy_start ? INITIALIZE : DONE;
                INITIALIZE:    			     state <= CHECK_IF_ENEMY;
                CHECK_IF_ENEMY:          state <= is_enemy ? GET_NEXT_POSITION : CHECK_DONE;
                GET_NEXT_POSITION:       state <= CHECK_POSSIBLE_POSITION;
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
    assign get_next_position = state == GET_NEXT_POSITION;
    assign check_if_enemy = state == CHECK_IF_ENEMY;
    assign draw_new_position = state == DRAW_NEW_POSITION;
    assign erase_last_position = state == ERASE_LAST_POSITION;
    assign reset_counters = state == INITIALIZE;
    assign done = state == DONE;
endmodule


module _enemy_updater_datapath(clock, reset,
                               grid_x, grid_y, grid_out, grid_write, grid_in,
                               increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, get_next_position, check_if_enemy, reset_counters,
                               is_enemy, can_goto_new_position, grid_counter_max, update_enemy_start);
     input clock, reset;

     output reg [5:0] grid_x;
     output reg [4:0] grid_y;
     input [2:0] grid_out; // grid value at (x, y)
     output reg grid_write;
     output reg [2:0] grid_in;

     // FSM controls
     input increment_grid_counter, check_possible_position, draw_new_position, erase_last_position, get_next_position, check_if_enemy, reset_counters;
     output reg is_enemy, can_goto_new_position, update_enemy_start;
	   output grid_counter_max;


     // update_enemy_start: Check for whether enemies should be updated or not
     reg [31:0] check_counter;
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
       end
     end

     // is_enemy: Check whether the position in the grid is an enemy
     always @(posedge clock) begin
        if (check_if_enemy)
          is_enemy = grid_out == 3'd4;
     end

     // get_next_position: Updates register for next grid_x and grid_y based on
     // "random" 4-bit counter (up, right, down, left). Don't need to check if
     // this new value is within bounds of the grid because surrounded by walls.
     // Store current grid_x and grid_y in registers to use them later

     // 2-bit Counter
     reg [1:0] direction_counter;
     always @(posedge clock) begin
        if (direction_counter == 2'd3)
            direction_counter <= 2'd0;
        else
            direction_counter <= direction_counter + 1;
     end

     reg [5:0] curr_grid_x;
     reg [4:0] curr_grid_y;
     reg [5:0] next_grid_x;
     reg [4:0] next_grid_y;
     always @(posedge clock) begin
        if (get_next_position) begin
          curr_grid_x = counter_x;
          curr_grid_y = counter_y;
          // Up
          if (direction_counter == 2'd0) begin
            next_grid_x = curr_grid_x;
            next_grid_y = curr_grid_y - 1;
          end
          // Right
          if (direction_counter == 2'd1) begin
            next_grid_x = curr_grid_x + 1;
            next_grid_y = curr_grid_y;
          end
          // Down
          if (direction_counter == 2'd2) begin
            next_grid_x = curr_grid_x;
            next_grid_y = curr_grid_y + 1;
          end
          // Left
          if (direction_counter == 2'd3) begin
            next_grid_x = curr_grid_x - 1;
            next_grid_y = curr_grid_y;
          end
        end
     end

     // Who gets grid access: Checking possible position, draw new position, erase last position
     always @(posedge clock) begin
      // Counter
       if (reset_counters | reset) begin
           counter_x <= 6'b0;
           counter_y <= 5'b0;
       end
		   else if (increment_grid_counter) begin
           if (x_at_max) begin
               counter_x <= 0;
               counter_y <= counter_y + 1;
           end
           else
               counter_x <= counter_x + 1;
       end
		   // Check if next position is air
       else if (check_possible_position) begin
         grid_x <= next_grid_x;
         grid_y <= next_grid_y;
         can_goto_new_position <= grid_out == 3'd0;
       end
       // Write next position as enemy
       else if (draw_new_position) begin
         grid_x <= next_grid_x;
         grid_y <= next_grid_y;
         grid_write <= 1;
         grid_in <= 3'd4;
       end
       // Write current position as air
       else if (erase_last_position) begin
         grid_x <= curr_grid_x;
         grid_y <= curr_grid_y;
         grid_write <= 1;
         grid_in <= 3'd0;
       end
       else
         grid_write <= 0;
     end

     // All enemies have been checked
     assign grid_counter_max = x_at_max & y_at_max;

     // Counter logic
     // Counters for iterating through grid
     reg [5:0] counter_x;
     reg [4:0] counter_y;
     wire x_at_max;
     wire y_at_max;
     assign x_at_max = counter_x == 6'd39;
     assign y_at_max = counter_y == 5'd29;

endmodule
