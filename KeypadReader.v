//Scans the keypad to recognise a button press.
module KeypadReader (clock, Cols, Rows, button, validPress, enableSignal);
	input clock, enableSignal;
	input [3:0] Rows; //read in rows of keypad
	output reg [3:0]Cols; //write to columns of keypad
	output [4:0] button;
	output validPress;
	reg buttonPressed; //True if a button has been pressed
	
	initial
	begin
		buttonPressed = 0;
		Cols = 4'b0111; //Set the first column
	end
	
	always @ (posedge clock)
	begin
		if(enableSignal)
		//If no button has been pressed, keep setting one column at a time
			if (Rows == 4'b1111)
			begin
				Cols[3] <= Cols[0];
				Cols[2] <= Cols[3];
				Cols[1] <= Cols[2];
				Cols[0] <= Cols[1];
				
				buttonPressed <= 0;
			end
			else
				buttonPressed <= 1;
		else
			buttonPressed <= 0;
	end
	
	//Recognises a single valid key-press of the keypad
	Debounce (clock, buttonPressed, validPress);
	
	//Converts the current merged column and row 8-bit signal to a 4-bit signal respresenting a pressed button
	Button_8To4_Converter ({Cols, Rows}, button, validPress);
	
endmodule