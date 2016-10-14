module Register5Bit_A (clock, reset, store, read, press, enable, loaded, secondNum);
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
		
		if(!enable && !secondNum)
		begin
			if ((store <= 5'd9) && press ) //&& shiftedFromA)// && strobe)
			begin
				read <= store;
				loaded <= 1;
			end 
		end
		else
			read <= read;
	end
	
endmodule