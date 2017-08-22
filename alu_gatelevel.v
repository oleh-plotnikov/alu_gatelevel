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
			.i_carry (carry[1]),
			.o_sum (o_sum[2]),
			.o_carry (carry[2])
			);

full_add full_add_4    (.i_op1 (i_op1[3]),
			.i_op2 (i_op2[3]),
			.i_carry (carry[2]),
			.o_sum (o_sum[3]),
			.o_carry (o_carry)
			);

endmodule
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
			.i_borrow (borrow[0]),
			.o_sub (o_sub[1]),
			.o_borrow (borrow[1])
			);

full_sub full_sub_3    (.i_op1 (i_op1[2]),
			.i_op2 (i_op2[2]),
			.i_borrow (borrow[1]),
			.o_sub (o_sub[2]),
			.o_borrow (borrow[2])
			);

full_sub full_sub_4    (.i_op1 (i_op1[3]),
			.i_op2 (i_op2[3]),
			.i_borrow (borrow[2]),
			.o_sub (o_sub[3]),
			.o_borrow (o_borrow)
			);

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

//	             (     i_op1,     i_op2,      i_carry,     o_sum,     o_carry  );
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
//////////////////////////////////////////////////////////////
////////////////// MUX_5TO1 //////////////////////////////////
//////////////////////////////////////////////////////////////
module mux_5to1 (i_ctrl, i_dat, o_dat);

input [2 : 0] i_ctrl;
input [4 : 0] i_dat;
output o_dat;

wire [4 : 0] dat;
wire [2 : 0] nctrl;

not NOT [2 : 0] (nctrl, i_ctrl);

and AND1 (dat[0], i_dat[0],  nctrl[2],   nctrl[1],    nctrl[0]);
and AND2 (dat[1], i_dat[1],  nctrl[2],   nctrl[1],   i_ctrl[0]);
and AND3 (dat[2], i_dat[2],  nctrl[2],  i_ctrl[1],    nctrl[0]);
and AND4 (dat[3], i_dat[3],  nctrl[2],  i_ctrl[1],   i_ctrl[0]);
and AND5 (dat[4], i_dat[4], i_ctrl[2],   nctrl[1],    nctrl[0]);

or OR (o_dat, dat);

endmodule
//////////////////////////////////////////////////////////////
////////////////// MUX_4BIT_5TO1 /////////////////////////////
//////////////////////////////////////////////////////////////
module mux_4bit_5to1 (i_dat0, i_dat1, i_dat2, i_dat3, i_dat4, i_ctrl, o_dat);

input [2 : 0] i_ctrl;
input [3 : 0] i_dat0, i_dat1, i_dat2, i_dat3, i_dat4;

output [3 : 0] o_dat;

mux_5to1 mux1  (.i_ctrl (i_ctrl),
		.i_dat ({i_dat4[0],i_dat3[0],i_dat2[0],i_dat1[0],i_dat0[0]}),
		.o_dat (o_dat[0])
		);

mux_5to1 mux2  (.i_ctrl (i_ctrl),
		.i_dat ({i_dat4[1],i_dat3[1],i_dat2[1],i_dat1[1],i_dat0[1]}),
		.o_dat (o_dat[1])
		);

mux_5to1 mux3  (.i_ctrl (i_ctrl),
		.i_dat ({i_dat4[2],i_dat3[2],i_dat2[2],i_dat1[2],i_dat0[2]}),
		.o_dat (o_dat[2])
		);

mux_5to1 mux4  (.i_ctrl (i_ctrl),
		.i_dat ({i_dat4[3],i_dat3[3],i_dat2[3],i_dat1[3],i_dat0[3]}),
		.o_dat (o_dat[3])
		);

endmodule
//////////////////////////////////////////////////////////////
/////////////////// BITWISE_NAND_4BIT ////////////////////////
//////////////////////////////////////////////////////////////
module bitwise_nand_4bit (i_op1, i_op2, o_dat);

input [3 : 0] i_op1, i_op2;

output [3 : 0] o_dat;

nand NAND [3 : 0] (o_dat, i_op1, i_op2);

endmodule
//////////////////////////////////////////////////////////////
/////////////////// BITWISE_NOR_4BIT /////////////////////////
//////////////////////////////////////////////////////////////
module bitwise_nor_4bit (i_op1, i_op2, o_dat);

input [3 : 0] i_op1, i_op2;

output [3 : 0] o_dat;

genvar i;

nor NOR [3 : 0] (o_dat, i_op1, i_op2);

endmodule
//////////////////////////////////////////////////////////////
////////////////// ALU_GATELEVEL /////////////////////////////
//////////////////////////////////////////////////////////////
module alu_gate (i_op1, i_op2, i_ctrl, o_dat);

input [3 : 0] i_op1, i_op2;
input [2 : 0] i_ctrl;

output  [7 : 0] o_dat;

wire [3 : 0] res_add, res_sub, res_nand, res_nor;
wire [7 : 0] res_mult;

adder_4bit adder       (.i_op1 (i_op1), 
			.i_op2 (i_op2), 
			.o_sum (res_add),
			.i_carry (1'b0),
			.o_carry ()
			);

substractor_4bit substractor   (.i_op1 (i_op1), 
				.i_op2 (i_op2), 
				.o_sub (res_sub),
				.i_borrow (1'b0), 
				.o_borrow ( )
				);

multiplier_4bit multiplier     (.i_op1 (i_op1),
				.i_op2 (i_op2), 
				.o_mult (res_mult)
				);

bitwise_nand_4bit bitwise_nand (.i_op1 (i_op1), 
				.i_op2 (i_op2), 
				.o_dat (res_nand)
				);

bitwise_nor_4bit bitwise_nor   (.i_op1 (i_op1), 
				.i_op2 (i_op2), 
				.o_dat (res_nor)
				);

mux_4bit_5to1 mux1     (.i_dat0 (res_add), 
			.i_dat1 (res_sub), 
			.i_dat2 (res_mult[3 : 0]), 
			.i_dat3 (res_nand), 
			.i_dat4 (res_nor),
			.i_ctrl (i_ctrl), 
			.o_dat (o_dat [3 :0])
			);

mux_4bit_5to1 mux2     (.i_dat0 (4'b0),   // mux for four MSB of multiplier out
			.i_dat1 (4'b0), 
			.i_dat2 (res_mult [7 : 4]), 
			.i_dat3 (4'b0), 
			.i_dat4 (4'b0),
			.i_ctrl (i_ctrl), 
			.o_dat (o_dat [7 : 4])
			);

endmodule
