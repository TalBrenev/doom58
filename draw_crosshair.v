module draw_crosshair(clock, reset,
                      start, done,
                      center_x, center_y,
                      vga_x, vga_y, vga_colour, vga_write);

    // Global clock and reset
    input clock;
    input reset;

    // External control signals
    input start;
    output done;

    // The center of the crosshair to be drawn
    // IMPORTANT NOTE: This is already in pixels, i.e. the location on the VGA display
    input [7:0] center_x;
    input [6:0] center_y;

    // Signals to the VGA adapter
    output reg [7:0] vga_x;
    output reg [6:0] vga_y;
    output reg [17:0] vga_colour;
    output reg vga_write;

    /* **************** FSM ****************** */

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam WAIT            = 4'd0,
               INITIALIZE      = 4'd1,
               DRAW_MIDDLE     = 4'd2, // draw the middle square
               WAIT_MIDDLE     = 4'd3, // wait for the VGA to draw the middle square
               DRAW_TOP        = 4'd4,
               WAIT_TOP        = 4'd5,
               DRAW_RIGHT      = 4'd6,
               WAIT_RIGHT      = 4'd7,
               DRAW_BOTTOM     = 4'd8,
               WAIT_BOTTOM     = 4'd9,
               DRAW_LEFT       = 4'd10,
               WAIT_LEFT       = 4'd11,
               DONE            = 4'd12;

    // state assignments
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:            state <= start ? INITIALIZE : WAIT;
                DRAW_MIDDLE:     state <= WAIT_MIDDLE;
                WAIT_MIDDLE:     state <= draw_square_done ? DRAW_TOP : WAIT_MIDDLE;
                DRAW_TOP:        state <= WAIT_MIDDLE;
                WAIT_TOP:        state <= draw_square_done ? DRAW_RIGHT : WAIT_MIDDLE;
                DRAW_RIGHT:      state <= WAIT_MIDDLE;
                WAIT_RIGHT:      state <= draw_square_done ? DRAW_BOTTOM : WAIT_MIDDLE;
                DRAW_BOTTOM:     state <= WAIT_MIDDLE;
                WAIT_BOTTOM:     state <= draw_square_done ? DRAW_LEFT : WAIT_MIDDLE;
                DRAW_LEFT:       state <= WAIT_MIDDLE;
                WAIT_LEFT:       state <= draw_square_done ? DRAW_DONE : WAIT_MIDDLE;
                DONE:            state <= WAIT;
                default:         state <= WAIT;
            endcase
        end
    end

    // output signal logic
    assign done = state == DONE;

    // tell the vga when we want to draw to it
    wire draw_square_done;
    assign draw_square = (state == DRAW_MIDDLE) || (state == DRAW_TOP) || (state == DRAW_RIGHT) || (state == DRAW_BOTTOM) || (state == DRAW_LEFT);

    /* ************** DATAPATH *************** */
    // decide which pixel to draw to

    // where we are drawing to
    reg [7:0] drawing_x;
    reg [6:0] drawing_y;

    // this implementation could potentially overflow
    // will not happen so long as all edges of the map are surrounded by walls 
    always @(*) begin
        case (state)
        DRAW_MIDDLE:
            begin
                drawing_x[7:0] = center_x;
                drawing_y[6:0] = center_y;
            end
        DRAW_TOP:
            begin
                drawing_x[7:0] = center_x;
                drawing_y[6:0] = center_y - 1;
            end
        DRAW_RIGHT:
            begin
                drawing_x[7:0] = center_x + 1;
                drawing_y[6:0] = center_y;
            end
        DRAW_BOTTOM:
            begin
                drawing_x[7:0] = center_x;
                drawing_y[6:0] = center_y + 1;
            end
        DRAW_LEFT:
            begin
                drawing_x[7:0] = center_x - 1;
                drawing_y[6:0] = center_y;
            end
        default:
            begin
                drawing_x[7:0] = center_x;
                drawing_y[6:0] = center_y;
            end
        endcase
    end

    // TODO we have the pixels which we want to draw on, now we just need to draw to them.



    
endmodule
