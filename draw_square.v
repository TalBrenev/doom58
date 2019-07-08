module draw_square(clock, reset,
                   start, done,
                   x, y, colour,
                   vga_x, vga_y, vga_colour, vga_write);
    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // The top-left corner and color of the square to draw
    input [7:0] x;
    input [6:0] y;
    input [2:0] colour;

    // Outputs to the VGA adapter
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;
    output vga_write;

    wire load, reset_counter, increment_counter, add_offset, counter_at_max;
    _draw_square_datapath dsd0 (.clock(clock),
                                .reset(reset),
                                .x(x),
                                .y(y),
                                .colour(colour),
                                .vga_x(vga_x),
                                .vga_y(vga_y),
                                .vga_colour(vga_colour),
                                .load(load),
                                .reset_counter(reset_counter),
                                .increment_counter(increment_counter),
                                .add_offset(add_offset),
                                .counter_at_max(counter_at_max));
    _draw_square_fsm dsf0 (.clock(clock),
                           .reset(reset),
                           .start(start),
                           .done(done),
                           .load(load),
                           .reset_counter(reset_counter),
                           .increment_counter(increment_counter),
                           .add_offset(add_offset),
                           .vga_write(vga_write),
                           .counter_at_max(counter_at_max));
endmodule

module _draw_square_fsm(clock, reset,
                        start, done,
                        load, reset_counter, increment_counter, add_offset, vga_write, counter_at_max);
    // Global clock and reset
    input clock;
    input reset;

    // External controls
    input start;
    output done;

    // Controls to datapath
    output load;
    output reset_counter;
    output increment_counter;
    output add_offset;
    output vga_write;
    input counter_at_max;

    // State register
    reg [2:0] state;

    // Flip-flop assignments
    localparam WAIT       = 3'd0,
               INITIALIZE = 3'd1,
               ADD_OFFSET = 3'd2,
               WRITE_VGA  = 3'd3,
               INCREMENT  = 3'd4,
               DONE       = 3'd5;

    // Transition table
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:        state <= start ? INITIALIZE : WAIT;
                INITIALIZE:  state <= ADD_OFFSET;
                ADD_OFFSET:  state <= WRITE_VGA;
                WRITE_VGA:   state <= counter_at_max ? DONE : INCREMENT;
                INCREMENT:   state <= ADD_OFFSET;
                DONE:        state <= WAIT;
                default:     state <= WAIT;
            endcase
        end
    end

    // Output signal logic
    assign load = state == INITIALIZE;
    assign reset_counter = state == INITIALIZE;
    assign add_offset = state == ADD_OFFSET;
    assign vga_write = state == WRITE_VGA;
    assign increment_counter = state == INCREMENT;
    assign done = state == DONE;
endmodule

module _draw_square_datapath(clock, reset,
                             x, y, colour,
                             vga_x, vga_y, vga_colour,
                             load, reset_counter, increment_counter, add_offset, counter_at_max);
    input clock;
    input reset;

    // Top-left corner of square and its colour
    input [7:0] x;
    input [6:0] y;
    input [2:0] colour;

    // Wires to vga
    output [7:0] vga_x;
    output [6:0] vga_y;
    output [2:0] vga_colour;

    // FSM controls
    input load;
    input reset_counter;
    input increment_counter;
    input add_offset;
    output counter_at_max;

    // Stores top-left corner of square
    reg [7:0] x_base;
    reg [6:0] y_base;

    // Stores current vga pixel and colour to write
    reg [7:0] vga_x;
    reg [6:0] vga_y;
    reg [2:0] vga_colour;

    // Counter
    reg [3:0] counter;
    wire [1:0] x_offset;
    wire [1:0] y_offset;
    assign x_offset = counter[1:0];
    assign y_offset = counter[3:2];

    // Input and output logic
    always @(posedge clock) begin
        if (reset) begin
            x_base <= 8'b0;
            y_base <= 7'b0;
            vga_x <= 8'b0;
            vga_y <= 7'b0;
            vga_colour <= 3'b0;
        end
        else begin
            if (load) begin
              x_base <= x;
              y_base <= y;
              vga_colour <= colour;
            end
            if (add_offset) begin
                vga_x <= x_base + {6'b0, x_offset};
                vga_y <= y_base + {5'b0, y_offset};
            end
        end
    end

    // Counter logic
    always @(posedge clock) begin
        if (reset_counter | reset) begin
            counter <= 4'b0;
        end
        else if (increment_counter) begin
            counter <= counter + 1;
        end
    end
    assign counter_at_max = &counter;
endmodule
