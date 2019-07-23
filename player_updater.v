module player_updater(clock, reset,
                     start, done,
                     turn_right, turn_left, move_forward, move_backward,
                     cur_pos_x, cur_pos_y, cur_angle,
                     next_pos_x, next_pos_y, next_angle,
                     grid_x, grid_y, grid_out);
    input clock;
    input reset;

    input start;
    output done;

    // input will come through the keyboard input
    input turn_right; // right
    input turn_left; // left
    input move_forward; // up
    input move_backward; // down
    wire [3:0] movement;
    assign movement = {turn_right, turn_left, move_forward, move_backward};
    localparam RIGHT = 4'b1000,
               LEFT = 4'b0100,
               UP = 4'b0010,
               DOWN = 4'b0001;

    // Current player position and angle
    input [13:0] cur_pos_x;
    input [12:0] cur_pos_y;
    input [7:0] cur_angle;

    // Next player position and angle
    output reg [13:0] next_pos_x;
    output reg [12:0] next_pos_y;
    output reg [7:0] next_angle;

    // convert to grid coordinates
    output [5:0] grid_x;
    output [4:0] grid_y;
    input [2:0] grid_out;
    coordinate_to_grid var1 (temp_pos_x, temp_pos_y, grid_x, grid_y);

    // get direction vector
    wire [14:0] direction_x;
    wire [13:0] direction_y;
    bytian_to_vector var2 (cur_angle, direction_x, direction_y);

    localparam turn_speed = 4'd2;
    localparam counter_length = 32'd5000000;
    reg [31:0] counter;

    /* **************** FSM *********************
        1 get theoretical location
        2 send grid_x and grid_y as
        3 get grid_out (what type of thing the block is)
        4 move iff the grid_out is 0 (nothing there)
    */

    reg [3:0] cur_state;

    localparam  WAIT             = 4'b0001, // wait until we are told to sample again
                WAIT_FOR_CLOCK   = 4'b0010,
                PREDICT_LOCATION = 4'b0011, // get where they are moving to
                MOVE             = 4'b0100, // move only if the coordinate is uninhabited
                DONE             = 4'b0101; // signal that we are done

    always @(posedge clock) begin
        if (reset)
            cur_state <= WAIT;
        else begin
            case (cur_state)
                WAIT:              cur_state <= start ? WAIT_FOR_CLOCK : WAIT;
                WAIT_FOR_CLOCK:    cur_state <= (counter == 0) ? PREDICT_LOCATION : DONE;
                PREDICT_LOCATION:  cur_state <= MOVE;
                MOVE:              cur_state <= DONE;
                DONE:              cur_state <= WAIT;
                default:           cur_state <= WAIT;
            endcase
        end
    end

    // Counter and state logic
    always @(posedge clock) begin
        if (reset)
            counter <= 0;

        else if (counter != 0)
            counter <= counter - 1;

        else if (cur_state == PREDICT_LOCATION) // reset the counter every time we make a move
            counter <= counter_length;
    end

    /***********DATAPATH***************/

    reg [13:0] temp_pos_x;
    reg [12:0] temp_pos_y;
    reg [7:0] temp_angle;

    assign done = cur_state == DONE;

    always @(posedge clock) begin
        if (reset) begin // reset everything in the datapath to zero if we get the reset signal
            temp_angle <= cur_angle;
            next_angle <= cur_angle;
            temp_pos_x <= cur_pos_x;
            next_pos_x <= cur_pos_x;
            temp_pos_y <= cur_pos_y;
            next_pos_y <= cur_pos_y;
        end

        else begin
            case (cur_state)
                PREDICT_LOCATION: begin
                    case (movement)
                        RIGHT: begin
                            temp_angle <= cur_angle + {4'b0, turn_speed};
                            temp_pos_x <= cur_pos_x;
                            temp_pos_y <= cur_pos_y;
                        end
                        LEFT: begin
                            temp_angle <= cur_angle - {4'b0, turn_speed};
                            temp_pos_x <= cur_pos_x;
                            temp_pos_y <= cur_pos_y;
                        end
                        UP: begin
                            temp_angle <= cur_angle;
                            temp_pos_x <= cur_pos_x + direction_x[13:0];
                            temp_pos_y <= cur_pos_y + direction_y[12:0];
                        end
                        DOWN: begin
                            temp_angle <= cur_angle;
                            temp_pos_x <= cur_pos_x - direction_x[13:0];
                            temp_pos_y <= cur_pos_y - direction_y[12:0];
                        end
                        default: begin
                            temp_angle <= cur_angle;
                            temp_pos_x <= cur_pos_x;
                            temp_pos_y <= cur_pos_y;
                        end
                    endcase
                end

                MOVE: begin
                    next_angle <= temp_angle;
                    case (grid_out)
                        3'b000: begin
                            next_pos_x <= temp_pos_x;
                            next_pos_y <= temp_pos_y;
                        end
                        default: begin
                            next_pos_x <= cur_pos_x;
                            next_pos_y <= cur_pos_y;
                        end
                    endcase
                end

                default: begin
                    next_angle <= next_angle;
                    next_pos_x <= next_pos_x;
                    next_pos_y <= next_pos_y;
                end
            endcase
        end
    end
endmodule
