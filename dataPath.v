//-----------------------------------------------------
// File Name   : 2 Phase Clock fsm_using_function.v  0 - 3 - 1 - 2 
// with count hold input and odd output
//-----------------------------------------------------
//module FSM (clka, clkb, restart, clearCon, strtPipe, loadV, loadX,loadY,loadW,loadR1,loadR2,state);
module dataPath (clka,clkb,restart, loadData, readData, writeData,writeout,MuxData, MemBData, DataIn, loseSig,count);
//-------------Input Ports-----------------------------
input   clka,clkb,restart, loadData, readData, writeData, writeout, DataIn, count[3:0];
//-------------Output Ports----------------------------
output  loseSig, MuxData[15:0],MemBData[15:0]; 
//temp_addNumTest[2:0]; 
wire loadData, readData, writeData,writeout, DataIn;

reg contin, loseSig;
//Internal Constants--------------------------
parameter SIZE = 16;
parameter SIZE1 = 4;
parameter SIZEC = 4;
parameter SIZENUM = 3;

parameter CLEARCOUN  = 4'b0000, CLEARADD = 3'b000, LOAD= 3'b001, NOT = 3'b101, NOLOAD= 3'b010, RESTART = 3'b111;
parameter FIN = 4'b1111, ZERO = 4'b0000, ONE = 4'b0001, TWO = 4'b0010, THREE = 4'b0011, FOUR = 4'b0100, FIVE = 4'b0101, SIX = 4'b0110, SEVEN = 4'b0111, EIGHT = 4'b1000;
parameter NINE = 4'b1001, TEN = 4'b1010, ELEVEN = 4'b1011, TWELVE = 4'b1100, THIRTEEN = 4'b1101, FOURTEEN = 4'b1110, FIFTEEN = 4'b1111;
parameter TWOONECYCLE = 9'b0000, TWOCYCLE = 9'b100000000, ONEITER = 9'b000000001;
parameter CLEAR = 16'b0000000000000000;

//-------------Internal Variables---------------------------
reg  [SIZE-1:0]          MuxData           ;
wire     [SIZE1-1:0]         count      ;
wire    [SIZENUM-1:0]       temp_addNum     ;
reg    [SIZENUM-1:0]       temp_addNumTest     ;
reg  [SIZE-1:0]          MemBData           ;
wire [SIZE-1:0]			temp_MuxData	;
reg  [SIZE-1:0]			next_MuxData	;

//----------Code startes Here------------------------
//assign tempSimBit = mux_function(MuxData,count);
assign temp_addNum = add_function(count,MuxData);
assign temp_MuxData = MemBData;

//----------------------add function ----------------------
function [SIZEC-1:0]add_function;
  input [SIZE1-1:0] count;
  input [SIZE-1:0]  MuxData;
  
    if (count[SIZEC-1:0]==ZERO) begin
        add_function = MuxData[1]+MuxData[4]+MuxData[5]+MuxData[15]+MuxData[12]+MuxData[13]+MuxData[3]+MuxData[7];
    end else if(count[SIZEC-1:0]==ONE) begin
        add_function = MuxData[0]+MuxData[4]+MuxData[5]+MuxData[6]+MuxData[2]+MuxData[12]+MuxData[13]+MuxData[14];
    end else if(count[SIZEC-1:0]==TWO) begin
        add_function = MuxData[1]+MuxData[5]+MuxData[6]+MuxData[7]+MuxData[3]+MuxData[13]+MuxData[14]+MuxData[15];
    end else if(count[SIZEC-1:0]==THREE) begin
        add_function = MuxData[2]+MuxData[6]+MuxData[7]+MuxData[4]+MuxData[0]+MuxData[14]+MuxData[15]+MuxData[12];
    end else if(count[SIZEC-1:0]==FOUR) begin
        add_function = MuxData[7]+MuxData[11]+MuxData[8]+MuxData[9]+MuxData[5]+MuxData[3]+MuxData[0]+MuxData[1];
    end else if(count[SIZEC-1:0]==FIVE) begin
        add_function = MuxData[4]+MuxData[8]+MuxData[9]+MuxData[10]+MuxData[6]+MuxData[0]+MuxData[1]+MuxData[2];
    end else if(count[SIZEC-1:0]==SIX) begin
        add_function = MuxData[5]+MuxData[9]+MuxData[10]+MuxData[11]+MuxData[7]+MuxData[1]+MuxData[2]+MuxData[3];
    end else if(count[SIZEC-1:0]==SEVEN) begin
        add_function = MuxData[6]+MuxData[10]+MuxData[11]+MuxData[8]+MuxData[4]+MuxData[2]+MuxData[3]+MuxData[0];
    end else if(count[SIZEC-1:0]==EIGHT) begin
        add_function = MuxData[11]+MuxData[15]+MuxData[12]+MuxData[13]+MuxData[9]+MuxData[7]+MuxData[4]+MuxData[5];
    end else if(count[SIZEC-1:0]==NINE) begin
        add_function = MuxData[8]+MuxData[12]+MuxData[13]+MuxData[14]+MuxData[10]+MuxData[4]+MuxData[5]+MuxData[6];
    end else if(count[SIZEC-1:0]==TEN) begin
        add_function = MuxData[9]+MuxData[13]+MuxData[14]+MuxData[15]+MuxData[11]+MuxData[5]+MuxData[6]+MuxData[7];
    end else if(count[SIZEC-1:0]==ELEVEN) begin
        add_function = MuxData[10]+MuxData[14]+MuxData[15]+MuxData[12]+MuxData[8]+MuxData[6]+MuxData[7]+MuxData[4];
    end else if(count[SIZEC-1:0]==TWELVE) begin
        add_function = MuxData[15]+MuxData[3]+MuxData[0]+MuxData[1]+MuxData[13]+MuxData[11]+MuxData[8]+MuxData[9];
    end else if(count[SIZEC-1:0]==THIRTEEN) begin
        add_function = MuxData[12]+MuxData[0]+MuxData[1]+MuxData[2]+MuxData[14]+MuxData[8]+MuxData[9]+MuxData[10];
    end else if(count[SIZEC-1:0]==FOURTEEN) begin
        add_function = MuxData[13]+MuxData[1]+MuxData[2]+MuxData[3]+MuxData[15]+MuxData[9]+MuxData[10]+MuxData[11];
    end else if(count[SIZEC-1:0]==FIFTEEN) begin  
        add_function = MuxData[14]+MuxData[2]+MuxData[3]+MuxData[0]+MuxData[12]+MuxData[10]+MuxData[11]+MuxData[8];  
    end
