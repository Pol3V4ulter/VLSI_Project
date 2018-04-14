module fsm2_tb();

reg in_clka, in_clkb, in_inp, in_run, in_wai, in_loseSig;
wire [2:0] out_state;
wire [8:0] out_count;
wire out_loadData, out_readData, out_writeData, out_win, out_writeout, out_restart;

FSM U1 (.clka (in_clka), .clkb (in_clkb), .inp (in_inp), .run (in_run), 
	.wai (in_wai), .loseSig (in_loseSig), .loadData (out_loadData),
	.readData (out_readData), .writeData (out_writeData), .win (out_win),
	.writeout (out_writeout), .restart (out_restart), .state (out_state),
	.count (out_count));

initial
begin

//1
in_inp = 0;
in_run = 0;
in_wai = 0;
in_loseSig = 0;
in_clka = 0;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//2
in_inp = 1;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//3
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//4
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//5
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//6
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//7
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//8
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//9
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//10
in_inp = 0;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//11
in_run = 1;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//12
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//13
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//14
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//15
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//16
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//17
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//18
in_clkb = 0;
#1 


//21
in_loseSig = 1;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//22
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//23
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//24
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//25
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//26
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

//27
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//28
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//29
in_loseSig = 0;
in_run = 0;
in_inp = 1;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//30
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//31
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
//32
in_inp = 0;
in_run = 1;
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1

in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
in_clkb = 0;
#1 
in_clka = 1;
#1 
in_clka = 0;
#1
in_clkb = 1;
#1
$dumpvars;
$display ("in_clka, in_clkb, in_inp, in_run, in_wai, in_loseSig");

$stop;
end

endmodule


