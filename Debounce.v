//Recognises the rising edge of a button press with active-high operation
module Debounce(clock, button_press, button_state);
	input clock, button_press;
	output reg button_state;
	reg [3:0] sample;
	
	initial
	begin
		sample = 4'b0;
		button_state = 0;
	end

	always @(posedge clock) 
	begin
		sample[0] <= sample[1];						// Shift registers:
		sample[1] <= sample[2];						// Value is stored into sample[3] and...
		sample[2] <= sample[3];						// ...shifted along into sample[0].
		sample[3] <= button_press;
		
	//If the following combination of the 4-bit register sample occurs, a single valid press has occurred
		if ( sample == 4'b1110 ) 
			button_state = 1;
		else 
			button_state = 0;
	end
	
endmodule
