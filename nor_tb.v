`timescale 1 ns/1 ps
//////////////////////////////////////////////////////////////
/////////////////// BITWISE_NOR_4BIT_TB //////////////////////
//////////////////////////////////////////////////////////////
module bitwise_nor_4bit_tb;

reg  [3 : 0]  i_op1, i_op2;
wire [3 : 0]  o_dat;

bitwise_nor_4bit bitwise_nor   (.i_op1 (i_op1),
				.i_op2 (i_op2),
				.o_dat (o_dat)
				);		   		

integer i, j, golden_bitwise, error_count;

initial begin // iterate value op1, op2
error_count = 0;
	for (i=0; i < 16; i = i + 1)
		for (j = 0; j < 16; j = j + 1) begin
			i_op1 = i;
			i_op2 = j;
			golden_bitwise = { ~ (i_op1 | i_op2)}; // create golden model
			#1;
			if (golden_bitwise !== o_dat) begin // compare golden model with gatelevel model
				error_count = error_count + 1;
				$display ("Error, i_op1=%d, i_op2=%d,\n\tnor o_dat=%d, golden_nor=%d",$time, i_op1, i_op2, o_dat, golden_bitwise);
			end
		end
if (error_count == 0) // display the final result tb on cosole
	$display ("SUCCESS! error_count = %d", error_count);
else
	$display ("ERROR!  error_count = %d", error_count);
end

endmodule
