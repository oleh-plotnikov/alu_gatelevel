`timescale 1ns/1ps
////////////////////////////////////////////////////////////////
////////////////////// SUBSTRACTOR_4BIT_TB /////////////////////
////////////////////////////////////////////////////////////////
module substractor_4bit_tb;

reg [3 : 0] i_op1, i_op2;
reg i_borrow;

reg [3 : 0] golden_sub;
reg golden_borrow;

wire [3 : 0] o_sub;
wire o_borrow;

integer i, j;
integer error_count;

event stop;

substractor_4bit  substractor   (.i_op1 (i_op1),
				 .i_op2 (i_op2),
				 .i_borrow (i_borrow),
				 .o_sub (o_sub),
				 .o_borrow (o_borrow)
				 );
									
initial begin // generate input data for i_op1, i_op2, i_borrow. // calculate golden model. 
#0;
i_borrow = 0;
	repeat(2) begin
		for (i = 0; i < 16; i = i + 1)
			for (j = 0; j < 16; j = j + 1) begin
				i_op1 = i;
				i_op2 = j;
				{golden_borrow, golden_sub} = i_op1 - i_op2 - i_borrow;
				#10;
			end
	i_borrow = ~i_borrow; 
	end
->stop;
end

initial begin // compare rtl_model & golden model. // increment error.
error_count = 0;
	forever begin
		 if ((golden_borrow !== o_borrow) || (golden_sub !== o_sub)) begin
			error_count = error_count + 1;
			$display ("op1 = %d, op2 = %d, borrow = %d", i_op1, i_op2, i_borrow);
			$display ("ERROR, golden_sub = %d, o_sub = %d,\n\tgolden_borrow = %d, o_borrow = %d,", golden_sub, o_sub, golden_borrow, o_borrow);
			$display("time = ", $time);
		end
	#10;
	end
end

initial begin // display final result tb on the console.
	@stop
	if( error_count == 0 )
		$display("SUCCESS! error_count = %d", error_count);
	else
		$display("ERROR!  error_count = %d", error_count);
$finish();
end

endmodule
