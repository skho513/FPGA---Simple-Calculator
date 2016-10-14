module Register5Bit_Oper (clock, reset, store, read, enable, press);
	input clock, reset, enable, press;
	input [4:0] store;
	output reg [4:0] read;
	
	initial  read = 5'b11111;
	
	always @ (posedge clock)
	begin
		if (reset)
			read <= 5'b11111;
		
		if (!enable)
		begin
			if ((store >= 5'd10) && (store <= 5'd13) && press)
			begin
				read <= store;	
			end
		end
		else
			read <= read;
	end
	
endmodule