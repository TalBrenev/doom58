module enemy_updater(clock, reset,
                     start, done,
                     grid_x, grid_y, grid_out, grid_write, grid_in);
    // 50MHZ to 25Hz using rateDivider
    input clock;
    input reset;

    input start;
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

     // Update enemy logic
     always @(posedge clock) begin
     end

     // Counter logic
     always @(posedge clock) begin
     end

endmodule
