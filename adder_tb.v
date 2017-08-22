`timescale 1ns/1ps
///////////////////////////////////////////////////////////////
///////////////////////// ADDDER_4BIT_TB //////////////////////
///////////////////////////////////////////////////////////////
module adder_4bit_tb;

reg [3 : 0] i_op1, i_op2;
reg i_carry;
reg [3 : 0] golden_sum;
reg golden_carry;

wire [3 : 0] o_sum;
wire o_carry;

integer i, j;
integer error_count;

event stop;

adder_4bit  adder      (.i_op1 (i_op1),
			.i_op2 (i_op2),
			.i_carry (i_carry),
			.o_sum (o_sum),
			.o_carry (o_carry)
			);
									
initial begin // generate input data for i_op1, i_op2, i_carry. // calculate golden model. 
#0;
i_carry = 0;
	repeat(2) begin
		for (i = 0; i < 16; i = i + 1)
			for (j = 0; j < 16; j = j + 1) begin
				i_op1 = i;
				i_op2 = j;
				{golden_carry, golden_sum} = i_op1 + i_op2 + i_carry;
				#10;
			end
	i_carry = ~i_carry; 
	end
->stop;
end

initial begin // compare rtl_model & golden model. // increment error.
	forever begin
		 if ((golden_carry !== o_carry) || (golden_sum !== o_sum)) begin
			error_count = error_count + 1;
			$display ("op1 = %d, op2 = %d, carry = %d", i_op1, i_op2, i_carry);
			$display ("ERROR, golden_sum = %d, o_sum = %d,\n\tgolden_carry = %d, o_carry = %d,", golden_sum, o_sum, golden_carry, o_carry);
			$display ("time = ", $time);
		end
	#10;
	end
end

initial begin // display final result tb on the console.
error_count = 0;
	@stop
	if (error_count == 0)
		$display ("SUCCESS! error_count = %d", error_count);
	else
		$display ("ERROR!  error_count = %d", error_count);

$finish();
end

endmodule