endfunction


always @ (posedge clkb)
begin : Load_SEQ2
	if(restart==1'b1) begin	
		loseSig <= 1'b0;
	end else begin
		if(writeout==1'b1) begin
			if(contin==1'b0) begin
				loseSig <= 1'b1;
			end
		end
		next_MuxData <= temp_MuxData;
		temp_addNumTest <= temp_addNum;
	end
end

always @ (posedge clka)
begin : Load_SEQ  
  	if(restart ==1'b1) begin
		MuxData <= CLEAR;
		MemBData <= CLEAR;		
		contin =1'b0;
	end
	if(writeData==1'b1) begin		
		if(readData==1'b1) begin			
			if(count[SIZEC-1:0]==ZERO) begin
				contin = 1'b0;
			end else if (temp_addNum>=3'b001) begin
				contin = 1'b1;
			end
			
			if (count[SIZEC-1:0]==ZERO) begin				
				MemBData[0] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==ONE) begin
				MemBData[1] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==TWO) begin
				MemBData[2] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==THREE) begin
				MemBData[3] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==FOUR) begin
				MemBData[4] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==FIVE) begin
				MemBData[5] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==SIX) begin
				MemBData[6] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==SEVEN) begin
				MemBData[7] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==EIGHT) begin
				MemBData[8] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==NINE) begin
				MemBData[9] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==TEN) begin
				MemBData[10] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==ELEVEN) begin
				MemBData[11] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==TWELVE) begin
				MemBData[12] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==THIRTEEN) begin
				MemBData[13] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==FOURTEEN) begin
				MemBData[14] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);
			end else if(count[SIZEC-1:0]==FIFTEEN) begin  
				MemBData[15] <= (temp_addNum>=3'b011)&(temp_addNum<=3'b101);    
			end 
			
			
		end else if(loadData==1'b1) begin
			
			contin = 1'b1;
			if (count[SIZEC-1:0]==ZERO) begin
				MemBData[0] <= DataIn;
			end else if(count[SIZEC-1:0]==ONE) begin
				MemBData[1] <= DataIn;
			end else if(count[SIZEC-1:0]==TWO) begin
				MemBData[2] <= DataIn;
			end else if(count[SIZEC-1:0]==THREE) begin
				MemBData[3] <= DataIn;
			end else if(count[SIZEC-1:0]==FOUR) begin
				MemBData[4] <= DataIn;
			end else if(count[SIZEC-1:0]==FIVE) begin
				MemBData[5] <= DataIn;
			end else if(count[SIZEC-1:0]==SIX) begin
				MemBData[6] <= DataIn;
			end else if(count[SIZEC-1:0]==SEVEN) begin
				MemBData[7] <= DataIn;
			end else if(count[SIZEC-1:0]==EIGHT) begin
				MemBData[8] <= DataIn;
			end else if(count[SIZEC-1:0]==NINE) begin
				MemBData[9] <= DataIn;
			end else if(count[SIZEC-1:0]==TEN) begin
				MemBData[10] <= DataIn;
			end else if(count[SIZEC-1:0]==ELEVEN) begin
				MemBData[11] <= DataIn;
			end else if(count[SIZEC-1:0]==TWELVE) begin
				MemBData[12] <= DataIn;
			end else if(count[SIZEC-1:0]==THIRTEEN) begin
				MemBData[13] <= DataIn;
			end else if(count[SIZEC-1:0]==FOURTEEN) begin
				MemBData[14] <= DataIn;
			end else if(count[SIZEC-1:0]==FIFTEEN) begin  
				MemBData[15] <= DataIn;    
			end 
		end
	end
	if(writeout==1'b1) begin
		MuxData <= next_MuxData;
	end
  
end


endmodule // End of Module FSM


