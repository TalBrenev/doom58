module player_updater(clock, reset,
                     start, done,
                     turn_right, turn_left, move_forward, move_backward,
                     cur_pos_x, cur_pos_y, cur_angle,
                     next_pos_x, next_pos_y, next_angle,
                     grid_x, grid_y, grid_out);
   input clock;
   input reset;

   input start;
   output reg done;

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
   input [15:0] cur_pos_x;
   input [14:0] cur_pos_y;
   input [7:0] cur_angle;

   // Next player position and angle
   output reg [15:0] next_pos_x;
   output reg [14:0] next_pos_y;
   output reg [7:0] next_angle;
	
	// convert to grid coordinates
   output [5:0] grid_x;
   output [4:0] grid_y;
   input [2:0] grid_out;
	coordinate_to_grid var1 (cur_pos_x [14:0], cur_pos_y[13:0], grid_x[5:0], grid_y[4:0]);
	
	// get direction vector
	wire [15:0] direction_x;
	wire [14:0] direction_y;
	bytian_to_vector var2 (cur_angle, direction_x[14:0], direction_y[13:0]);
	
	/*
		1 get theoretical location
		2 send grid_x and grid_y as 
		3 get grid_out (what type of thing the block is)
		4 move iff the grid_out is 0 (nothing there)
	*/
	
	localparam  WAIT				  = 4'b0001, // wait until we are told to sample again
					PREDICT_LOCATION = 4'b0011, // get where they are moving to
					SEND_COORD 		  = 4'b0010, // send to the main module where we want to move
					GET_COORD  		  = 4'b0110, // store the type of the coordinate
					MOVE				  = 4'b0100, // move only if the coordinate is uninhabited
					DONE				  = 4'b0101; // signal that we are done
					
	reg [3:0] cur_state, next_state;
	always @(*) begin // state stable
		case (cur_state)
		WAIT: next_state = start && (counter[19:0] == 0) ? PREDICT_LOCATION : WAIT;
		PREDICT_LOCATION: next_state = SEND_COORD;
		SEND_COORD: next_state = GET_COORD;
		GET_COORD: next_state = MOVE;
		MOVE: next_state = DONE;
		DONE: next_state = WAIT;
		default: next_state = WAIT;
		endcase
	end
	
	always @(posedge clock) begin
		cur_state = next_state;
		counter = counter + 1;
	end

	reg [15:0] temp_pos_x;
	reg [14:0] temp_pos_y;
	reg [7:0] temp_angle;
	
	always @(*) begin
	case (cur_state)

		PREDICT_LOCATION:
			begin
			done = 1'b0;
			case (movement)
				RIGHT: begin 
					temp_angle = cur_angle + {4'b0, turn_speed}; 
					temp_pos_x = cur_pos_x;
					temp_pos_y = cur_pos_y;
				end
				LEFT: begin 
					temp_angle = cur_angle - {4'b0, turn_speed}; 
					temp_pos_x = cur_pos_x;
					temp_pos_y = cur_pos_y;
				end
				UP: begin 
					temp_angle = cur_angle; 
					temp_pos_x = cur_pos_x + direction_x;
					temp_pos_y = cur_pos_y + direction_y;
				end
				DOWN: begin
					temp_angle = cur_angle; 
					temp_pos_x = cur_pos_x - direction_x;
					temp_pos_y = cur_pos_y - direction_y;
				end
				default: begin
					temp_angle = cur_angle;
					temp_pos_x = cur_pos_x;
					temp_pos_y = cur_pos_y;
				end
			endcase
		end
		MOVE: 
			begin
			case (grid_out)
			3'b000: begin
					next_angle = temp_angle;
					next_pos_x = temp_pos_x;
					next_pos_y = temp_pos_y;
				end
			default: begin
					next_angle = cur_angle;
					next_pos_x = cur_pos_x;
					next_pos_y = cur_pos_y;
				end
			endcase
		end
		
		DONE: begin
			done <= 1'b1;
		end

		default: begin
			done <= 1'b1;
		end

	endcase
	end
	
	localparam turn_speed = 4'd10;
	reg [31:0] counter;

   // TODO: Keyboard inputs
endmodule
