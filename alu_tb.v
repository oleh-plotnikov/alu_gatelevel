`timescale 1ns/1ps
//////////////////////////////////////////////////////////////
/////////////// ALU_TB ///////////////////////////////////////
//////////////////////////////////////////////////////////////
module alu_tb;

reg [3 : 0] op1, op2;
reg [2 : 0] ctrl;

wire[7 : 0] out_beh;
wire[7 : 0] out_gate;

integer i, j, k, error_count;

event stop;

alu_behavioral alu_behavioral  (.i_op1 (op1),
				.i_op2 (op2),
				.i_ctrl (ctrl),
				.o_dat (out_beh)
				);

alu_gate alu_gate      (.i_op1 (op1),
			.i_op2 (op2),
			.i_ctrl (ctrl),
			.o_dat (out_gate)
			);  

initial begin // generate input data for i_op1, i_op2, and ctrl
op1 = 0 ;
op2 = 0 ;
ctrl = 0 ;

  for ( i = 0 ; i < 5 ; i = i + 1 )
   for ( j = 0 ; j < 16 ; j = j + 1 )
    for ( k = 0 ; k < 16 ; k = k + 1 ) begin
      #10
      op1 = k ;
      op2 = j ;
      ctrl = i ;
    end
  #15;

->stop;

end

initial begin // compare behavioral_model & gate_model. // increment error if needed.
error_count = 0;

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
