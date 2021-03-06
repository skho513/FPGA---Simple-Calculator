//Display a number or character onto a single 7-segment HEX display 
module SevenSegmentDisplay(DisplayHex, character, enableSignal);
	input [4:0]character; //The character to display on HEX
	input enableSignal;
	output reg [6:0]DisplayHex; //The output 7-segment HEX display 
	
	always @(*)
	begin
	//if enabled, display a character as required
		if(enableSignal)
			case (character)
				0  : DisplayHex = 7'b1000000; //Display 0
				1  : DisplayHex = 7'b1111001; //Display 1
				2  : DisplayHex = 7'b0100100; //Display 2
				3  : DisplayHex = 7'b0110000; //Display 3
				4  : DisplayHex = 7'b0011001; //Display 4
				5  : DisplayHex = 7'b0010010; //Display 5
				6  : DisplayHex = 7'b0000010; //Display 6
				7  : DisplayHex = 7'b1111000; //Display 7
				8  : DisplayHex = 7'b0000000; //Display 8
				9  : DisplayHex = 7'b0011000; //Display 9
				10 : DisplayHex = 7'b0001110; //Display F 
				11	: DisplayHex = 7'b0111111; //Display - (negative)
				12	: DisplayHex = 7'b0100011; //Display o 
				13	: DisplayHex = 7'b0101111; //Display r (remainder for division) 
				14	: DisplayHex = 7'b0000110; //Display E  
				default : DisplayHex = 7'b1111111; //clear
			endcase
		else
			DisplayHex = 7'b1111111; //clear
	end	
	
endmodule