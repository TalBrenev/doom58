module draw_grid(clock, reset,
                 start, done,
                 grid_x, grid_y, grid_out,
                 vga_x, vga_y, vga_colour, vga_write);
    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // Signals to/from the grid memory
    output [6:0] grid_x;
    output [5:0] grid_y;
    input [2:0] grid_out;

    // Signals to the VGA adapter
    output [8:0] vga_x;
    output [7:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    wire reset_counter, increment_counter, draw_square, counter_at_max, draw_square_done;
    _draw_grid_fsm dgf0 (.clock(clock),
                         .reset(reset),
                         .start(start),
                         .done(done),
                         .reset_counter(reset_counter),
                         .increment_counter(increment_counter),
                         .draw_square(draw_square),
                         .counter_at_max(counter_at_max),
                         .draw_square_done(draw_square_done));
    _draw_grid_datapath dgd0 (.clock(clock),
                              .reset(reset),
                              .grid_x(grid_x),
                              .grid_y(grid_y),
                              .grid_out(grid_out),
                              .vga_x(vga_x),
                              .vga_y(vga_y),
                              .vga_colour(vga_colour),
                              .vga_write(vga_write),
                              .reset_counter(reset_counter),
                              .increment_counter(increment_counter),
                              .draw_square(draw_square),
                              .counter_at_max(counter_at_max),
                              .draw_square_done(draw_square_done));
endmodule

module _draw_grid_fsm(clock, reset,
                      start, done,
                      reset_counter, increment_counter, draw_square, counter_at_max, draw_square_done);
    // Global clock and reset
    input clock;
    input reset;

    // External controls
    input start;
    output done;

    // Controls to datapath
    output reset_counter;
    output increment_counter;
    output draw_square;
    input counter_at_max;
    input draw_square_done;

    // State register
    reg [2:0] state;

    // Flip-flop assignments
    localparam WAIT            = 3'd0,
               INITIALIZE      = 3'd1,
               DRAW_SQUARE     = 3'd2,
               WAIT_FOR_SQUARE = 3'd3,
               INCREMENT       = 3'd4,
               DONE            = 3'd5;

    // Transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:            state <= start ? INITIALIZE : WAIT;
                INITIALIZE:      state <= DRAW_SQUARE;
                DRAW_SQUARE:     state <= WAIT_FOR_SQUARE;
                WAIT_FOR_SQUARE: state <= draw_square_done ? (counter_at_max ? DONE : INCREMENT) : WAIT_FOR_SQUARE;
                INCREMENT:       state <= DRAW_SQUARE;
                DONE:            state <= WAIT;
                default:         state <= WAIT;
            endcase
        end
    end

    // Output signal logic
    assign reset_counter = state == INITIALIZE;
    assign increment_counter = state == INCREMENT;
    assign draw_square = state == DRAW_SQUARE;
    assign done = state == DONE;
endmodule

module _draw_grid_datapath(clock, reset,
                           grid_x, grid_y, grid_out,
                           vga_x, vga_y, vga_colour, vga_write,
                           reset_counter, increment_counter, draw_square, counter_at_max, draw_square_done);
    // Global clock and reset
    input clock;
    input reset;

    // Signals to/from the grid memory
    output [6:0] grid_x;
    output [5:0] grid_y;
    input [2:0] grid_out;

    // Signals to the VGA adapter
    output [8:0] vga_x;
    output [7:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    // FSM controls
    input reset_counter;
    input increment_counter;
    input draw_square;
    output counter_at_max;
    output draw_square_done;

    // Counter for iterating through grid
    reg [12:0] counter;
    assign grid_x = counter[12:6];
    assign grid_y = counter[5:0];

    // Counter logic
    always @(posedge clock) begin
        if (reset_counter | reset) begin
            counter <= 13'b0;
        end
        else if (increment_counter) begin
            counter <= counter + 1;
        end
    end
    assign counter_at_max = &counter;

    // Square drawing
    draw_square ds0 (.clock(clock),
                     .reset(reset),
                     .start(draw_square),
                     .done(draw_square_done),
                     .x({2'b0, grid_x * 3'd4}),
                     .y({2'b0, grid_y * 3'd4}),
                     .colour(grid_out),
                     .vga_x(vga_x),
                     .vga_y(vga_y),
                     .vga_colour(vga_colour),
                     .vga_write(vga_write));
endmodule
