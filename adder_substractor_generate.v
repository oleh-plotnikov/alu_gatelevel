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
////////////////////// PARAM_ADDER /////////////////////////////
////////////////////////////////////////////////////////////////
module param_adder (i_op1, i_op2, i_carry, o_carry, o_sum);

parameter WIDTH = 4;

input [WIDTH - 1 : 0] i_op1, i_op2; 
input i_carry;
output o_carry;
output [WIDTH - 1 : 0] o_sum;

wire [WIDTH - 2 : 0] carry;

genvar i;

generate 

	for (i = 0; i < WIDTH; i = i + 1) begin : adder
		if (i == 0)
			full_add full_add_lsb  (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_carry (i_carry),
						.o_sum (o_sum[i]),
						.o_carry (carry[i])
						);

		else if (i == WIDTH-1)
			full_add full_add      (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_carry (carry [i - 1]),
						.o_sum (o_sum[i]),
						.o_carry (o_carry)
						);
		else 
			full_add full_add_msb  (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_carry (carry [i - 1]),
						.o_sum (o_sum[i]),
						.o_carry (carry[i])
						);
	end

endgenerate

endmodule
///////////////////////////////////////////////////////////////////////////////
////////////////////// PARAM_ADDER_OR_SUBSTRACTOR /////////////////////////////
///////////////////////////////////////////////////////////////////////////////
module add_sub (i_op1, i_op2, i_carry_borrow, o_res, o_carry_borrow);

parameter WIDTH = 4;
parameter MODE =  1;

input	[WIDTH - 1 : 0] i_op1, i_op2;
input i_carry_borrow;

output [WIDTH - 1 : 0] o_res;
output o_carry_borrow;

wire [WIDTH - 1 : 0] operate;

genvar i;

generate

	if (MODE == 0) begin
			for (i = 0; i < WIDTH; i = i + 1) begin : NOT_BLOCK
				not (operate[i], i_op2[i]);
			end
	assign i_carry_borrow = 1'b1;

	end else if (MODE == 1) begin

		assign operate = i_op2;

	end else initial begin
		$display ("MODE: NOT DEFINE!!!");
		$finish;
	end

endgenerate

param_adder #(.WIDTH(WIDTH)) full_add  (.i_op1(i_op1), 
					.i_op2(operate),
					.i_carry(i_carry_borrow),
					.o_sum(o_res),
					.o_carry(o_carry_borrow)
					);

endmodule
