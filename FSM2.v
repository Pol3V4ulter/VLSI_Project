// File Name   : 2 Phase Clock fsm_using_function.v  0 - 3 - 1 - 2 
// with count hold input and odd output
//-----------------------------------------------------
module FSM (clka, clkb, timer5, inp, run, wai, reset, loadData,readData,writeData,writeout, win, lose, loseSig, state,count,countWriteout, restart);
//-------------Input Ports-----------------------------
input   clka, clkb, timer5, inp, run, wai,reset,loseSig;
//-------------Output Ports----------------------------
output  state[2:0], loadData, readData, writeData,count[3:0],countWriteout[8:0],win, lose, writeout, restart;
//-------------Input ports Data Type-------------------
wire    clka, clkb, timer5, inp, run, wai,reset, loseSig;
//-------------Output Ports Data Type------------------
reg     loadData, readData, writeData,win, lose, writeout, restart;  //state and count defined under Internal Variables
wire	loadDataCheck, readDataCheck, restartCheck;
//Internal Constants--------------------------
parameter SIZE = 3;
parameter SIZE1 = 9;
parameter SIZEC = 4;
parameter IDLE = 3'b000, INPUT  = 3'b010, WAIT = 3'b101, RESTART = 3'b111;
parameter IREAD = 3'b011, WRITEOUT = 3'b100, WIN1 = 3'b001, LOSE1 = 3'b110;
parameter FIN = 9'b000110010, BEG = 9'b000000000, ONECYCLE = 4'b1111; 
parameter WIN = 15'b110010111111111;
parameter FIN1 = 4'b1111;
//parameter IWRITE  = 3'b111, PAUSE = 3'b110, 
//-------------Internal Variables---------------------------
reg   [SIZE-1:0]          state        ;// Seq part of the FSM
wire   [SIZE-1:0]          temp_state   ;// Internal state reg
//wire   [SIZE-1:0]          temp_inpstate   ;// Internal state reg
reg   [SIZE-1:0]          next_state   ;// combo part of FSM

reg     [SIZEC-1:0]         count      ;//9-bit counter
wire  [SIZEC-1:0]           temp_count ;
reg   [SIZEC-1:0]         next_count   ;

reg     [SIZE1-1:0]         countWait      ;
wire  [SIZE1-1:0]           temp_countWait ; 
reg   [SIZE1-1:0]         next_countWait   ; 

reg     [SIZE1-1:0]         countWriteout      ;
wire  [SIZE1-1:0]           temp_countWriteout ;
reg   [SIZE1-1:0]         next_countWriteout   ;
//----------Code startes Here------------------------
assign temp_state = fsm_function(state,count,inp, run, wai);
//assign temp_inpstate = fsminp_function(restart);
assign temp_count = count_function(count,inp, loadData, readData, restart);
assign temp_countWait = countWait + 1'b1;
assign temp_countWriteout = countWriteout + 1'b1;
assign loadDataCheck = loadData;
assign readDataCheck = readData;
assign restartCheck = restart;
//assign checkVal


function [SIZE-1:0] fsm_function;
  input  [SIZE-1:0] state;
  input [SIZEC-1:0] count;
  //input  hold;
  input inp;
  input run;
  input wai;
