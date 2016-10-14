module FSM (currentState, clock, INcalcActive, INvalidPress, OUTcalcActive, OUTkeypad, OUTdisplay, OUTdisplayError, OUTloadNum1, OUTloadNum2, OUTdisNum1, OUTdisNum2, OUTclear, INbutton, OUTbutton, OUTNum1Neg, OUTNum2Neg, OUTdisableSecNum, OUTcal);
	input clock;
	input INcalcActive, INvalidPress;
	input [4:0] INbutton;
	output reg [4:0] OUTbutton;
	output reg OUTcalcActive, OUTkeypad, OUTdisplayError, OUTloadNum1, OUTclear, OUTdisNum1, OUTloadNum2, OUTNum1Neg, OUTNum2Neg, OUTdisNum2, OUTdisableSecNum, OUTcal; //output control signals 
	output reg [7:0] OUTdisplay; //output 8 bit control signal to turn on HEX displays
	
	wire PRESSisNumber, PRESSisOper, PRESSisClear, PRESSisNegative, PRESSisEqual;
	output reg [3:0] currentState;	
	
	initial
	begin
		currentState = 4'd0;
		OUTcalcActive = 0;
		OUTkeypad = 0;
		OUTdisplay = 8'd0;
		OUTdisplayError = 0;
		OUTloadNum1 = 0;
		OUTclear = 0;
		OUTbutton = 5'b11111;
		OUTdisNum1 = 1;
		OUTloadNum2 = 1;
		OUTdisNum2 = 0;
		OUTNum1Neg = 0;
		OUTNum2Neg = 0;
		OUTdisableSecNum = 1;
		OUToper = 0;
		OUTcal = 0;
	end
	
	//Takes in a valid button press and outputs which type of button was pressed
	ButtonType (INvalidPress, INbutton, PRESSisNumber, PRESSisOper, PRESSisClear, PRESSisNegative, PRESSisEqual);
	
	//Change the currentState at clock signal
	always @ (posedge clock)
	begin		
		case(currentState)
		//Calculator switch is toggled off, calculator is not active
			4'd0:
			begin
				if(INcalcActive)
					currentState = 4'd1;
			end
			
		//Calculator switch is toggled on and is reading keypad
			4'd1:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress) 
				begin
				//A number button is pressed for the first number
					if (PRESSisNumber)
						currentState = 4'd2;
				//The negative button was pressed was the first number
					else if (PRESSisNegative)
						currentState = 4'd3;					
				//Either an operator or equal button is pressed
					else if (PRESSisEqual||PRESSisOper)
						currentState = 4'd15;
				//The clear button is pressed
					else if (PRESSisClear)
						currentState = 4'd1;
				end
			end
		
		//A number button was pressed for the first number
			4'd2:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
				begin
				//A number button is pressed for the first number
					if (PRESSisNumber)
						currentState = 4'd2;
				//Either operator or negative is pressed
					else if (PRESSisNegative||PRESSisOper)
						currentState = 4'd4;
				//The equals button is pressed
					else if (PRESSisEqual)
						currentState = 4'd15;
				//The clear button is pressed	
					else if (PRESSisClear)
						currentState = 4'd1;
				end	
			end
			
		//The negative sign button was pressed for the first number
			4'd3:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
				begin
				//A number button is pressed for the first number
					if (PRESSisNumber)
						currentState = 4'd2;
				//Either operator OR equals is pressed
					else if (PRESSisEqual||PRESSisOper)
						currentState = 4'd15;
				//The clear button is pressed	
					else if (PRESSisClear)
						currentState = 4'd1;
				end	
			end
			
		//An operator button was pressed
			4'd4:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
					begin
					//A number button was pressed for the second number 
						if (PRESSisNumber)
							currentState = 4'd5;
					//The negative button was pressed for the second number
						else if (PRESSisNegative)
							currentState = 4'd6;					
					//Either Operator or equals is pressed
						else if (PRESSisEqual || PRESSisOper)
							currentState = 4'd15;
					//The clear button is pressed
						else if (PRESSisClear)
							currentState = 4'd1;
					end
			end
			
		//A number button was pressed for the second number
			4'd5:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
				begin
				//A number button was pressed for the second number
					if (PRESSisNumber)
						currentState = 4'd5;
				//The equal button is presssed
					else if (PRESSisEqual)
						currentState = 4'd10;
				//Either operator or negative is pressed
					else if (PRESSisNegative || PRESSisOper)
						currentState = 4'd15;
				//The clear button is pressed	
					else if (PRESSisClear)
						currentState = 4'd1;
				end
			end
			
		//The negative sign button was pressed for the second number
			4'd6:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
				begin
					//A number button was pressed for the second number
					if (PRESSisNumber)
						currentState = 4'd5;
					//if (PRESSisNegative)
						//currentState = 4'd6;
				//Either operator or negative or equals is pressed
					else if (PRESSisEqual || PRESSisOper || PRESSisNegative )
						currentState = 4'd15;
				//The clear button is pressed	
					else if (PRESSisClear)
						currentState = 4'd1;
				end
			end
			
		//The equals button is pressed
			4'd10:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
				begin
				//The clear button is pressed
					if (PRESSisClear)
						currentState = 4'd1;
				end
			end
			
		//Error state: invalid press sequence or division by zero had occurred 	
			4'd15:
			begin
				if (~INcalcActive)
					currentState = 4'd0;
				else if (INvalidPress)
				begin
				//The clear button is pressed
					 if (PRESSisClear)
							currentState = 4'd1;
				end
			end
		endcase
	end	
	
