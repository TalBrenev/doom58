module coordinate_to_grid(coord_x, coord_y, grid_x, grid_y);
    input [13:0] coord_x;
    input [12:0] coord_y;

    output [5:0] grid_x;
    output [4:0] grid_y;
endmodule
