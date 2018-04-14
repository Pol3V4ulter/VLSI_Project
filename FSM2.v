
// File Name   : 2 Phase Clock fsm_using_function.v  0 - 3 - 1 - 2 
// with count hold input and odd output
//-----------------------------------------------------
module FSM (clka, clkb, inp, run, wai, loadData,readData,writeData,writeout, win,loseSig, state,count, restart);
//-------------Input Ports-----------------------------
input   clka, clkb, inp, run, wai,loseSig;
//-------------Output Ports----------------------------
output  state[2:0], loadData, readData, writeData,count[8:0],win,writeout, restart;
//-------------Input ports Data Type-------------------
wire    clka, clkb, inp, run, wai, loseSig;
//-------------Output Ports Data Type------------------
reg     loadData, readData, writeData,win, writeout, restart;  //state and count defined under Internal Variables
//Internal Constants--------------------------
parameter SIZE = 3;
parameter SIZE1 = 9;
parameter SIZEC = 4;
//parameter run= 3'b001, wai = 3'b101, NOrun= 3'b010, inp = 3'b111, NOinp = 3'b100;
//parameter LOAD= 3'b001, NOT = 3'b101, NOLOAD= 3'b010, RESTART = 3'b111, NORESTART = 3'b100;
parameter IDLE = 3'b000, INPUT  = 3'b010, WAIT = 3'b101, RESTART = 3'b111;
parameter FIN = 9'b111111111, BEG = 9'b000000000, ONECYCLE = 9'b000001111, TWOCYCLE = 9'b100000000, ONEITER = 9'b000000001; // NOrun= 3'b010, inp = 3'b111, NOinp = 3'b100;
parameter WIN = 15'b110010111111111;
parameter IREAD = 3'b011, WRITEOUT = 3'b100, WIN1 = 3'b001, LOSE1 = 3'b110; // RUN= 3'b001, WAIT = 3'b101, FIN = 9'b111111111; // NOrun= 3'b010, inp = 3'b111, NOinp = 3'b100;
parameter FIN1 = 4'b1111;
//parameter IWRITE  = 3'b111, PAUSE = 3'b110, 
//-------------Internal Variables---------------------------
reg   [SIZE-1:0]          state        ;// Seq part of the FSM
wire   [SIZE-1:0]          temp_state   ;// Internal state reg
reg   [SIZE-1:0]          next_state   ;// combo part of FSM

reg     [SIZE1-1:0]         count      ;//9-bit counter
wire  [SIZE1-1:0]           temp_count ;
reg   [SIZE1-1:0]         next_count   ;

reg     [SIZE1-1:0]         countWait      ;
wire  [SIZE1-1:0]           temp_countWait ; 
reg   [SIZE1-1:0]         next_countWait   ; 

reg     [SIZE-1:0]         countWriteout      ;
wire  [SIZE-1:0]           temp_countWriteout ;
reg   [SIZE-1:0]         next_countWriteout   ;
//----------Code startes Here------------------------
assign temp_state = fsm_function(state,count,inp, run, wai);
assign temp_count = count_function(count);
assign temp_countWait = countWait + 1'b1;
assign temp_countWriteout = countWriteout + 1'b1;

function [SIZE-1:0] fsm_function;
  input  [SIZE-1:0] state;
  input [SIZE1-1:0] count;
  //input  hold;
  input inp;
  input run;
  input wai;
