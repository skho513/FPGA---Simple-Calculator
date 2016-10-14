module BCD_to_Binary(num_tens, num_ones, negative, num_out);

	input [4:0]num_tens, num_ones;
	input negative;
	output reg[7:0]num_out;
	
	initial num_out = 8'd0;
	
	
	always @(*)
	begin
		
		if ((num_tens != 5'd31) && (num_ones != 5'd31))					// If the use ronly typed in 1 number.
		begin
			num_out = num_ones + 10*num_tens;	// Tens is added.
			num_out[7] = negative;
		end
		
		else if (num_ones != 5'd31) 
		begin
		num_out = num_ones; 						// The ones number is stored directly.
		num_out[7] = negative;					// Negative flag input.
		end
		
		else 
			num_out = 0;
		
	end

endmodule
