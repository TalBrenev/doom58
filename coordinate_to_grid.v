module coordinate_to_grid(coord_x, coord_y, grid_x, grid_y);
    input [13:0] coord_x;
    input [12:0] coord_y;

    // assume that grid squares are of size 256
    // this divIdes the coords by 256 since log2(256) = 8
    assign grid_x = coord_x[13:8];
    assign grid_y = coord_y[13:9];

    output [5:0] grid_x;
    output [4:0] grid_y;
endmodule
