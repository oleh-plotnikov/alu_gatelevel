`timescale 1ns/1ps
//////////////////////////////////////////////////////////////
/////////////// ALU_BEHAVIORAL ///////////////////////////////
//////////////////////////////////////////////////////////////
module alu_behavioral (i_op1, i_op2, i_ctrl, o_dat);

input	[3 : 0] i_op1, i_op2;
input [2 : 0]	i_ctrl;

output reg [7 : 0] o_dat;

always @(*) begin
	case (i_ctrl)
		
		0: o_dat = {{4{1'b0}}, i_op1 + i_op2};
		1: o_dat = {{4{1'b0}}, i_op1 - i_op2};
		2: o_dat = i_op1 * i_op2;
		3: o_dat = {{4{1'b0}}, (~(i_op1 & i_op2))};
		4: o_dat = {{4{1'b0}}, (~(i_op1 | i_op2))};
		default: o_dat = 0;

	endcase
end

endmodule
