//Converts an 8-bit signal from keypad to a 4-bit signal to represent a button
module Button_8To4_Converter(eightBitButton, fiveBitChar, validPress);
	input [7:0]eightBitButton; //8 bit button sequence to convert
	input validPress;
	output reg [4:0]fiveBitChar; //5 bit converted output that represents a button
	
	always@ (validPress)
	begin
		if (validPress)
		case (eightBitButton)
		//Column 0
			8'b01110111 : fiveBitChar = 5'b00001; 	//Button 1
			8'b01111011 : fiveBitChar = 5'b00100;	//Button 4
			8'b01111101 : fiveBitChar = 5'b00111;	//Button 7
			8'b01111110 : fiveBitChar = 5'b01111;	//Button A (clear)
		//Column 1
			8'b10110111 : fiveBitChar = 5'b00010; 	//Button 2
			8'b10111011 : fiveBitChar = 5'b00101;	//Button 5
			8'b10111101 : fiveBitChar = 5'b01000;	//Button 8
			8'b10111110 : fiveBitChar = 5'b00000;	//Button 0 
		//Column 2
			8'b11010111 : fiveBitChar = 5'b00011; 	//Button 3
			8'b11011011 : fiveBitChar = 5'b00110;	//Button 6
			8'b11011101 : fiveBitChar = 5'b01001;	//Button 9
			8'b11011110 : fiveBitChar = 5'b01110;	//Button =
		//Column 3
			8'b11100111 : fiveBitChar = 5'b01010; 	//Button +
			8'b11101011 : fiveBitChar = 5'b01011;	//Button -
			8'b11101101 : fiveBitChar = 5'b01100;	//Button *
			8'b11101110 : fiveBitChar = 5'b01101;	//Button /
			
			default : fiveBitChar = 5'b11111;	//no button press
		endcase
		else
		fiveBitChar = 5'b11111; //no button press
	end
		
endmodule