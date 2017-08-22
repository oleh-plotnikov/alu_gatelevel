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
/////////////////////// MULTIPLIER_4BIT ////////////////////////
////////////////////////////////////////////////////////////////
module multiplier_4bit ( i_op1, i_op2, o_mult );

input  [3 : 0] i_op1, i_op2;
output [7 : 0] o_mult;

wire [15 : 0] and_w;   // wires for and array
wire [11 : 0] carry_w; // wires for carry array
wire [5 : 0] sum_w;	   // wires for sum array
	
and AND1  (and_w[0],  i_op1[0], i_op2[0]); // and array
and AND2  (and_w[1],  i_op1[1], i_op2[0]);
and AND3  (and_w[2],  i_op1[2], i_op2[0]);
and AND4  (and_w[3],  i_op1[3], i_op2[0]);

and AND5  (and_w[4],  i_op1[0], i_op2[1]);
and AND6  (and_w[5],  i_op1[1], i_op2[1]);
and AND7  (and_w[6],  i_op1[2], i_op2[1]);
and AND8  (and_w[7],  i_op1[3], i_op2[1]);

and AND9  (and_w[8],  i_op1[0], i_op2[2]);
and AND10 (and_w[9],  i_op1[1], i_op2[2]);
and AND11 (and_w[10], i_op1[2], i_op2[2]);
and AND12 (and_w[11], i_op1[3], i_op2[2]);

and AND13 (and_w[12], i_op1[0], i_op2[3]);
and AND14 (and_w[13], i_op1[1], i_op2[3]);
and AND15 (and_w[14], i_op1[2], i_op2[3]);
and AND16 (and_w[15], i_op1[3], i_op2[3]);

assign o_mult[0] = and_w[0]; // LSB

//		     (     i_op1,     i_op2,      i_carry,     o_sum,     o_carry  );
full_add full_add_1  (  and_w[1],  and_w[4],         1'b0, o_mult[1],  carry_w[0]  ); // 1 row adders;
full_add full_add_2  (  and_w[2],  and_w[5],   carry_w[0],  sum_w[0],  carry_w[1]  );
full_add full_add_3  (  and_w[3],  and_w[6],   carry_w[1],  sum_w[1],  carry_w[2]  );
full_add full_add_4  (      1'b0,  and_w[7],   carry_w[2],  sum_w[2],  carry_w[3]  );

full_add full_add_5  (  and_w[8],   sum_w[0],        1'b0, o_mult[2],  carry_w[4]  ); // 2 row adders;
full_add full_add_6  (  and_w[9],   sum_w[1],  carry_w[4],  sum_w[3],  carry_w[5]  );
full_add full_add_7  ( and_w[10],   sum_w[2],  carry_w[5],  sum_w[4],  carry_w[6]  );
full_add full_add_8  ( and_w[11], carry_w[3],  carry_w[6],  sum_w[5],  carry_w[7]  );

full_add full_add_9  ( and_w[12],   sum_w[3],        1'b0, o_mult[3],  carry_w[8]  ); // 3 row adders;
full_add full_add_10 ( and_w[13],   sum_w[4],  carry_w[8], o_mult[4],  carry_w[9]  );
full_add full_add_11 ( and_w[14],   sum_w[5],  carry_w[9], o_mult[5], carry_w[10] );
full_add full_add_12 ( and_w[15], carry_w[7], carry_w[10], o_mult[6], carry_w[11] );

assign o_mult[7] = carry_w[11]; // MSB

endmodule
