module rate_divider(CLOCK_50, slow_clock, select);
    /*
        Turns the fast 50 MHz clock into a reasonable speed
        select bits decide how fast to make the clock

        00 -- 50 MHz
        01 -- 25 Hz
        10 -- 10 Hz
        11 -- 1  Hz
    */
    output slow_clock;
    input CLOCK_50;

    input [1:0] select;

    // counts
    reg [31:0] counter;
	reg slow_clock;
    always @(posedge CLOCK_50)
    begin
		if (counter != 32'b0)
		    begin
		        slow_clock <= 0;
			    counter <= counter - 32'b1;
		    end
		else
			begin
				out <= 1;
				case (select)
					2'b00: counter <= 32'd1;
					2'b01: counter <= 32'd200000;
					2'b10: counter <= 32'd500000;
					2'b11: counter <= 32'd50000000;
				endcase
			end
    end
endmodule