//  fsm_function = IDLE;

  case(state)
  IDLE: begin
    if (reset == 1'b1) begin
        fsm_function = RESTART;
	end else if(inp == 1'b1) begin
		fsm_function = INPUT;
    end else if(run==1'b1) begin
        if(loseSig|wai|(timer5==1'b0)) begin //constant to be replaced with WIN
            fsm_function = WAIT;	
		end else begin
            fsm_function = IREAD;
        end
	end else if(wai==1'b1) begin
		fsm_function = WAIT;
    end else begin
        fsm_function = IDLE;      
    end
    end
  INPUT: begin
    if (count>=ONECYCLE) begin
        fsm_function = WRITEOUT;
    end else begin
        fsm_function = INPUT;
    end
    end
  IREAD: begin
    if (count>=ONECYCLE)begin				//temporary constant, to be replaced with TWOCYCLE
		fsm_function = WRITEOUT;
    end else begin
    	fsm_function = IREAD; 
    end
    end
  WRITEOUT: begin
    fsm_function = IDLE;
    end 
  WIN1: begin
    if (reset == 1'b1) begin
        fsm_function = RESTART;
    end else begin
        fsm_function = WIN1;      
    end
    end
  LOSE1: begin
    if (reset == 1'b1) begin
        fsm_function = RESTART;
    end else begin
        fsm_function = LOSE1;      
    end
    end
  WAIT: begin
    if (loseSig == 1'b1) begin
    	fsm_function = LOSE1;
    end else if (countWriteout>=FIN) begin //constant to be replaced with WIN
    	fsm_function = WIN1;
    end else if (wai == 1'b0)begin
		if (timer5 == 1'b1) begin
			fsm_function = IDLE;
		end
    end else begin
       fsm_function = WAIT;
    end
    end
  RESTART: begin
	if (reset == 1'b1) begin
        fsm_function = RESTART;
    end else if(inp==1'b1) begin
        fsm_function = INPUT;    
	end else begin
		fsm_function = IDLE;
    end
	end
  default: fsm_function = IDLE;
  endcase

endfunction


//----------Function for Combo Logic-----------------

function [SIZEC-1:0] count_function; //output is temp_count
  input  [SIZEC-1:0] count;
  input inp;
  //input  [SIZE - 1:0] state;
  input  loadData;
  input	 readData;
  input  restart;
  if((restart==1'b1)|((loadData==1'b0)&(readData==1'b0))) begin
	//if(inp==1'b1) begin
		count_function = BEG;
		//next_countWait <= temp_countWait;
		//next_countWriteout <= BEG; //temp_countWriteout;
		//next_state <= temp_state;
	end else begin
		count_function = count+1'b1;
		//next_countWait <= temp_countWait;
		//next_countWriteout <= temp_countWriteout;
		//next_state <= temp_state;
	end    
endfunction


always @ (posedge clka)
begin : FSM_SEQ    
	
	if(reset==1'b1) begin
	//if(inp==1'b1) begin
		next_count <= temp_count;
		//next_countWait <= temp_countWait;
		next_countWriteout <= BEG; //temp_countWriteout;
		next_countWait <= BEG;
		next_state <= RESTART; //temp_inpstate;
	end else begin
		next_count <= temp_count;
		next_countWait <= temp_countWait;
		next_countWriteout <= temp_countWriteout;
		next_state <= temp_state;
	end    
end

//----------Output Logic
always @ (posedge clkb)
begin : OUTPUT_LOGIC
  state <= next_state;
  case(next_state)
  INPUT: begin 
       loadData <= 1'b1;
       readData <= 1'b0; 
       writeData <= 1'b1;
       writeout <= 1'b0;
       restart <= 1'b0;
		win <= 1'b0;
		lose <= 1'b0;
		count <= next_count;
       //countWriteout <= 1'b0;       
       end
   IREAD: begin
       loadData <= 1'b0;
       readData <= 1'b1; 
       writeData <= 1'b1;
       count <= next_count;
       //countWait <= next_countWait;
       writeout <= 1'b0;
       restart <= 1'b0;
       end
   WRITEOUT: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b1;
       countWriteout <= next_countWriteout;
       restart <= 1'b0;
       end     
   RESTART: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;	//we don't want to write until in writeout state, right?
       countWait <= next_countWait;
       restart <= 1'b1;
       win <= 1'b0;
	   lose <= 1'b0;
       count <= next_count;
		countWriteout <= next_countWriteout;
       countWait <= next_countWait;
       end 
   WIN1: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;
       win <= 1'b1;
	   lose <= 1'b0;
       end  
   LOSE1: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;
       win <= 1'b0;
	   lose <= 1'b1;
       end         
  WAIT: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;
       //countWait <= next_countWait; //I don't think we want to count while waiting?
       end     						  //If we wait 49, then read/write once we don't want to win
  default: begin
	loadData <= 1'b0;
	readData <= 1'b0; 
	writeData <= 1'b0; 
    writeout <= 1'b0;
    //count <= BEG;
	end
  endcase
end // End Of Block OUTPUT_LOGIC

endmodule // End of Module FSM
