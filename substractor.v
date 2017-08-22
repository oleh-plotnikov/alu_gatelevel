`timescale 1 ns / 1 ps 
///////////////////////////////////////////////////////////////
///////////////////////// HALF_SUBSTRACTOR ////////////////////
///////////////////////////////////////////////////////////////
module half_sub (i_op1, i_op2, o_sub, o_borrow);

input i_op1, i_op2;
output o_sub;
output o_borrow;

wire i_op1_n;

xor (o_sub, i_op1, i_op2);
not (i_op1_n, i_op1);
and (o_borrow, i_op1_n, i_op2);

endmodule
///////////////////////////////////////////////////////////////
///////////////////// FULL_SUBSTRACTOR ////////////////////////
///////////////////////////////////////////////////////////////
module full_sub (i_op1, i_op2, i_borrow, o_sub, o_borrow);

input i_op1, i_op2, i_borrow;
output o_sub, o_borrow;

wire borrow1, borrow2, sub_op1;

half_sub half_sub_1    (.i_op1 (i_op1),
			.i_op2 (i_op2),
			.o_sub (sub_op1),
			.o_borrow (borrow1)
			);

half_sub half_sub_2    (.i_op1 (sub_op1),
			.i_op2 (i_borrow),
			.o_sub (o_sub),
			.o_borrow (borrow2)
			);

or (o_borrow, borrow1, borrow2);

endmodule
////////////////////////////////////////////////////////////////
////////////////////// SUBSTRACTOR_4BIT ////////////////////////
////////////////////////////////////////////////////////////////
module substractor_4bit (i_op1, i_op2, i_borrow, o_borrow, o_sub);

input [3 : 0] i_op1, i_op2; 
input i_borrow;
output o_borrow;
output [3 : 0] o_sub;

wire [2 : 0] borrow;

full_sub full_sub_1    (.i_op1 (i_op1[0]),
			.i_op2 (i_op2[0]),
			.i_borrow (i_borrow),
			.o_sub (o_sub[0]),
			.o_borrow (borrow[0])
			);

full_sub full_sub_2    (.i_op1 (i_op1[1]),
			.i_op2 (i_op2[1]),
			.i_borrow (borrow [0]),
			.o_sub (o_sub[1]),
			.o_borrow (borrow[1])
			);

full_sub full_sub_3    (.i_op1 (i_op1[2]),
			.i_op2 (i_op2[2]),
			.i_borrow (borrow [1]),
			.o_sub (o_sub[2]),
			.o_borrow (borrow[2])
			);

full_sub full_sub_4    (.i_op1 (i_op1[3]),
			.i_op2 (i_op2[3]),
			.i_borrow (borrow [2]),
			.o_sub (o_sub[3]),
			.o_borrow (o_borrow)
			);

endmodule
