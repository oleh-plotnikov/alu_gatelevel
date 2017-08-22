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
			full_add  full_add_lsb (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_carry (i_carry),
						.o_sum (o_sum[i]),
						.o_carry (carry[i])
						);
		
		else if (i == WIDTH-1)
			full_add  full_add (.i_op1 (i_op1[i]), 
					    .i_op2 (i_op2[i]),
					    .i_carry (carry [i - 1]),
					    .o_sum (o_sum[i]),
					    .o_carry (o_carry)
					    );
		else 
			full_add  full_add_msb (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_carry (carry [i - 1]),
						.o_sum (o_sum[i]),
						.o_carry (carry[i])
						);
	end

endgenerate

endmodule
////////////////////////////////////////////////////////////////
////////////////////// PARAM_SUBSTRACTOR ///////////////////////
////////////////////////////////////////////////////////////////
module param_substractor (i_op1, i_op2, i_borrow, o_borrow, o_sub);

parameter WIDTH = 4;

input [WIDTH - 1 : 0] i_op1, i_op2; 
input i_borrow;
output o_borrow;
output [WIDTH - 1 : 0] o_sub;

wire [WIDTH - 2 : 0] borrow;

genvar i;

generate 

	for (i = 0; i < WIDTH; i = i + 1) begin : substractor
		if (i == 0)
			full_sub  full_sub_lsb (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_borrow (i_borrow),
						.o_sub (o_sub[i]),
						.o_borrow (borrow[i])
						);

		else if (i == WIDTH-1)
			full_sub  full_sub     (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_borrow (borrow [i - 1]),
						.o_sub (o_sub[i]),
						.o_borrow (o_borrow)
						);

		else 
			full_sub  full_sub_msb (.i_op1 (i_op1[i]), 
						.i_op2 (i_op2[i]),
						.i_borrow (borrow [i - 1]),
						.o_sub (o_sub[i]),
						.o_borrow (borrow[i])
						);
	end

endgenerate

endmodule
////////////////////////////////////////////////////////////////
/////////////////////// PARAM_MULTIPLIER ///////////////////////
////////////////////////////////////////////////////////////////
module param_multiplier (i_op1, i_op2, o_mult);

parameter WIDTH = 8;

input  [WIDTH - 1 : 0] i_op1, i_op2;
output [2*WIDTH - 1 : 0] o_mult;

wire [WIDTH - 1 : 0] interconnect [WIDTH - 1 : 0];
wire [(WIDTH - 2)*(WIDTH - 1) : 0] sum_w;
wire   [WIDTH - 2 : 0] carry;

genvar i, j;

generate

	for (i = 0; i < WIDTH; i = i + 1) begin : op1
		for (j = 0; j < WIDTH; j = j + 1) begin : op2		
			and AND (interconnect[i][j], i_op1[i], i_op2[j]);
		end
	end

	for (i = 0; i < WIDTH - 1; i = i +1) begin : sum_block

		if (i == 0) begin
			param_adder #(.WIDTH(WIDTH)) adder_block_lsb (.i_op1 ({1'b0, interconnect[i] [WIDTH - 1 : 1]}),
								      .i_op2 (interconnect[i+1] [WIDTH - 1 : 0]),
								      .o_sum ({sum_w[i * (WIDTH - 1) + (WIDTH - 2) : (WIDTH - 1) * i], o_mult [i + 1]}),
								      .i_carry (1'b0),
								      .o_carry (carry[i])
								      );

		end else if (i == WIDTH - 2) begin
			param_adder #(.WIDTH(WIDTH)) adder_block (.i_op1 ({carry[i - 1], sum_w[(i - 1) * (WIDTH - 1) + (WIDTH - 2) : (WIDTH - 1) * (i - 1)]}),
								  .i_op2 (interconnect[i+1] [WIDTH - 1 : 0]),
								  .o_sum (o_mult[WIDTH*2 - 2 : (WIDTH*2 - 2) - (WIDTH - 1)]),
								  .i_carry (1'b0),
								  .o_carry (o_mult[WIDTH*2 - 1])
								  );

		end else begin
			param_adder #(.WIDTH(WIDTH)) adder_block_msb (.i_op1 ({carry[i - 1], sum_w [(i - 1) * (WIDTH - 1) + (WIDTH - 2) : (WIDTH - 1) * (i - 1)]}),
								      .i_op2 (interconnect[i+1] [WIDTH -1 : 0]),
								      .o_sum ({sum_w[i * (WIDTH - 1) + (WIDTH - 2) : (WIDTH - 1) * i], o_mult[i + 1]}),
								      .i_carry (1'b0),
								      .o_carry (carry[i])
								      );
		end

