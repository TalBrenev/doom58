module enemy_updater(clock, reset,
                     start, done,
                     grid_x, grid_y, grid_out, grid_write, grid_in);
    input clock;
    input reset;

    input start;
    output done;

    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;
    output grid_write;
    output [2:0] grid_in;
endmodule
