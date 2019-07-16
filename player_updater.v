module player_updater(clock, reset,
                     start, done,
                     turn_right, turn_left, move_forward, move_backward,
                     cur_pos_x, cur_pos_y, cur_angle,
                     next_pos_x, next_pos_y, next_angle,
                     grid_x, grid_y, grid_out);
   input clock;
   input reset;

   wire slow_clock;
   rate_divider(clock, slow_clock, 2'b01); // 25fps clock

   input start;
   output done;

   // input will come through the keyboard input
   input turn_right; // right
   input turn_left; // left
   input move_forward; // up
   input move_backward; // down

   // Current player position and angle
   input [13:0] cur_pos_x;
   input [12:0] cur_pos_y;
   input [7:0] cur_angle;

   // Next player position and angle
   output [13:0] next_pos_x;
   output [12:0] next_pos_y;
   output [7:0] next_angle;

   output [5:0] grid_x;
   output [4:0] grid_y;
   input [2:0] grid_out;

   always @(posedge slow_clock) begin
       
   end

   // TODO: Keyboard inputs
endmodule
