module DataPath(finalNUMBERtwo, Operator, num1Sign, num2Sign, clock, RowCol, cntrlCalcActive, cntrlKeypad, cntrlLoadNum1, cntrlLoadNum2, cntrlDisNum1, cntrlDisNum2, cntrlClear, cntrlNum1Neg, cntrlNum2Neg, cntrlDisplayError, cntrlOper, cntrlDisableSecNum, validPress, disp0, disp1, disp2, disp3, disp4, disp5, disp6, disp7, pressedButton, readButton, sigNum1DigBLoaded, sigNum1DigALoaded,  sigNum2DigBLoaded, sigNum2DigALoaded, cntrlCalc);
	input clock;
	inout [24:10] RowCol; //Row and column pins of keypad
	input [4:0] readButton;
	input cntrlCalcActive, cntrlKeypad, cntrlLoadNum1, cntrlLoadNum2, cntrlClear, cntrlDisNum1, cntrlNum1Neg, cntrlNum2Neg, cntrlDisplayError,  cntrlDisNum2, cntrlOper, cntrlDisableSecNum, cntrlCalc;
	output reg [4:0] disp0, disp1, disp2, disp3, disp4, disp5, disp6, disp7; //character to HEX displays
	output validPress;
	output [4:0] pressedButton;
	output sigNum1DigBLoaded, sigNum1DigALoaded, sigNum2DigBLoaded, sigNum2DigALoaded;
	output num1Sign, num2Sign;
	wire [4:0] num1DigitB, num1DigitA, num2DigitB, num2DigitA; /*Operator*/
	output [4:0] Operator;
	wire [7:0] finalNUMBERone;
	output [7:0] finalNUMBERtwo;
	
	initial
	begin
		disp0 = 5'd15;
		disp1 = 5'd15;
		disp2 = 5'd15;
		disp3 = 5'd15;
		disp4 = 5'd15;
		disp5 = 5'd15;
		disp6 = 5'd15;
		disp7 = 5'd15;
	end
	
	always @ (posedge clock)
	begin
	//If the calculator switch is off, display off
		if (~cntrlCalcActive)
		//display "OFF"
		begin
			disp0 = 5'd10;
			disp1 = 5'd10;
			disp2 = 5'd0;
		end
		//while the keypad is always read
		else if (cntrlKeypad)
		begin
		//if the clear button is pressed
			if (cntrlDisplayError)
			begin
				disp0 = 5'd14;
				disp1 = 5'd14;
				disp2 = 5'd14;
				disp3 = 5'd14;
				disp4 = 5'd14;
				disp5 = 5'd14;
				disp6 = 5'd14;
				disp7 = 5'd14;
			end
		
			else if (cntrlClear)
			begin
				disp0 = 5'd15;
				disp1 = 5'd15;
				disp2 = 5'd15;
				disp3 = 5'd15;
				disp4 = 5'd15;
				disp5 = 5'd15;
				disp6 = 5'd15;
				disp7 = 5'd15;
			end
			//final solution
			else if (cntrlCalc)
			begin
				
			end
//		//if the negative button was pressed first
//			else if (cntrlNum1Neg)
//		//if the first digit is pressed after the negative button
//			if (cntrlDisNum1)
//			begin
//				disp1 = 5'd11;
//				disp0 = readButton;
//			end
//		//only negative is pressed
//			else
//				disp0 = 5'd11;
//		//if the number button was only pressed
//		else if (cntrlDisNum1)
//			disp0 = readButton;
			else if (cntrlDisNum1)
			begin
				if (num1DigitB != 5'b11111)
					disp0 = num1DigitB;
			//negative and digit A and B loaded
				if (num1Sign && sigNum1DigBLoaded && sigNum1DigALoaded)
				begin
					disp2 = 5'd11;
					disp1 =  num1DigitA;
					disp0 = num1DigitB;
				end
			//negative button and only B loaded
				else if (num1Sign  &&  sigNum1DigBLoaded)
				begin
					disp0 = num1DigitB;
					disp1 = 5'd11;
				end
				//only negative number
				else if (num1Sign)
					disp0 = 5'd11;
				else if(sigNum1DigBLoaded &&  sigNum1DigALoaded)
				begin
					disp1 =  num1DigitA;
					disp0 = num1DigitB;
				end
			end
			
			else if (cntrlDisNum2)
			begin
				if (num2DigitB != 5'b11111)
				begin
					disp2 = 5'd15;
					disp1 = 5'd15;
					disp0 = num2DigitB;
				end
			//negative and digit A and B loaded
				if (num2Sign && sigNum2DigBLoaded && sigNum2DigALoaded)
				begin
					disp2 = 5'd11;
					disp1 =  num2DigitA;
					disp0 = num2DigitB;
				end
			//negative button and only B loaded
				else if (num2Sign  &&  sigNum2DigBLoaded)
				begin
					disp0 = num2DigitB;
					disp1 = 5'd11;
				end
				//only negative number
				else if (num2Sign)
					disp0 = 5'd11;
				else if(sigNum2DigBLoaded &&  sigNum2DigALoaded)
				begin
					disp1 =  num2DigitA;
					disp0 = num2DigitB;
				end
			end
		end
	end
	
	KeypadReader (clock, {RowCol[10], RowCol[12], RowCol[14], RowCol[16]}, {RowCol[18], RowCol[20], RowCol[22], RowCol[24]}, pressedButton, validPress, cntrlKeypad);
	
	Register5Bit_B ONEdigitB (clock, cntrlClear, readButton, num1DigitB, validPress, cntrlLoadNum1, sigNum1DigBLoaded, 0);
		
	Register5Bit_A ONEdigitA (clock, cntrlClear, num1DigitB, num1DigitA, validPress, ~sigNum1DigBLoaded, sigNum1DigALoaded, 0);
	
	BCD_to_Binary NUMBERONE (num1DigitA, num1DigitB,  num1Sign, finalNUMBERone);

	
	Register5Bit_B TWOdigitB (clock, cntrlClear, readButton, num2DigitB, validPress, cntrlLoadNum2, sigNum2DigBLoaded, cntrlDisableSecNum);
	
	Register5Bit_A TWOdigitA (clock, cntrlClear, num2DigitB, num2DigitA, validPress, ~sigNum2DigBLoaded, sigNum2DigALoaded, cntrlDisableSecNum);
	
	BCD_to_Binary NUMBERTWO (num2DigitA, num2DigitB,  num2Sign, finalNUMBERtwo);

	
	Register5Bit_Oper (clock, cntrlClear, readButton, Operator, cntrlOper, validPress);
	
	FlipFlop NumONESign (clock, cntrlClear, num1Sign,  cntrlNum1Neg, 0);
	
	FlipFlop NumTWOSign (clock, cntrlClear, num2Sign,  cntrlNum2Neg, cntrlDisableSecNum);
	
	

endmodule