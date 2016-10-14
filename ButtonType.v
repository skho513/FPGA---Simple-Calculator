module ButtonType (validPress, button, isNumber, isOper, isClear, isNegative, isEqual);
	input validPress;
	input [4:0] button;
	output reg isNumber, isOper, isClear, isNegative, isEqual;
	
	initial
	begin
		isNumber = 0;
		isOper = 0;
		isClear = 0;
		isNegative = 0;
		isEqual = 0;
	end
	
	always @ (validPress)
	begin
		if(validPress)
		begin
		//button pressed was a number
			if (button <= 5'd9)
			begin 
				isNumber = 1;
				isOper = 0;
				isClear = 0;
				isNegative = 0;
				isEqual = 0;
			end
		//button pressed was  equal
			else if (button == 5'd14)
			begin
				isNumber = 0;
				isOper = 0;
				isClear = 0;
				isNegative = 0;
				isEqual = 1;
			end
			//button pressed was minus/negative
			else if (button == 5'd11)
			begin
				isNumber = 0;
				isOper = 0;
				isClear = 0;
				isNegative = 1;
				isEqual = 0;
			end
			//operator other an minus was pressed
			else if (button < 5'd15)
			begin
				isNumber = 0;
				isOper = 1;
				isClear = 0;
				isNegative = 0;
				isEqual = 0;
				
			end
		//else button is clear
			else if (button == 5'd15)
			begin 
				isNumber = 0;
				isOper = 0;
				isClear = 1;
				isNegative = 0;
				isEqual = 0;
			end
			else
			begin
				isNumber = 0;
				isOper = 0;
				isClear = 0;
				isNegative = 0;
				isEqual = 0;
			end
		end
		else
		begin
			isNumber = 0;
			isOper = 0;
			isClear = 0;
			isNegative = 0;
			isEqual = 0;
		end
	end
	
endmodule