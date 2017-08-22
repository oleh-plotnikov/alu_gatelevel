`timescale 1 ns/1 ps
////////////////////////////////////////////////////////////////
/////////////////////// MULTIPLIER_4BIT_TB /////////////////////
////////////////////////////////////////////////////////////////
module multiplier_4bit_tb;

reg [3 : 0] i_op1, i_op2;
reg [7 : 0] golden_mult;

wire [7 : 0] o_mult;

integer i, j;
integer error_count;

event stop;

multiplier_4bit  multiplier      (.i_op1 (i_op1),
				  .i_op2 (i_op2),
				  .o_mult (o_mult)
				  );
									
initial begin // generate input data for i_op1, i_op2. // calculate golden model. 
#0;
		for (i = 0; i < 16; i = i + 1)
			for (j = 0; j < 16; j = j + 1) begin
				i_op1 = i;
				i_op2 = j;
				golden_mult = i_op1 * i_op2;
				#10;
			end
->stop;
end

initial begin // compare gate_model & golden model. // increment error if needed.
error_count = 0;
	forever begin
		 if (golden_mult !== o_mult) begin
			error_count = error_count + 1;
			$display ("op1 = %d, op2 = %d", i_op1, i_op2);
			$display ("ERROR, golden_mult = %d, o_mult = %d", golden_mult, o_mult);
			$display ("time = ", $time);
		end
	#10;
	end
end

initial begin // display final result tb on the console.
	@stop
	if (error_count == 0)
		$display ("SUCCESS! error_count = %d", error_count);
	else
		$display ("ERROR!  error_count = %d", error_count);
$finish();
end

endmodule