assign o_mult[0] = interconnect[0][0]; // LSB of out

end
endgenerate

endmodule
//////////////////////////////////////////////////////////////
/////////////////// PARAM_BITWISE_NAND ///////////////////////
//////////////////////////////////////////////////////////////
module param_bitwise_nand (i_op1, i_op2, o_dat);

parameter WIDTH = 4;

input [WIDTH -1 : 0] i_op1, i_op2;

output [WIDTH - 1 : 0] o_dat;

nand NAND [WIDTH - 1 : 0] (o_dat, i_op1, i_op2);

endmodule
//////////////////////////////////////////////////////////////
/////////////////// PARAM_BITWISE_NOR ////////////////////////
//////////////////////////////////////////////////////////////
module param_bitwise_nor (i_op1, i_op2, o_dat);

parameter WIDTH = 4;

input [WIDTH - 1 : 0] i_op1, i_op2;

output [WIDTH - 1 : 0] o_dat;

genvar i;

nor NOR [WIDTH - 1 : 0] (o_dat, i_op1, i_op2);

endmodule
//////////////////////////////////////////////////////////////
/////////////////// DC ///////////////////////////////////////
//////////////////////////////////////////////////////////////
module dc (i_ctrl, o_dat);

input [2 : 0] i_ctrl;
output [4 : 0] o_dat;

wire [2 : 0] nctrl;

not NOT [2 : 0] (nctrl, i_ctrl);

and AND1 (o_dat[0], nctrl[2],   nctrl[1],   nctrl[0]);
and AND2 (o_dat[1], nctrl[2],   nctrl[1],  i_ctrl[0]);
and AND3 (o_dat[2], nctrl[2],  i_ctrl[1],   nctrl[0]);
and AND4 (o_dat[3], nctrl[2],  i_ctrl[1],  i_ctrl[0]);
and AND5 (o_dat[4], i_ctrl[2],   nctrl[1],   nctrl[0]);

endmodule
//////////////////////////////////////////////////////////////
/////////////////// PARAM_MUX_5IN ////////////////////////////
//////////////////////////////////////////////////////////////
module param_mux( i_ctrl, i_dat0, i_dat1, i_dat2, i_dat3, i_dat4, o_dat);

parameter WIDTH = 4;

input [2 : 0]   					i_ctrl;
input [WIDTH - 1 : 0]  i_dat0,i_dat1,i_dat2,i_dat3,i_dat4;
output[WIDTH - 1 : 0]  o_dat;

wire  [4 : 0] one_hot;
genvar i;

dc decoder (.i_ctrl (i_ctrl),
				.o_dat (one_hot)
				);

generate
	for( i = 0; i < WIDTH; i = i + 1) begin: MUX
		assign o_dat[i] = ( (one_hot[0] & i_dat0[i])|
				    (one_hot[1] & i_dat1[i])|
				    (one_hot[2] & i_dat2[i])|
				    (one_hot[3] & i_dat3[i])|
				    (one_hot[4] & i_dat4[i])
				  );	
	end
	
endgenerate

endmodule
//////////////////////////////////////////////////////////////
////////////////// PARAM_ALU_GATELEVEL ///////////////////////
//////////////////////////////////////////////////////////////
module alu_gate (i_op1, i_op2, i_ctrl, o_dat);

parameter WIDTH = 4;

input [WIDTH -1 : 0] i_op1, i_op2;
input [2 : 0] i_ctrl;

output  [WIDTH*2 - 1 : 0] o_dat;

wire [WIDTH - 1 : 0] res_add, res_sub, res_nand, res_nor;
wire [WIDTH*2 - 1 : 0] res_mult;

param_adder #(.WIDTH(WIDTH)) adder (.i_op1 (i_op1), 
				    .i_op2 (i_op2), 
				    .o_sum (res_add),
				    .i_carry (1'b0),
				    .o_carry ()
				   );

param_substractor #(.WIDTH(WIDTH)) substractor (.i_op1 (i_op1), 
						.i_op2 (i_op2), 
						.o_sub (res_sub),
						.i_borrow (1'b0), 
						.o_borrow ()
						);

param_multiplier #(.WIDTH(WIDTH)) multiplier  (.i_op1 (i_op1),
					       .i_op2 (i_op2), 
					       .o_mult (res_mult)
				              );

