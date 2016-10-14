module LED_Lighting (redLED, greenLED, Error, PowerOn, A, B, C, state, number, ONE);
	output reg [17:0] redLED;
	output reg [8:0] greenLED;
	input Error, PowerOn, A, B, C;
	input [3:0] state;
	input [4:0] number;
	input [7:0] ONE;
	
	always @ (*)
	begin
		if (Error | ~PowerOn)
	//Turn on all red LEDs and turn off green LEDs
		begin
			//redLED = 18'H3FFFF;
			redLED[3:0] = state;
			greenLED[8:0] = 9'H0;	
		end
		else
	//Turn on all green LEDs and turn off red LEDs
		begin
			redLED = 18'H0;
			redLED[3:0] = state;
			greenLED[4:0] = number; 
			//greenLED = 9'H3F;
			
			redLED[17:10] = ONE;
			
			if (A)
				greenLED[8] = 1;
			else
				greenLED[8] = 0;
			
			if (B)
				greenLED[7] = 1;
			else
				greenLED[7] = 0;	
				
			if (C)
				greenLED[6] = 1;
			else
				greenLED[6] = 0;
		end
	end 
endmodule