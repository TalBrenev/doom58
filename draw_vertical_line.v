module draw_vertical_line(clock, reset,
                          start, done,
                          x, min_y, max_y, colour,
                          vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // Inputs
    input [7:0] x;        // Horizontal position of line
    input [6:0] max_y;    // Starting y-coordinates
    input [6:0] min_y;    // Ending y-coordinate
    input [17:0] colour;  // Colour of line

    // Signals to the VGA adapter
    output reg [7:0] vga_x;
    output reg [6:0] vga_y;
    output reg [17:0] vga_colour;
    output vga_write;


    reg [2:0] state;

    // Flip-flop assignments
    localparam WAIT          = 3'd0,
               INITIALIZE    = 3'd1,
               UPDATE          = 3'd2, // draw the middle square
               DRAW        = 3'd3,
               INCREMENT     = 3'd4, // wait for the VGA to draw the middle square
               DONE          = 3'd5;

    // state assignments
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:            state <= start ? INITIALIZE : WAIT;
                INITIALIZE:      state <= UPDATE;

                UPDATE:          state <= DRAW;
                DRAW:            state <= INCREMENT;
                INCREMENT:       state <= (curr_y < max_y) ? UPDATE : DONE;

                DONE:            state <= WAIT;
                default:         state <= WAIT;
            endcase
        end
    end

    // local values
    reg [6:0] curr_y;

    // output signal logic
    assign done = state == DONE;
    assign vga_write = state == DRAW;

    /* -----------DATAPATH------------ */

    always @(posedge clock) begin
        case (state)
        INITIALIZE:
            begin
                curr_y <= min_y;
            end

        UPDATE:
            begin
                vga_x[7:0] <= x;
                vga_y[6:0] <= curr_y;
                vga_colour <= colour;
            end

        INCREMENT:
            begin
                 curr_y <= curr_y + 1;
            end
        
        default:
            begin
                vga_x <= x;
                vga_y <= curr_y;
                vga_colour <= colour;
            end
        endcase
    end

endmodule