param_bitwise_nand #(.WIDTH(WIDTH)) bitwise_nand  (.i_op1 (i_op1), 
						   .i_op2 (i_op2), 
						   .o_dat (res_nand)
						  );

param_bitwise_nor #(.WIDTH(WIDTH)) bitwise_nor (.i_op1 (i_op1), 
					   	.i_op2 (i_op2), 
						.o_dat (res_nor)
					       );

param_mux #(.WIDTH(WIDTH)) mux1  (.i_dat0 (res_add), 
				  .i_dat1 (res_sub), 
				  .i_dat2 (res_mult[WIDTH - 1 : 0]), 
				  .i_dat3 (res_nand), 
				  .i_dat4 (res_nor),
				  .i_ctrl (i_ctrl), 
				  .o_dat (o_dat [WIDTH - 1 :0])
				  );

param_mux #(.WIDTH(WIDTH)) mux2 (.i_dat0 ({WIDTH{1'b0}}), 
				 .i_dat1 ({WIDTH{1'b0}}), 
				 .i_dat2 (res_mult [WIDTH*2 - 1 : WIDTH]), 
				 .i_dat3 ({WIDTH{1'b0}}), 
				 .i_dat4 ({WIDTH{1'b0}}),
				 .i_ctrl (i_ctrl), 
				 .o_dat (o_dat [WIDTH*2 - 1 : WIDTH])
				);

endmodule
//////////////////////////////////////////////////////////////
/////////////// PARAMETER_ALU_BEHAVIORAL /////////////////////
//////////////////////////////////////////////////////////////
module alu_behavioral (i_op1, i_op2, i_ctrl, o_dat);

parameter WIDTH = 4;

input	[WIDTH - 1 : 0] i_op1, i_op2;
input [2 : 0]	i_ctrl;

output reg [WIDTH*2 - 1 : 0] o_dat;

always @(*) begin
	case(i_ctrl)
		
		0: o_dat <= {{WIDTH{1'b0}}, i_op1 + i_op2};
		1: o_dat <= {{WIDTH{1'b0}}, i_op1 - i_op2};
		2: o_dat <= i_op1 * i_op2;
		3: o_dat <= {{WIDTH{1'b0}}, (~(i_op1 & i_op2))};
		4: o_dat <= {{WIDTH{1'b0}}, (~(i_op1 | i_op2))};
		default: o_dat = 0;

	endcase
end

endmodule
//////////////////////////////////////////////////////////////
/////////////// PARAM_ALU_TB /////////////////////////////////
//////////////////////////////////////////////////////////////
module alu_tb;

parameter WIDTH = 10;

reg [WIDTH - 1 : 0] op1, op2;
reg [2 : 0] ctrl;

wire[WIDTH*2 - 1 : 0] out_beh;
wire[WIDTH*2 - 1 : 0] out_gate;

integer i,j,k;
integer error_count;

event stop;

alu_behavioral #(.WIDTH(WIDTH)) alu_behavioral (.i_op1 (op1),
						.i_op2 (op2),
						.i_ctrl (ctrl),
						.o_dat (out_beh)
						);

alu_gate #(.WIDTH(WIDTH)) alu_gate (.i_op1 (op1),
				    .i_op2 (op2),
				    .i_ctrl (ctrl),
				    .o_dat (out_gate)
				    );  

initial begin
op1 = 0 ;
op2 = 0 ;
ctrl = 0 ;

  for ( i = 0 ; i < 5 ; i = i + 1 )
   for ( j = 0 ; j < 2**WIDTH ; j = j + 1 )
    for ( k = 0 ; k < 2**WIDTH ; k = k + 1 ) begin
      #10
      op1 = k ;
      op2 = j ;
      ctrl = i ;
    end
  #15;

->stop;

end

initial begin
error_count = 0;
#5
  forever begin #10
    if (out_beh !== out_gate )
    begin
      $display ("ERROR! out_beh = %d, out_gate = %d", out_beh, out_gate);
      $display ("op1 = %d\n, op2 = %d\n, ctrl = %d", op1, op2, ctrl);
      error_count = error_count + 1;
    end 
      
  end 
end

initial begin 
@(stop)
  if (error_count === 0)
   $display ("SUCCESS!, error_count = %d", error_count);
  else
   $display ("ERROR!, error_count = %d", error_count);
  $finish ();
end

endmodule
