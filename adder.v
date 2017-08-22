`timescale 1 ns / 1 ps
///////////////////////////////////////////////////////////////
///////////////////////// HALF_ADDDER /////////////////////////
///////////////////////////////////////////////////////////////
module half_add (i_op1, i_op2, o_sum, o_carry);

input i_op1, i_op2;
output o_sum;
output o_carry;

xor (o_sum, i_op1, i_op2);
and (o_carry, i_op1, i_op2);

endmodule
///////////////////////////////////////////////////////////////
///////////////////////// FULL_ADDER //////////////////////////
///////////////////////////////////////////////////////////////
module full_add (i_op1, i_op2, i_carry, o_sum, o_carry);

input i_op1, i_op2, i_carry;
output o_sum, o_carry;

wire carry1, carry2, sum_op1;

half_add half_add_1    (.i_op1 (i_op1),
			.i_op2 (i_op2),
			.o_sum (sum_op1),
			.o_carry (carry1)
			);

half_add half_add_2    (.i_op1 (sum_op1),
			.i_op2 (i_carry),
			.o_sum (o_sum),
			.o_carry (carry2)
			);

or (o_carry, carry1, carry2);

endmodule
////////////////////////////////////////////////////////////////
//////////////////////////// ADDER_4BIT ////////////////////////
////////////////////////////////////////////////////////////////
module adder_4bit (i_op1, i_op2, i_carry, o_carry, o_sum);

input [3 : 0] i_op1, i_op2; 
input i_carry;
output o_carry;
output [3 : 0] o_sum;

wire [2 : 0] carry;

full_add full_add_1    (.i_op1 (i_op1[0]),
			.i_op2 (i_op2[0]),
			.i_carry (i_carry),
			.o_sum (o_sum[0]),
			.o_carry (carry[0])
			);

full_add full_add_2    (.i_op1 (i_op1[1]),
			.i_op2 (i_op2[1]),
			.i_carry (carry [0]),
			.o_sum (o_sum[1]),
			.o_carry (carry[1])
			);

full_add full_add_3    (.i_op1 (i_op1[2]),
			.i_op2 (i_op2[2]),
			.i_carry (carry [1]),
			.o_sum (o_sum[2]),
			.o_carry (carry[2])
			);

full_add full_add_4    (.i_op1 (i_op1[3]),
			.i_op2 (i_op2[3]),
			.i_carry (carry [2]),
			.o_sum (o_sum[3]),
			.o_carry (o_carry)
			);

endmodule
