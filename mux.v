`timescale 1ns/1ps
//////////////////////////////////////////////////////////////
////////////////// MUX_5TO1 //////////////////////////////////
//////////////////////////////////////////////////////////////
module temp (i_ctrl, i_dat, o_dat);

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


or OR (o_dat, dat[4], dat[3], dat[2], dat[1], dat[0]);

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
