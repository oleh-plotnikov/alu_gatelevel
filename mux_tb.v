`timescale 1ns/1ps
//////////////////////////////////////////////////////////////
////////////////// MUX_4BIT_5TO1_TB //////////////////////////
//////////////////////////////////////////////////////////////
module mux_4bit_5to1_tb;

reg  [2 : 0] i_ctrl;
reg  [3 : 0] i_dat0, i_dat1, i_dat2, i_dat3, i_dat4;
reg  [3 : 0] golden_mux;  

wire [3 : 0] o_dat;
 
integer i, n;
integer error_count;

event stop;

mux_4bit_5to1 mux      (.i_ctrl (i_ctrl),
			.i_dat0 (i_dat0),
			.i_dat1 (i_dat1), 
			.i_dat2 (i_dat2),
			.i_dat3 (i_dat3), 
			.i_dat4 (i_dat4),
			.o_dat (o_dat)
			);

initial begin

	for( n = 0; n < 5; n = n + 1 ) // iterate number of input in mux
		for( i = 0; i < 10; i = i +  1 ) begin
        		i_dat0 = $random;
        		i_dat1 = $random;
        		i_dat2 = $random;
       			i_dat3 = $random;
        		i_dat4 = $random;
        		i_ctrl= n;
			#10;
		end
#10->stop;
end
  
initial begin
 error_count=0;
  forever begin
  case(i_ctrl)

    0: golden_mux=i_dat0;  
    1: golden_mux=i_dat1;
    2: golden_mux=i_dat2;
    3: golden_mux=i_dat3;
    4: golden_mux=i_dat4;
    default: golden_mux = 0;

  endcase #10;
    if (golden_mux !== o_dat) begin //comparate golden model value with gatelevel model value of mux
      $display ("ERROR!!! golden_mux = %d, o_dat = %d",golden_mux, o_dat);
      $display ("i_ctrl = %d\ni_dat0 = %d\ni_dat1 = %d\ni_dat2 = %d\ni_dat3 = %d\ni_dat4 = %d\n",i_ctrl,i_dat0,i_dat1,i_dat2,i_dat3,i_dat4);
      error_count = error_count + 1;
    end
  end
end
  
initial begin 
@(stop) // display the final result tb on cosole
  if (error_count===0)
   $display ("SUCCESS, error_count = %d", error_count);
  else
   $display ("ERROR!!!, error_count =%d", error_count);
	$finish();
end

endmodule
