module player_updater(clock, reset,
                      start, done,
                      player_x, player_y,
                      result_x, result_y,
                      grid_x, grid_y, grid_out);
    input clock;
    input reset;

    input [13:0] player_x;
    input [12:0] player_y;

    output [13:0] result_x;
    output [12:0] result_y;

    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;

    // TODO: Keyboard inputs
endmodule
