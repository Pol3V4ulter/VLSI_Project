//-----------------------------------------------------
// Design Name : top_module
// File Name   : top_module.v
//
// Function    : top file call main_FSM controller.
//               When in_load goes high, main_FSM issues start
//               to count_FSM which produces 4 control pulses.
//               The dp datapath then uses the 4 control pulses to
//               serially shift in in_d_in to a register. The dp
//               then increments that value and returns the value to
//               this top module.
//-----------------------------------------------------
module top_module(in_clka, in_clkb,in_timer5, in_inp,in_run,in_wai,in_reset,in_DataIn, con_loadData, con_readData, con_writeData,con_writeout,con_restart, out_MuxData,out_MemBData, out_lose, con_loseSig,out_win,out_state, con_count,con_countWriteout, out_temp_addNum);
//-------------Input Ports-----------------------------
//input   in_clka, in_clkb, in_restart, in_load, in_d_in;
input    in_clka, in_clkb, in_timer5, in_inp, in_run, in_wai, in_reset, in_DataIn;

//-------------Output Ports----------------------------
//output  out_start;
//output [1:0] out_state_main; 
//output [3:0] out_d_out;
output out_state[2:0], out_MuxData [15:0], out_MemBData [15:0], con_count [3:0],  con_countWriteout [8:0];
//output con_same, con_savepattern, con_savetest, out_match,out_error,con_clearCon, con_loadA, con_loadB, con_loadC, con_loadD;
output con_loadData,con_readData,con_writeData,con_writeout,con_loseSig,out_win, con_restart, out_temp_addNum, out_lose;
//output out_DO0, out_DO1, out_DO2, out_DO3;
//-------------Input ports Data Type-------------------
wire    in_clka, in_clkb, in_timer5, in_inp,in_run,in_wai,in_reset;
wire in_DataIn;
wire     [3:0] con_count      ;
wire     [8:0] con_countWriteout      ;

//-------------Output Ports Data Type------------------
//wire     out_start;
//wire in_done;
//wire  [1:0] out_state_main;
//wire  [3:0] out_state_count;
//wire in_d_in;
//wire  [3:0] out_d_out;
//wire  [3:0] out_op_right;
//module dataPath (clka,clkb,xData, yData, accumData, accumCon, loadX,loadY, loadTemp, clearCon);
//reg in_clka, in_clkb, in_restart, in_load, in_Not, in_data0, in_data1, in_data2, in_data3;
wire con_loadData,con_readData,con_writeData,con_writeout,con_loseSig,out_win, out_lose;
wire [15:0] out_MuxData;
wire [15:0] out_MemBData;
wire [2:0] out_temp_addNum;


wire [2:0] out_state;
//----------Code startes Here------------------------

dataPath U2 (.clka (in_clka),
	   .clkb (in_clkb),
	   .restart (con_restart),
	   .loadData (con_loadData),
	   .readData (con_readData),
	   .writeData (con_writeData),
	   .writeout (con_writeout),
	   .MuxData (out_MuxData),
	   .MemBData (out_MemBData),
	   .DataIn (in_DataIn),
	   .loseSig (con_loseSig),
	   .count (con_count)
        );
//, .temp_addNumTest (out_temp_addNum)
          
//module dataPath (clka,clkb,loadData, readData, writeData,writeout,MuxData,MuxDataOut, loseSig,count);

 FSM U1 (.clka (in_clka),
           .clkb (in_clkb),
		   .timer5 (in_timer5),
           .inp (in_inp),
        .run (in_run),
        .wai (in_wai),
		.reset (in_reset),
       .loadData (con_loadData),
       .readData (con_readData),
	   .writeData (con_writeData),
	   .writeout (con_writeout),
	   .win (out_win),
	.lose (out_lose),
       .loseSig (con_loseSig),
	   .state (out_state),
       .count (con_count),
	   .countWriteout (con_countWriteout),
       .restart (con_restart)
          );
          

//module FSM (clka, clkb, inp, run, wai, loadData,readData,writeData,writeout, win,loseSig, state,count, restart);





endmodule // End of Module top_module
                                    
