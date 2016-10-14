module FlipFlop (clock, reset, read, enable, secondNum);
	input clock, reset, enable, secondNum;
	output reg read;
	
	initial read = 0;
	
	always @ (posedge clock)
	begin
		if (reset || secondNum)
			read <= 0;
		
		if (enable && !secondNum) 
			read <= 1;
		
			
	end
	
endmodule