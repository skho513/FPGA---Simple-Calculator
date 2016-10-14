//Creates a clock tick every 2ms, from the internal 50MHz clock signal, which outputs a 500Hz signal
module ClockDivider (clock50, clock500);
	input clock50;
	output reg clock500;
	reg [20:0] counter;
	
	initial clock500 = 0;
	
	always @ (posedge clock50)
	begin
	//If 1ms has passed flip clock state
		if (counter == 20'd50000)
		begin
			counter = 0;
			clock500 = ~clock500;
		end
		else
			counter = counter + 1;
	end

endmodule