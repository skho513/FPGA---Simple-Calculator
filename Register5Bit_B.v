module Register5Bit_B (clock, reset, store, read, press, enable, loaded, secondNum);
	input clock, reset, enable, press, secondNum;
	input [4:0] store;
	output reg [4:0] read;
	output reg loaded;
	
	initial 
	begin
		loaded = 0;
		read = 5'b11111;
	end
	
	always @ (posedge clock)
	begin
		if (reset || secondNum)
		begin
			read <= 5'b11111;
			loaded <= 0;
		end
		
		if (!enable && !secondNum)
		begin
			if ((store <= 5'd9) && press)
			begin	
				loaded <= 1;
				read <= store;
			end
		end
		else
			read <= read;
 
	end
	
endmodule