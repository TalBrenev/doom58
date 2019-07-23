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
    output [17:0] vga_colour; assign vga_colour = 18'b000111000111000111;
    output vga_write;

    /* **************** FSM ****************** */

    // State register
    reg [3:0] state;

    // Flip-flop assignments
    localparam WAIT          = 4'd0,
               INITIALIZE    = 4'd1,
               DRAW_MIDDLE   = 4'd2, // draw the middle square
               UPDATE_MIDDLE = 4'd3, // wait for the VGA to draw the middle square
               DRAW_TOP      = 4'd4,
               UPDATE_TOP    = 4'd5,
               DRAW_RIGHT    = 4'd6,
               UPDATE_RIGHT  = 4'd7,
               DRAW_BOTTOM   = 4'd8,
               UPDATE_BOTTOM = 4'd9,
               DRAW_LEFT     = 4'd10,
               UPDATE_LEFT   = 4'd11,
               DONE          = 4'd12;

    // state assignments
    always @(posedge clock) begin
        if (reset)
            state <= WAIT;
        else begin
            case (state)
                WAIT:            state <= start ?  UPDATE_MIDDLE : WAIT;

                UPDATE_MIDDLE:   state <= DRAW_MIDDLE;
                DRAW_MIDDLE:     state <= UPDATE_TOP;

                UPDATE_TOP:      state <= DRAW_TOP;
                DRAW_TOP:        state <= UPDATE_RIGHT;

                UPDATE_RIGHT:    state <= DRAW_RIGHT;
                DRAW_RIGHT:      state <= UPDATE_BOTTOM;

                UPDATE_BOTTOM:   state <= DRAW_BOTTOM;
                DRAW_BOTTOM:     state <= UPDATE_LEFT;

                UPDATE_LEFT:     state <= DRAW_LEFT;
                DRAW_LEFT:       state <= DONE;

                DONE:            state <= WAIT;
                default:         state <= WAIT;
            endcase
        end
    end

    // output signal logic
    assign done = state == DONE;

    assign vga_write = (state == DRAW_MIDDLE) || (state == DRAW_TOP) || (state == DRAW_RIGHT) || (state == DRAW_BOTTOM) || (state == DRAW_LEFT);

    /* ************** DATAPATH *************** */
    // decide which pixel to draw to

    // this implementation could potentially overflow
    // will not happen so long as all edges of the map are surrounded by walls
    always @(*) begin
        case (state)
        UPDATE_MIDDLE:
            begin
                vga_x[7:0] = center_x;
                vga_y[6:0] = center_y;
            end
        UPDATE_TOP:
            begin
                vga_x[7:0] = center_x;
                vga_y[6:0] = center_y - 1;
            end
        UPDATE_RIGHT:
            begin
                vga_x[7:0] = center_x + 1;
                vga_y[6:0] = center_y;
            end
        UPDATE_BOTTOM:
            begin
                vga_x[7:0] = center_x;
                vga_y[6:0] = center_y + 1;
            end
        UPDATE_LEFT:
            begin
                vga_x[7:0] = center_x - 1;
                vga_y[6:0] = center_y;
            end
        default:
            begin
                vga_x[7:0] = center_x;
                vga_y[6:0] = center_y;
            end
        endcase
    end
endmodule