//Control signals for each state	
	always @ (currentState)
	begin
		case (currentState)
		//Calculator switched off
			4'd0:
				begin
					OUTcalcActive <= 0;  	//Calculator turned off 
					OUTkeypad <= 0;			//keypad turned off
					OUTdisplay <= 8'd7;		//first three HEX displays active
					OUTdisplayError <= 0;	//No error 
					OUTloadNum1 <= 1;			//Do not load registers for number 1
					OUTloadNum2 <= 1;			//Do not load registers for number 2
					OUTdisNum1 <= 0;			//Do not display number 1
					OUTdisNum2 <= 0;			//Do not display number 2
					OUToper <= 1;				//Do not load register for operator 
					OUTclear <= 1;				//Clear all registers
					OUTNum1Neg <= 0;			//Number 1 negative flag turned off
					OUTNum2Neg <= 0;			//number 2 negative flag turned off 
					OUTdisableSecNum <= 1; 	//Second number should not be loaded yet
					OUTbutton <= 5'b11111;	//No button is read in
					OUTcalc <= 0;				//Do not perform calculation
				end
		//Calculator switched on
			4'd1:
				begin
					OUTcalcActive <= 1;		//Calculator is turned off 
					OUTkeypad <= 1;			//Keypad turned on 
					OUTdisplay <= 8'd0;		//No displays active
					OUTdisplayError <= 0;	//No error
					OUTdisNum1 <= 0;			//First number can be displayed
					OUTdisNum2 <= 1;			//Do not load registers for second number
					OUTclear <= 1;				//Clear all registers
					OUTloadNum1 <= 0;			//load registers for first number from now on
					OUTloadNum2 <= 1;			//Do not load register for second number
					OUToper <= 1;				//Do not load register for operator
					OUTNum1Neg <= 0;			//Negative flag for first number turned off
					OUTNum2Neg <= 0;			//Negative flag for second number turned off 
					OUTdisableSecNum <= 1;	//second number should not be loaded yet
					OUTbutton <= INbutton;	//Read in buttons now
					OUTcal <= 0;
				end
				
		//The number button is pressed for the first number
			4'd2:
				begin
					OUTcalcActive <= 1;		//Calculator is turned on 
					OUTkeypad <= 1;			//Keypad is turned on
					OUTdisplay <= 8'd7;		//Turn on first three HEX displays
					OUTdisplayError <= 0;	//no error
					OUTloadNum1 <= 0;			//Load registers for first number
					OUTloadNum2 <= 1;			//do not load registers for second number	
					OUTdisNum1 <= 1;			//Display first number
					OUTdisNum2 <= 0;			//Do not display second number
					OUTclear <= 0;				//Do not clear registers
					OUTdisableSecNum <= 1;	//Second number should not be loaded yet
					OUTNum2Neg <= 0;			//Negative flag for second number turned off
					OUTbutton <= INbutton;	//Read in buttons
				end
		
		//Negative button is pressed for the first number
			4'd3:
				begin
					OUTcalcActive <= 1;		//Calculator is turned on
					OUTkeypad <= 1;			//keypad is turned on
					OUTdisplay <= 8'd1;		//Only the first HEX display is active
					OUTdisplayError <= 0;	//No error
					OUTloadNum1 <= 0;			//load first number to registers
					OUTloadNum2 <= 1;			//Do not load second number to registers
					OUTdisNum1 <= 1;			//Display second number
					OUTdisNum2 <= 0;			//Do not display second number
					OUTclear <= 0;				//Do not clear
					OUTNum1Neg <= 1;			//Turn on the negative flag for first number
					OUTNum2Neg <= 0;			//Negative flag for second number turned off
					OUTdisableSecNum <= 1;	//Second number should not be loaded yet
					OUTbutton <= INbutton;	//Read in buttons
				end
		
		//operator has been pressed
			4'd4:
				begin
					OUTcalcActive <= 1;		//Calculator is turned on
					OUTkeypad <= 1;			//Keypad is turned on
					OUTdisplay <= 8'd0;		//No HEX displays are active
					OUTdisplayError <= 0;	//no errors
					OUToper <= 0;				//load operator to register
					OUTloadNum1 <= 1;			//Do not load first number to registers
					OUTloadNum2 <= 0;			//Load second number to registers
					OUTdisNum1 <= 0;			//Do not display first number
					OUTdisNum2 <= 0;			//Do not display second numberr
					OUTclear <= 0;				//Do not clear registers
					OUTNum2Neg <= 0;			//Turn off negative flag for second number
					OUTdisableSecNum <= 0;	//Number 2 should be loaded now	
					OUTbutton <= INbutton;	//read in buttons
				end
		
		//number button pressed second number
			4'd5:
				begin
					OUTcalcActive <= 1;		//Turn on calculator
					OUTkeypad <= 1;			//turn on keypad
					OUTdisplay <= 8'd7;		//first three HEX displays are active
					OUTdisplayError <= 0;	//no error
					OUTloadNum1 <= 1;			//Do not load first number to registers anymore
					OUTloadNum2 <= 0;			//load second number to registers
					OUTdisNum1 <= 0;			//Do not display first number
					OUTdisNum2 <= 1;			//Display second number
					OUTclear <= 0;				//Do not clear
					OUToper <= 0;				//Do not load operator to registers anymore
					OUTdisableSecNum <= 0;	//Number 2 can be loaded to registers
					OUTbutton <= INbutton;	//read in buttons
				end
				
		//Negative button pressed for second number	
			4'd6:
				begin
					OUTcalcActive <= 1;		//Calculator is turned on
					OUTkeypad <= 1;			//Keypad is active
					OUTdisplay <= 8'd1;		//First HEX display is active
					OUTdisplayError <= 0;	//No error
					OUTloadNum1 <= 1;			//Do not load first number to registers anymore
					OUTloadNum2 <= 0;			//Load second number to registers
					OUTdisNum1 <= 0;			//Do not display first number
					OUTdisNum2 <= 1;			//Display second number
					OUTclear <= 0;				//Do not clear
					OUTNum2Neg <= 1;			//Turn on negative flag for 
					OUTdisableSecNum <= 0;	//Number 2 can be loaded to registers
					OUTbutton <= INbutton;	//Read in buttons
 				end
				
			//equals is pressed, performing calculation	
				4'd10:
				begin
					OUTcalcActive <= 1;		//Calculator is turned on
					OUTkeypad <= 1;			//Keypad is active
					OUTdisplay <= 8'HFF;		//All displays are active
					OUTcal <= 1;				//Calculator the final result
				end
		//Error state		
				4'd15:
				begin
					OUTcalcActive <= 1;		//calculator is turned on
					OUTkeypad <= 1;			//Keypad is active 
					OUTdisplay <= 8'HFF;		//Turn on all displays
					OUTdisplayError <= 1;	//Turn on error flag
					OUTloadNum1 <= 0;			//
					OUTdisNum1 <= 0;
					OUTclear <= 0;
					OUTbutton <= 5'b11111;
					OUTNum1Neg <= 0;
					OUTNum2Neg <= 0;
				end
		endcase
	end
endmodule