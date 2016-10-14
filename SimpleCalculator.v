module SimpleCalculator (GPIO_0, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, CLOCK_50, LEDR, LEDG, SW);
	inout [24:10] GPIO_0;
	input [17:0] SW;
	input CLOCK_50;
	output [17:0] LEDR;
	output [8:0] LEDG;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	wire clock_500; //500Hz clock tick
	wire validPress;
	wire [4:0] display0, display1, display2, display3, display4, display5, display6, display7;
	wire [4:0] pressedButton, readButton;
	wire cntrlCalcActive, cntrlKeypad,cntrlDisplayError, cntrlLoadNum1, cntrlDisNum1, cntrlClear, cntrlNum1Neg, cntrlNum2Neg, cntrlOper, cntrlDisNum2,cntrlDisableSecNum, cntrlCalc;
	wire sigNum1DigBLoaded, sigNum1DigALoaded,  sigNum2DigBLoaded, sigNum2DigALoaded, sign1, sign2;
	wire [7:0] cntrlDisplay; //will be changed to 8 bit
	wire [3:0] state;
	wire [4:0] number;
	wire [7:0] ONE;
	
	//******TRY USING FASTER CLOCK FOR EVERY THING OUTSIDE OF BUTTON PRESS******
	ClockDivider (CLOCK_50, clock500);
	
//FSM (currentState, clock, INcalcActive, INvalidPress, OUTcalcActive, OUTkeypad, OUTdisplay, OUTdisplayError, OUTloadNum1, OUTloadNum2, OUTdisNum1, OUTdisNum2, OUTclear, INbutton, OUTbutton, OUTNum1Neg, OUTNum2Neg, OUToper, OUTdisableSecNum);

	FSM (state,clock500, SW[17], validPress, cntrlCalcActive, cntrlKeypad, cntrlDisplay, cntrlDisplayError, cntrlLoadNum1, cntrlLoadNum2, cntrlDisNum1, cntrlDisNum2, cntrlClear, pressedButton, readButton, cntrlNum1Neg, cntrlNum2Neg, cntrlDisableSecNum, cntrlCalc); //clock signal changed to 500
	
//DataPath(Operator, num1Sign, num2Sign, clock, RowCol, cntrlCalcActive, cntrlKeypad, cntrlLoadNum1, cntrlLoadNum2, cntrlDisNum1, cntrlDisNum2, cntrlClear, cntrlNum1Neg, cntrlNum2Neg, cntrlDisplayError, cntrlOper, cntrlDisableSecNum, validPress, disp0, disp1, disp2, disp3, disp4, disp5, disp6, disp7, pressedButton, readButton, sigNum1DigBLoaded, sigNum1DigALoaded,  sigNum2DigBLoaded, sigNum2DigALoaded);

	DataPath (ONE, number,sign1, sign2, clock500, GPIO_0, cntrlCalcActive, cntrlKeypad, cntrlLoadNum1, cntrlLoadNum2, cntrlDisNum1, cntrlDisNum2, cntrlClear, cntrlNum1Neg, cntrlNum2Neg, cntrlDisplayError, cntrlOper, cntrlDisableSecNum, validPress, display0, display1, display2, display3, display4, display5, display6, display7, pressedButton, readButton, sigNum1DigBLoaded, sigNum1DigALoaded,  sigNum2DigBLoaded, sigNum2DigALoaded, cntrlCalc);
	
	//KeypadReader(clock500, {GPIO_0[10], GPIO_0[12], GPIO_0[14], GPIO_0[16]}, {GPIO_0[18], GPIO_0[20], GPIO_0[22], GPIO_0[24]}, display0, validPress, 1);
	
	//ButtonType (validPress, display0, Num, Op, C, Neg, E);
	LED_Lighting (LEDR, LEDG, cntrlDisplayError, cntrlCalcActive, cntrlNum2Neg, sign1, sign2, state, number, ONE);
	
//	assign LEDR[17] = Num;
//	assign LEDR[15] = Op;
//	assign LEDR[13] = C;
//	assign LEDR[11] = Neg;
//	assign LEDR[9] = E;
	//assign LEDG[1] = validPress;


	SevenSegmentDisplay(HEX0, display0, cntrlDisplay[0]);
	SevenSegmentDisplay(HEX1, display1, cntrlDisplay[1]);
	SevenSegmentDisplay(HEX2, display2, cntrlDisplay[2]);
	SevenSegmentDisplay(HEX3, display3, cntrlDisplay[3]);
	SevenSegmentDisplay(HEX4, display4, cntrlDisplay[4]);
	SevenSegmentDisplay(HEX5, display5, cntrlDisplay[5]);
	SevenSegmentDisplay(HEX6, display6, cntrlDisplay[6]);
	SevenSegmentDisplay(HEX7, display7, cntrlDisplay[7]);
	
	

endmodule