//  fsm_function = IDLE;

  case(state)
  IDLE: begin
    if (inp == 1'b1) begin
        fsm_function = RESTART;
    end else if(run==1'b1) begin
        if(loseSig|(countWait==WIN)|wai) begin
            fsm_function = WAIT;

	//end else if  begin
        //    fsm_function = WRITEOUT;
	
		end else begin
            fsm_function = IREAD;
        end
    end else begin
        fsm_function = IDLE;      
    end
    end
  INPUT: begin
    //if (count>=ONECYCLE) begin
        fsm_function = WRITEOUT;
    //end else begin
    //    fsm_function = INPUT;
    //end
    end
  IREAD: begin
    if (count>=3'b100)begin				//temporary constant, to be replaced with TWOCYCLE
		fsm_function = WRITEOUT;
    end else begin
    	fsm_function = IREAD; 
    end
    end
//  IWRITE: begin
//    //fsm_function = IREAD;
//    if (count[SIZEC-1:0]==ONECYCLE) begin
//        fsm_function = WRITEOUT;
//        //end
//    end else begin
//        fsm_function = IREAD;
//    end
//    end
  WRITEOUT: begin
    //if (countWriteout>2'b11) begin			//temporary constant, to be replaced with FIN
        fsm_function = IDLE;
    //end else begin
      //  fsm_function = WRITEOUT;
    //end
    end    
//  PAUSE : begin
//        if (countWait==WIN) begin
//            fsm_function = WIN1;
//	end else if (loseSig == 1'b1) begin
//	    fsm_function = LOSE1; 
//    	end else begin
//            fsm_function = PAUSE;
//    end
//    end
  WIN1: begin
    if (inp == 1'b1) begin
        fsm_function = INPUT;
    end else begin
        fsm_function = WIN1;      
    end
    end
  LOSE1: begin
    if (inp == 1'b1) begin
        fsm_function = INPUT;
    end else begin
        fsm_function = LOSE1;      
    end
    end
  WAIT: begin
    if (loseSig == 1) begin
    	fsm_function = LOSE1;
    end else if (countWait==2'b11) begin //constant to be replaced with WIN
    	fsm_function = WIN1;
    end else if (wai == 1'b0)begin
        fsm_function = IDLE;
    end else begin
       fsm_function = WAIT;
    end
    end
  RESTART: begin
  	 fsm_function = INPUT;
	end
  default: fsm_function = IDLE;
  endcase

endfunction

//----------Function for Combo Logic-----------------
/*
function [SIZE-1:0] fsm_function;
  input  [SIZE-1:0] state;
  //input  hold;
  input run;
  input wai;
  input inp;
  if (inp==1'b1) begin
    fsm_function = INPUT;
  end else begin
       if (run == 1'b1) begin
			case(state)
			RUN: begin
				fsm_function = RUN;
				end
			IDLE: begin
				fsm_function = IDLE;
				end
			IREAD: begin
				fsm_function = IREAD;
				end
			default: fsm_function = IDLE;
			endcase
	   end else begin
			case(state)
			RUN: begin
				fsm_function = RUN;
				end
			WAIT: begin
				fsm_function = WAIT;
				end	
			IDLE: begin
				if (wai == 1'b1) begin
					fsm_function = IREAD;
				end else begin
					fsm_function = IWRITE;
				end
               end
			default: fsm_function = IDLE;
			endcase			
       end
  end
endfunction
*/

//----------Function for Combo Logic-----------------
function [SIZE1-1:0] count_function; //output is temp_count
  input  [SIZE1-1:0] count;
  //input  hold;
  //input load;
  //input Not;temp_countWait
  //input restart;
  case(count)
  FIN: begin
    count_function = BEG;
    end
  default: count_function = count+1'b1;
  endcase
endfunction

//----------Function for Combo Logic-----------------
/*
function [SIZE1-1:0] count_function;
  input  [SIZE1-1:0] count;
  //input  hold;
  //input run;
  //input wai;
  //input inp;
  case(count)
  FIN: begin
    count_function = BEG;
    end
  default: count_function = count;
  endcase
endfunction
*/

always @ (posedge clka)
begin : FSM_SEQ
  //if (inp == 1'b1) begin
  //  next_state <= RESET;
  //  next_count <= temp_count;
    //next_count <= BEG;
  //  next_countWait <= BEG;
  //  next_countWriteout <= BEG;
  //end else begin
	begin
    next_state <= temp_state;
    next_count <= temp_count;
    next_countWait <= temp_countWait;
    next_countWriteout <= temp_countWriteout;
  end
end

//----------Seq Logic-----------------------------
/*
always @@ (posedge clka)
begin : FSM_SEQ
  if (inp == 1'b1) begin
    next_state <= inp;
    next_count <= BEG;
  end else begin
    next_state <= temp_state;
    next_count <= temp_count;
  end
end
*/

//----------Output Logic
always @ (posedge clkb)
begin : OUTPUT_LOGIC
  state <= next_state;
  case(next_state)
  INPUT: begin 
       loadData <= 1'b1;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;
       restart <= 1'b0;
	win <= 1'b0;
       count <= next_count;
       countWriteout <= 1'b0;
       countWait <= next_countWait;
       end
   IREAD: begin
       loadData <= 1'b0;
       readData <= 1'b1; 
       writeData <= 1'b0;
       count <= next_count;
       writeout <= 1'b0;
       restart <= 1'b0;
       end
   //IWRITE: begin
   //    loadData = 1'b0;
   //    readData = 1'b0; 
   //    writeData = 1'b1;
   //    count <= next_count;
   //    end   
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
       restart <= 1'b1;
	win <= 1'b0;
	count <= 1'b0;
	//countWriteout <= 1'b0;
       //countWait <= next_countWait;
       end 
   WIN1: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;
       win <= 1'b1;
       end  
   LOSE1: begin
       loadData <= 1'b0;
       readData <= 1'b0; 
       writeData <= 1'b0;
       writeout <= 1'b0;
       win <= 1'b0;
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

//----------Output Logic
/*
always @@ (posedge clkb)
begin : OUTPUT_LOGIC
  state <= next_state;
  count <= next_count+1; //count +1;
  case(next_state)
  IDLE: begin 
		  loadData = 1'b0;
		  writeData = 1'b1; 
		  readData = 1'b0;     
          //count <= BEG;
        end
  INPUT: begin 
	      loadData = 1'b1;
		  writeData = 1'b0; 
		  readData = 1'b0;  
          //count <= count +1;          
        end   
  IREAD: begin
		  loadData = 1'b0;
		  writeData = 1'b0; 
		  readData = 1'b1; 
          //count  <= count +1;
		end   
  default: begin
		  loadData = 1'b0;
		  writeData = 1'b0; 
		  readData = 1'b0; 
          //count <= count +1;
		end
  endcase
  
end // End Of Block OUTPUT_LOGIC
*/
endmodule // End of Module FSM
