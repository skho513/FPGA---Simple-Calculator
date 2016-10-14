module Register5Bit (clock, reset, store, read, enable, loaded);
	input clock, reset, enable;
	input [4:0] store;
	output reg [4:0] read;
	output reg loaded;
	reg [4:0] fiveBit;
	
	initial 
	begin
	fiveBit = 5'b11111;
	loaded = 0;
	end
	always @ (posedge clock)
	begin
		if (reset)
		begin
			fiveBit <= 5'b11111;
			loaded <= 0;
		end 
		if ((enable) && (store != 5'b11111))
		begin
			fiveBit <= store;
			loaded <= 1;
		end 
		
		read <= fiveBit;
			
	end
	
endmodule