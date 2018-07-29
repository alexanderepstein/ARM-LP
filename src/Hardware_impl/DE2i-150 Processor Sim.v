`ifndef PROCESSOR
`define PROCESSOR

`ifdef DEBUG
  module Processor(instructionVAL, regWriteOUT, opTypeOUT, memWriteOUT, memReadOUT,
     aluControlCodeOUT, branchFlagOUT, ubranchOUT, aluSRCOUT, readRegister1OUT,
     readRegister2OUT, writeRegisterOUT, memToRegOUT);
  input [31:0] instructionVAL;
  input [31:0] readData1VAL;
  input [31:0] readData2VAL;
  output regWriteOUT;
  output [2:0] opTypeOUT;
  output memWriteOUT;
  output memReadOUT;
  output branchFlagOUT;
  output ubranchOUT;
  output [3:0] aluControlCodeOUT;
  output aluSRCOUT;
  output [4:0] readRegister1OUT;
  output [4:0] readRegister2OUT;
  output [4:0] writeRegisterOUT;
  output memToRegOUT;


  assign regWriteOUT = regWriteFlag;
  assign opTypeOUT = opType;
  assign memWriteOUT = memWriteFlag;
  assign memReadOUT = memReadFlag;
  assign branchFlagOUT = branchFlag;
  assign ubranchOUT = unconditionalBranchFlag;
  assign aluControlCodeOUT = aluControlCode;
  assign aluSRCOUT = aluSRC;
  assign readRegister1OUT = readRegister1;
  assign readRegister2OUT = readRegister2;
  assign memToRegOUT = memToRegFlag;
  //This is a workaround to couple both inputs AND outputs from modules to a registers
  reg [3:0] aluControlCodeVAL;
  assign instruction = instructionVAL;
  assign readData1 = readData1VAL;
  assign readData2 = readData2VAL;
  assign writeRegisterOUT = writeRegister;
  //assign aluControlCode = aluControlCodeVAL;
`else
  module Processor(selectMem, clock,
  a0, b0, c0, d0, e0, f0, g0,
  a1, b1, c1, d1, e1, f1, g1,
  a2, b2, c2, d2, e2, f2, g2,
  a3, b3, c3, d3, e3, f3, g3,
  a4, b4, c4, d4, e4, f4, g4,
  a5, b5, c5, d5, e5, f5, g5,
  a6, b6, c6, d6, e6, f6, g6,
  a7, b7, c7, d7, e7, f7, g7,
  );
`endif

//In here, we need to add some inputs for switches to go to memory addresses. AND HEX Display outputs.
//The board has 8 and I am going to need all 8 for 32 bit

wire regWriteFlag;              //flag from Decoder & Control for use in PC
wire [2:0] opType;
wire [31:0] result;             //ALU result. output from ALU to data cache.
wire [3:0] aluControlCode;      //ALU control code
input wire clock;                      //clock for entire processor
wire zeroFlag;                  //zero flag from ALU for use in PC
wire carryBit;                  //carrybit flag
wire memWriteFlag;              //flag from Decoder & Control for use in Data Cache
wire memReadFlag;               //flag from Decoder & Control for use in Data Cache
wire memToRegFlag;              //flag from Decoder & Control regfor use in Data Cache
wire [31:0] PC;                 //output from PC for use in instruction cache
wire [31:0] readData;           //doubles as write data for operand prep input

                                //read data output from data cache

wire [31:0] instruction;        //instruction value output from instruction cache
wire unconditionalBranchFlag;   //flag from Decoder & Control for use in PC
wire branchFlag;                //flag from Decoder & Control for use in PC
wire aluSRC;                    //flag from Decoder & Control for u1se in ALU
wire invertZeroFlag;
wire [4:0] readRegister1;       //register 1 ID from Decoder & Control to Operand Prep
wire [4:0] readRegister2;       //register 2 ID from Decoder & Control to Operand Prep
wire [4:0] writeRegister;       //write register ID from Decoder & Control to Operand Prep

wire [31:0] readData1;          //input to ALU from operand preperation
wire [31:0] readData2;          //input to ALU from operand preperation
wire [31:0] writeData;          //input to Datacache from op prep

wire [31:0] pcOffsetOrig;       //original PC counter.
wire [31:0] pcOffsetFilled;     //Sign extended PC offset.
assign pcOffsetOrig = instruction; //Couple the instruction to the original PC. Op-Prep will do processing

ALU aluInstance(readData1, readData2, aluControlCode, result, zeroFlag,
    clock, carryBit, invertZeroFlag);
DataCache dataCacheInstance(memWriteFlag, memReadFlag, memToRegFlag, result,
    writeData, readData, clock, memoryContents, selectMem);
Controller controllerInstance(instruction, unconditionalBranchFlag,
    branchFlag, memReadFlag, memToRegFlag, aluControlCode, memWriteFlag, aluSRC,
    regWriteFlag, readRegister1, readRegister2, writeRegister, clock,
    invertZeroFlag, opType);
InstructionCache instructionCacheInstance(PC, instruction, clock);
OperationPrep operationPrepInstance(memWriteFlag, memReadFlag, regWriteFlag, readRegister1, readRegister2,
    writeRegister, readData, readData1, readData2, aluSRC, pcOffsetOrig,
    pcOffsetFilled, writeData, clock);
PC pcInstance(branchFlag, unconditionalBranchFlag, zeroFlag, PC,
    pcOffsetFilled, clock);

    //initial begin clock = 0; end // Start clock low
    //always #1 clock = ~clock; // Clock cycle every two ticks
	 
	 //I am going to output a current memory cell to the HEX displays
	 // I only want the memory contents of ONE item.
	 //Have altered the data cache to return now a set data back up based on user input.
	 //I will then assign those data fields to HEX displays
	 
	 
	 wire [31:0] memoryContents;
    
	 input wire [4:0] selectMem;
	 
	 /*********   MSB HEX DISPLAY 7      *********/
	 wire A7;
	 assign A7 = memoryContents[31];
    wire B7;
	 assign B7 = memoryContents[30];
	 wire C7;
	 assign C7 = memoryContents[29];
	 wire D7;
	 assign D7 = memoryContents[28];
	 
	 output wire a7;
	 output wire b7;
	 output wire c7;
	 output wire d7;
	 output wire e7;
	 output wire f7;
	 output wire g7;
	 
    assign a7 = !((!B7&!D7)|(!A7&C7)|(!A7&B7&D7)|(B7&C7)|(A7&!B7&!C7)|(A7&!D7));
	 assign b7 = !((!A7&!B7)|(!A7&!C7&!D7)|(!B7&!D7)|(!A7&C7&D7)|(A7&!C7&D7));
	 assign c7 = !((!A7&!C7)|(!A7&D7)|(!C7&D7)|(!A7&B7)|(A7&!B7));
	 assign d7 = !((!A7&!B7&!D7)|(!B7&C7&D7)|(B7&!C7&D7)|(B7&C7&!D7)|(A7&!C7&!D7));
	 assign e7 = !((!B7&!D7)|(C7&!D7)|(A7&C7)|(A7&B7));
	 assign f7 = !((!C7&!D7)|(!A7&B7&!C7)|(B7&!D7)|(A7&!B7)|(A7&C7));
	 assign g7 = !((!B7&C7)|(C7&!D7)|(!A7&B7&!C7)|(A7&!B7)|(A7&D7));
	 /************* END HEX DISPLAY 7    ***************/
	 
	 
	 /***** BEGIN HEX DISPLAY 6 ***********************/
	 wire A6;
	 assign A6 = memoryContents[27];
    wire B6;
	 assign B6 = memoryContents[26];
	 wire C6;
	 assign C6 = memoryContents[25];
	 wire D6;
	 assign D6 = memoryContents[24];
	 
	 output wire a6;
	 output wire b6;
	 output wire c6;
	 output wire d6;
	 output wire e6;
	 output wire f6;
	 output wire g6;
	 
    assign a6 = !((!B6&!D6)|(!A6&C6)|(!A6&B6&D6)|(B6&C6)|(A6&!B6&!C6)|(A6&!D6));
	 assign b6 = !((!A6&!B6)|(!A6&!C6&!D6)|(!B6&!D6)|(!A6&C6&D6)|(A6&!C6&D6));
	 assign c6 = !((!A6&!C6)|(!A6&D6)|(!C6&D6)|(!A6&B6)|(A6&!B6));
	 assign d6 = !((!A6&!B6&!D6)|(!B6&C6&D6)|(B6&!C6&D6)|(B6&C6&!D6)|(A6&!C6&!D6));
	 assign e6 = !((!B6&!D6)|(C6&!D6)|(A6&C6)|(A6&B6));
	 assign f6 = !((!C6&!D6)|(!A6&B6&!C6)|(B6&!D6)|(A6&!B6)|(A6&C6));
	 assign g6 = !((!B6&C6)|(C6&!D6)|(!A6&B6&!C6)|(A6&!B6)|(A6&D6));
	 /************ END HEX DISPLAY 6 ************************/
	 
	 /************** BEGIN HEX DISPLAY 5  ******************/
	 wire A5;
	 assign A5 = memoryContents[23];
    wire B5;
	 assign B5 = memoryContents[22];
	 wire C5;
	 assign C5 = memoryContents[21];
	 wire D5;
	 assign D5 = memoryContents[20];
	 
	 output wire a5;
	 output wire b5;
	 output wire c5;
	 output wire d5;
	 output wire e5;
	 output wire f5;
	 output wire g5;
	 
    assign a5 = !((!B5&!D5)|(!A5&C5)|(!A5&B5&D5)|(B5&C5)|(A5&!B5&!C5)|(A5&!D5));
	 assign b5 = !((!A5&!B5)|(!A5&!C5&!D5)|(!B5&!D5)|(!A5&C5&D5)|(A5&!C5&D5));
	 assign c5 = !((!A5&!C5)|(!A5&D5)|(!C5&D5)|(!A5&B5)|(A5&!B5));
	 assign d5 = !((!A5&!B5&!D5)|(!B5&C5&D5)|(B5&!C5&D5)|(B5&C5&!D5)|(A5&!C5&!D5));
	 assign e5 = !((!B5&!D5)|(C5&!D5)|(A5&C5)|(A5&B5));
	 assign f5 = !((!C5&!D5)|(!A5&B5&!C5)|(B5&!D5)|(A5&!B5)|(A5&C5));
	 assign g5 = !((!B5&C5)|(C5&!D5)|(!A5&B5&!C5)|(A5&!B5)|(A5&D5));
	 /************ END HEX DISPLAY 5 ************************/

	 /************** BEGIN HEX DISPLAY 4  ******************/
	 wire A4;
	 assign A4 = memoryContents[19];
    wire B4;
	 assign B4 = memoryContents[18];
	 wire C4;
	 assign C4 = memoryContents[17];
	 wire D4;
	 assign D4 = memoryContents[16];
	 
	 output wire a4;
	 output wire b4;
	 output wire c4;
	 output wire d4;
	 output wire e4;
	 output wire f4;
	 output wire g4;
	 
    assign a4 = !((!B4&!D4)|(!A4&C4)|(!A4&B4&D4)|(B4&C4)|(A4&!B4&!C4)|(A4&!D4));
	 assign b4 = !((!A4&!B4)|(!A4&!C4&!D4)|(!B4&!D4)|(!A4&C4&D4)|(A4&!C4&D4));
	 assign c4 = !((!A4&!C4)|(!A4&D4)|(!C4&D4)|(!A4&B4)|(A4&!B4));
	 assign d4 = !((!A4&!B4&!D4)|(!B4&C4&D4)|(B4&!C4&D4)|(B4&C4&!D4)|(A4&!C4&!D4));
	 assign e4 = !((!B4&!D4)|(C4&!D4)|(A4&C4)|(A4&B4));
	 assign f4 = !((!C4&!D4)|(!A4&B4&!C4)|(B4&!D4)|(A4&!B4)|(A4&C4));
	 assign g4 = !((!B4&C4)|(C4&!D4)|(!A4&B4&!C4)|(A4&!B4)|(A4&D4));
 	 /************ END HEX DISPLAY 4 ************************/

 	 /************** BEGIN HEX DISPLAY 3  ******************/
	 wire A3;
	 assign A3 = memoryContents[15];
    wire B3;
	 assign B3 = memoryContents[14];
	 wire C3;
	 assign C3 = memoryContents[13];
	 wire D3;
	 assign D3 = memoryContents[12];
	 
	 output wire a3;
	 output wire b3;
	 output wire c3;
	 output wire d3;
	 output wire e3;
	 output wire f3;
	 output wire g3;
	 
    assign a3 = !((!B3&!D3)|(!A3&C3)|(!A3&B3&D3)|(B3&C3)|(A3&!B3&!C3)|(A3&!D3));
	 assign b3 = !((!A3&!B3)|(!A3&!C3&!D3)|(!B3&!D3)|(!A3&C3&D3)|(A3&!C3&D3));
	 assign c3 = !((!A3&!C3)|(!A3&D3)|(!C3&D3)|(!A3&B3)|(A3&!B3));
	 assign d3 = !((!A3&!B3&!D3)|(!B3&C3&D3)|(B3&!C3&D3)|(B3&C3&!D3)|(A3&!C3&!D3));
	 assign e3 = !((!B3&!D3)|(C3&!D3)|(A3&C3)|(A3&B3));
	 assign f3 = !((!C3&!D3)|(!A3&B3&!C3)|(B3&!D3)|(A3&!B3)|(A3&C3));
	 assign g3 = !((!B3&C3)|(C3&!D3)|(!A3&B3&!C3)|(A3&!B3)|(A3&D3));
 	 /************ END HEX DISPLAY 3 ************************/
	 
  	 /************** BEGIN HEX DISPLAY 2  ******************/
	 wire A2;
	 assign A2 = memoryContents[11];
    wire B2;
	 assign B2 = memoryContents[10];
	 wire C2;
	 assign C2 = memoryContents[9];
	 wire D2;
	 assign D2 = memoryContents[8];
	 
	 output wire a2;
	 output wire b2;
	 output wire c2;
	 output wire d2;
	 output wire e2;
	 output wire f2;
	 output wire g2;
	 
    assign a2 = !((!B2&!D2)|(!A2&C2)|(!A2&B2&D2)|(B2&C2)|(A2&!B2&!C2)|(A2&!D2));
	 assign b2 = !((!A2&!B2)|(!A2&!C2&!D2)|(!B2&!D2)|(!A2&C2&D2)|(A2&!C2&D2));
	 assign c2 = !((!A2&!C2)|(!A2&D2)|(!C2&D2)|(!A2&B2)|(A2&!B2));
	 assign d2 = !((!A2&!B2&!D2)|(!B2&C2&D2)|(B2&!C2&D2)|(B2&C2&!D2)|(A2&!C2&!D2));
	 assign e2 = !((!B2&!D2)|(C2&!D2)|(A2&C2)|(A2&B2));
	 assign f2 = !((!C2&!D2)|(!A2&B2&!C2)|(B2&!D2)|(A2&!B2)|(A2&C2));
	 assign g2 = !((!B2&C2)|(C2&!D2)|(!A2&B2&!C2)|(A2&!B2)|(A2&D2));
  	 /************ END HEX DISPLAY 3 ************************/

  	 /************** BEGIN HEX DISPLAY 1  ******************/
	 wire A1;
	 assign A1 = memoryContents[7];
    wire B1;
	 assign B1 = memoryContents[6];
	 wire C1;
	 assign C1 = memoryContents[5];
	 wire D1;
	 assign D1 = memoryContents[4];
	 
	 output wire a1;
	 output wire b1;
	 output wire c1;
	 output wire d1;
	 output wire e1;
	 output wire f1;
	 output wire g1;
	 
    assign a1 = !((!B1&!D1)|(!A1&C1)|(!A1&B1&D1)|(B1&C1)|(A1&!B1&!C1)|(A1&!D1));
	 assign b1 = !((!A1&!B1)|(!A1&!C1&!D1)|(!B1&!D1)|(!A1&C1&D1)|(A1&!C1&D1));
	 assign c1 = !((!A1&!C1)|(!A1&D1)|(!C1&D1)|(!A1&B1)|(A1&!B1));
	 assign d1 = !((!A1&!B1&!D1)|(!B1&C1&D1)|(B1&!C1&D1)|(B1&C1&!D1)|(A1&!C1&!D1));
	 assign e1 = !((!B1&!D1)|(C1&!D1)|(A1&C1)|(A1&B1));
	 assign f1 = !((!C1&!D1)|(!A1&B1&!C1)|(B1&!D1)|(A1&!B1)|(A1&C1));
	 assign g1 = !((!B1&C1)|(C1&!D1)|(!A1&B1&!C1)|(A1&!B1)|(A1&D1));
  	 /************ END HEX DISPLAY 1 ************************/

  	 /************** BEGIN HEX DISPLAY 0  ******************/
    wire A0;
	 assign A0 = memoryContents[3];
    wire B0;
	 assign B0 = memoryContents[2];
	 wire C0;
	 assign C0 = memoryContents[1];
	 wire D0;
	 assign D0 = memoryContents[0];
	 
	 output wire a0;
	 output wire b0;
	 output wire c0;
	 output wire d0;
	 output wire e0;
	 output wire f0;
	 output wire g0;
	 
    assign a0 = !((!B0&!D0)|(!A0&C0)|(!A0&B0&D0)|(B0&C0)|(A0&!B0&!C0)|(A0&!D0));
	 assign b0 = !((!A0&!B0)|(!A0&!C0&!D0)|(!B0&!D0)|(!A0&C0&D0)|(A0&!C0&D0));
	 assign c0 = !((!A0&!C0)|(!A0&D0)|(!C0&D0)|(!A0&B0)|(A0&!B0));
	 assign d0 = !((!A0&!B0&!D0)|(!B0&C0&D0)|(B0&!C0&D0)|(B0&C0&!D0)|(A0&!C0&!D0));
	 assign e0 = !((!B0&!D0)|(C0&!D0)|(A0&C0)|(A0&B0));
	 assign f0 = !((!C0&!D0)|(!A0&B0&!C0)|(B0&!D0)|(A0&!B0)|(A0&C0));
	 assign g0 = !((!B0&C0)|(C0&!D0)|(!A0&B0&!C0)|(A0&!B0)|(A0&D0));

	 
	 

endmodule

`endif

/*********************************     PC Module     **********************************/

`ifndef PC
`define PC

module PC(branchFlag, unconditionalBranchFlag, zeroFlag,
	 PC, pcOffsetFilled, clock);

    input clock;
    input branchFlag;
    input unconditionalBranchFlag;
    input zeroFlag;
    input [31:0] pcOffsetFilled;

    inout [31:0] PC;
    reg [31:0] PC_in;
    reg [31:0] PC_out;
    assign PC = (PC_out != 0)? PC_out : PC_in;

    reg [31:0] pcScaledOffset;
    reg [31:0] internalPCReg;
    reg [2:0] syncPC; //want to sync the PC every 5th clock cycle

    // The mux for what the PC should be set to (branch or next instruction)
    wire muxSelect;
    assign muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag;
    
    initial begin
        syncPC = 0;
        PC_out = 0;
        PC_in = 32'h100;
    end
    //This is not going to work.Going to be updating the PC a shit ton.
    //assign PC to track internalPCReg, which only updates on rising edges
    //assign PC = internalPCReg; // If mux == 0 next instruction otherwise branch;

	always @(posedge clock) begin
		pcScaledOffset <= pcOffsetFilled << 3; // Multiplying the offset by 4. UPDATE NOW 8 DUE TO HOW WE HAVE DONE THE CACHES INCREMENTING BY 8
        //Fuck you our processor now does 64 bit addressing. IF NOT WE NEED TO CHANGE CACHE TO DROP 2 BIT INSTEAD OF 3
        internalPCReg <= (muxSelect == 0) ? PC + 8 : PC + pcScaledOffset; 
        syncPC = syncPC + 1;
        if (syncPC == 5) begin
            PC_out = internalPCReg;
            syncPC = 0;
        end
	end
    
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule

`endif
/********************************* END PC MODULE  ****************************************/

/********************************    INSTRUCTION CACHE   *********************************/
`ifndef INSTRUCTIONCACHE
`define INSTRUCTIONCACHE

module InstructionCache(PC, instruction, clock);

input clock; // Main clock
input [31:0] PC; // Address to read for instruction
//You may have to update the PC and all addresses by 8 all the time in order 
//for the caches to function properly

`ifdef DEBUG
  input [31:0] instruction; //For now when testing controller
`else
  output reg[31:0] instruction; // Current instruction being read
`endif
   
	reg [28:0]setAddress[0:15]; //1 line per set (16 sets). So I do one reg per set.
   	reg [31:0]setData[0:15]; 
	reg [6:0]i;
    wire [28:0]blockAddress = PC[31:3];

	wire [3:0] setID = blockAddress % 16; // I have 16 sets
    assign setID = blockAddress % 16;

	always @(posedge clock) begin : search
        //Item was in the cache
        if(blockAddress == setAddress[setID]) begin
            //if we are reading return the data that is there
            instruction = setData[setID];
            disable search;
        end
        //dont have anything. Put the shit in the right spot. Should not ever happen for this processor
        else begin
                setAddress[setID] = blockAddress;
                //We would fetch the data up but we don't know what is there since 1 level
                //fill with the special sauce
                setData[setID] = 32'hDEAD_BEEF;
                instruction = 32'hDEAD_BEEF;           
        end
       

    end

	initial begin
        //I spit their address into their index here
        //FIX THIS DAVID AND FIND WAY TO WORD ALLIGN TO MAXIMIZE SPACE.
        //Probbably LSR 2. Update think the block address does this already
        //These will ALL work
		  setAddress[0] = 29'h00000020; setData[0] = 32'b10010001000000000000011011010110; // ADDI X22, X22, #1; May God save us
   	  setAddress[1] = 29'h00000021; setData[1] = 32'b10010001000000000010000011000110; // ADDI X6, X6, #8; May God save us
        setAddress[1] = 29'h00000021; setData[1] = 32'b1001000100_11_1111_1110_00_11111_00001;  //ADDI X1, XZR, #-8. Neato
   	  setAddress[2] = 29'h00000022; setData[2] = 32'b10010001000000000100000000100001; // ADDI X1, X1, #16; May God save us
        setAddress[3] = 29'h00000023; setData[3] = 32'b10001011000000010000001011000001; // ADD X1,X22,X1 //Works
        ////All of the above function properly
        setAddress[4] = 29'h00000024; setData[4] = 32'b10010001000000000001001111100000; // ADDI R0, RZR, #4 //works
        //
        setAddress[5] = 29'h00000025; setData[5] = 32'b10010001000101000000001111100010;   //ADDI R2, R31, #1280 (0x500); //Works
        setAddress[6] = 29'h00000026; setData[6] = 32'b11111000010000000000000001000011;   //Loop LDUR R3, [R2, #0] // Should load 0x101 0101 //Works   61ns
        setAddress[7] = 29'h00000027; setData[7] = 32'b11111000010000010000000001000100;   //LDUR R4, [R2, #16]//works
        setAddress[8] = 29'h00000028; setData[8] = 32'b10001011000001000000000001100101;   //ADD R5, R3, R4 //89ns works
        setAddress[9] = 29'h00000029; setData[9] = 32'b11111000000000000000000001000101;   //STUR R5, [R2,#0] //91ns begin. Works 97ns
        setAddress[10] = 29'h0000002A; setData[10] = 32'b10010001000000000010000001000010; //ADDI R2, R2, #8 //works 109ns
        setAddress[11] = 29'h0000002B; setData[11] = 32'b11010001000000000000010000000000; //SUBI R0, R0, #1 /works 109ns
        setAddress[12] = 29'h0000002C; setData[12] = 32'b10110101111111111111111101000000; //CBNZ R0, Loop
        ////Test to see if regular branch functions properly
        ////setAddress[12] = 29'h0000002C; setData[12] = 32'b00010111111111111111111111111010; //B Loop //Loop almost looks like poop heh
        //
        setAddress[13] = 29'h0000002D; setData[13] = 32'b11001011000001100000000011000110; //SUB R6, R6, R6


        ////Commence the Carpenter tests
        ////Test 1: Init R20 to 1280 (just cause I already have data loaded there). GOOD
        //setAddress[0] = 29'h00000020; setData[0] = 32'b11111000010000000000001010000001; // LDUR R1, [R20,#0]
        ////Test 2: R2 should be 2R1 now. GOOD.
        //setAddress[1] = 29'h00000021; setData[1] = 32'b10001011000000010000000000100010; // ADD R2, R1, R1
        ////Test 3: Init R25 to something....Say 24. GOOD
        //setAddress[2] = 29'h00000022; setData[2] = 32'b11010001000000000000001100110011; // SUBI R19, R25, #0
        ////Test 4: Keep R3 as 0. See if PC jumps by 56. Using 3 bit shift for PC for cache. GOOD.
        //setAddress[3] = 29'h00000023; setData[3] = 32'b10110100000000000000000011100011; // CBZ R3 7
        ////Test 5: No modifications needed just make sure R20 goes up by 8. GOOD
        //setAddress[4] = 29'h00000024; setData[4] = 32'b10010001000000000010001010010100; // ADDI R20, R20, #8
        ////Test 6: This will just write back R1 into R20 - 12 due to 16 line cache. Performs slightly odd due to the data cache byte offset shit.
        //setAddress[5] = 29'h00000025; setData[5] = 32'b11111000000111110100001010000001; // STUR R1, R20, #-12
        ////Test 7: Go all the way back to the beginning. Good
        //setAddress[6] = 29'h00000026; setData[6] = 32'b00010111111111111111111111111010; // B -6
        
	end

endmodule

`endif

/*******************************    END INSTRUCTION CACHE   ****************************/

/********************************    CONTROLLER MODULE      ****************************/
`ifndef CONTROLLER
`define CONTROLLER
module Controller(instruction, unconditionalBranch, branch, memRead, memToReg,
    aluControlCode, memWrite, aluSRC, regWriteFlag, readRegister1,
    readRegister2,  writeRegister, clock , invertZeroFlag, opType) ;

   `define LD_TYPE 0 // Load
   `define CB_TYPE 1 // Conditional Branch
   `define R_TYPE  2 // Register
   `define ST_TYPE 3 // Store
   `define I_TYPE  4 // Immediate
   `define B_TYPE  5 // Branch
   `define M_TYPE  6 // MOV (This is going to be treated as special Rtype, meaning you can move values from one register to another and thats it)


    input clock;              //Main clock
    input [31:0] instruction; //instruction being input into the controller from instruction cache for parsing

    output wire unconditionalBranch; //Flag output from the controller into the pc
    output wire branch;              //Flag output from the controller into the pc
    output wire memRead;             //Flag output from the controller for use in Data Cache
    output wire memToReg;            //Flag output from the controller for use in Data Cache
    output reg [3:0] aluControlCode;//Output from the controller for use in ALU.
    output wire memWrite;            //Flag output from the controller for use in Data Cache
    output wire aluSRC;              //Flag output from the controller for use in ALU
    output wire regWriteFlag;        //Flag output from the controller for use in Data Cache
    output wire invertZeroFlag;

    output reg [4:0] readRegister1;  //register 1 ID from Decoder & Control to Operand Prep
    output reg [4:0] readRegister2;  //register 2 ID from Decoder & Control to Operand Prep
    output reg [4:0] writeRegister;  //write register ID from Decoder & Control to Operand Prep


    wire reg2Loc; //reg2Loc field stays within this field and can thus be handled as a local variable.
    output reg [2:0] opType; // type of operation (the operations are defined above)
    wire [1:0] aluOP; // Local feld that will help determine outout for aluControlCode


    assign reg2Loc = opType == `CB_TYPE || opType == `ST_TYPE ? 1 : 0;
    assign aluSRC = opType == `R_TYPE || opType == `CB_TYPE || opType == `M_TYPE ? 0 : 1;
    assign memToReg = opType == `LD_TYPE ? 1 : 0;
    assign regWriteFlag = opType == `R_TYPE || opType == `LD_TYPE || opType == `M_TYPE || opType == `I_TYPE ? 1 : 0;
    assign memRead = opType == `LD_TYPE ? 1 : 0;
    assign memWrite = opType == `ST_TYPE ? 1 : 0;
    assign branch = opType == `CB_TYPE ? 1 : 0;
    assign unconditionalBranch = opType == `B_TYPE ? 1 : 0;

    assign aluOP = opType == `R_TYPE  ? 2 :
                   opType == `CB_TYPE ? 1 :
                   0;
    assign invertZeroFlag = opType == `CB_TYPE ? instruction[24] == 1 
                                                ? 1 :0
                                                :0;

    //assign aluControlCode = opType;
    always @* begin
      // Determine optype
      if (instruction[26] == 1) begin
        if (instruction[29] == 1) begin opType <= `CB_TYPE; end
        else begin opType <= `B_TYPE;  end
      end
      else if (instruction[28] == 0) begin opType <= `R_TYPE; end
      else if (instruction[23] == 1) begin opType <= `M_TYPE; end
      else if (instruction[22] == 1) begin opType <= `LD_TYPE; end
      else if (instruction[27] == 1) begin opType <= `ST_TYPE; end
      else begin opType <= `I_TYPE; end


      // determine addresses for op-prep
      readRegister1 <= instruction[9:5];
      if (reg2Loc == 0) begin readRegister2 <= instruction[20:16]; end
      else begin readRegister2 <= instruction[4:0]; end
      writeRegister <= instruction[4:0];

      //Determine ALU Control Code
      if (opType == `LD_TYPE || opType == `ST_TYPE) begin aluControlCode <= 4'b0010; end // Add opcode for load and store 2
      else if (aluOP == 1) begin aluControlCode <= 4'b0111; end // CBZ opcode 7
      else if (opType == `M_TYPE) begin aluControlCode <= 4'b1101; end // MOV opcode 13
      else if (aluOP == 2) begin // R_TYPE
        if (instruction[24] == 1) begin //ADD or SUB
          if (instruction[30] == 0) begin aluControlCode <= 4'b0010; end // ADD 2
          else begin aluControlCode <= 4'b1010; end // SUB 10
        end
        else if (instruction[29] == 0) begin aluControlCode <= 4'b0110; end // AND 6
        else if (instruction[30] == 0) begin aluControlCode <= 4'b0100; end // OR 4
        else begin aluControlCode <= 4'b1001; end //XOR 9
      end
      else if (opType == `I_TYPE) begin
        if (instruction[29] == 1) begin aluControlCode <= 4'b0100; end // ORI
        else if (instruction[30] == 1) begin // XORI or SUBI
          if (instruction[25] == 1) begin aluControlCode <= 4'b1001; end //XORI 9
          else begin aluControlCode <= 4'b1010; end // SUBI 10
        end
        else if (instruction[25] == 1) begin aluControlCode <= 4'b0110; end // ANDI 6
        else begin aluControlCode <=  4'b0010; end // ADDI 2
      end
      else begin
        aluControlCode <= 0; // Default
      end
    end

endmodule
`endif

/*********************    END CONTROLLER MODULE     ***********************/

/********************************    OPERAND PREP MODULE    ****************************/
`ifndef OP_PREP
`define OP_PREP

module OperationPrep(memWriteFlag, memReadFlag, regWrite, reg1, reg2,  writeRegister,
   writeData,  readData1,  readData2, aluSRC, pcOffsetOrig, pcOffsetFilled, 
   writeDataToDCache, clock
);

input clock; // Main clock
input regWrite; // write writeData to writeRegister
input aluSRC; // Mux selector bit for input2 to ALU
input memWriteFlag;              //Used for determining readData2 val. IE it should use 9 bit addr for D type.
input memReadFlag;               //Used for determining readData2 val. IE it should use 9 bit addr for D type.
input [4:0] reg1; // First register address
input [4:0] reg2; // Second register address
input [4:0] writeRegister; // Register address to write to
input [31:0] writeData; // Data to write to writeRegister
input [31:0] pcOffsetOrig; // Original PC offset


output reg [31:0] readData1; // Data from reg1
output reg [31:0] readData2; // Data from reg2 or instruction
output reg [31:0] pcOffsetFilled; // PC padded with 0s to be 32 bits;
output reg [31:0] writeDataToDCache; //going to D Cache

reg [31:0] register[31:0]; //These are the registers

 reg [3:0] syncOpPrep;
 initial begin syncOpPrep = 0; end

	always @(posedge clock) begin
        syncOpPrep = syncOpPrep + 1;
        //zero is for redundancy. SHOULD be 5 at this point
        if (syncOpPrep == 2 || syncOpPrep == 5 || syncOpPrep == 4 || syncOpPrep == 0) begin
            //I would rather do it this way as it avoid timing conflicts
            readData1 = register[reg1];
            
            //verify that this does not have timing issues. I am reading the data 
            //above first before any potential modification
            if (regWrite == 1) begin
                if (writeData !== 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz) begin
                    register[writeRegister] = writeData;
                end
                //otherwise we are not ready to writeback and do not want intermediate values
            end
        
            //Sign extending the PC
            //see if opcode is a branch
            if(pcOffsetOrig[31:26] == 6'b100101 || pcOffsetOrig[31:26] == 6'b000101) begin
                pcOffsetFilled[31:0] <= { {6{pcOffsetOrig[25]}}, pcOffsetOrig[25:0] };
            end
            //conditional branch
            else begin
                pcOffsetFilled[31:0] <= { {18{pcOffsetOrig[18]}}, pcOffsetOrig[18:5] };
            end
            //determine if it should be an immediate or a reg.
            //D type is going to be wonky a bit
            if (aluSRC) begin
                if (memReadFlag || memWriteFlag) begin
                    readData2 = { {23{pcOffsetOrig[20]}}, pcOffsetOrig[20:12]};
                end
                //immediate
                else begin 
                    readData2 = { {20{pcOffsetOrig[21]}}, pcOffsetOrig[21:10]};
                end
            end
            else begin
                readData2 = register[reg2];
            end
            writeDataToDCache = register[reg2];
        end
        if (syncOpPrep == 5) begin
            syncOpPrep = 0;
        end
        

        
    end
    
    
    initial begin
        //Zeroize all the registers
		  register[0] <= 0;
        register[1] <= 0;
        register[2] <= 0;
        register[3] <= 0;
        //Trying to not branch in Carpenters test.
        //register[3] <= 1;
        register[4] <= 0;
        register[5] <= 0;
        register[6] <= 0;
        register[7] <= 0;
        register[8] <= 0;
        register[9] <= 0;
        register[10] <= 0;
        register[11] <= 0;
        register[12] <= 0;
        register[13] <= 0;
        register[14] <= 0;
        register[15] <= 0;
        register[16] <= 0;
        register[17] <= 0;
        register[18] <= 0;
        register[19] <= 0;
        register[20] <= 0;
        //Carpenter test below
        //register[20] <= 1280;
        register[21] <= 0;
        register[22] <= 0;
        register[23] <= 0;
        register[24] <= 0;
        register[25] <= 0;
        //Carpenter test below
        //register[25] = 24;
        register[26] <= 0;
        register[27] <= 0;
        register[28] <= 0;
        register[29] <= 0;
        register[30] <= 0;
        register[31] <= 0;
	end

endmodule

`endif

/******************************    END OPERAND PREPARATION MODULE    *******************/


/********************************         ALU            *******************************/
`ifndef ALU
`define ALU

module ALU (inOne, inTwo, opcode,result, zeroFlag, clock, carryBit, invertZeroFlag);

 wire memReadFlag;               //flag from Decoder & Control for use in Data Cache
 input clock;                    //Main clock
 input [31:0] inOne;             //data field 1 input
 input [31:0] inTwo;             //data field 2 input
 input [3:0] opcode;             //ALU control code
 input invertZeroFlag;

 output reg [31:0] result;      //result of ALU operation
 output reg zeroFlag;
 output reg carryBit;
 //check if our second input is 0. If it is we should output a 1, but check the 
 //inversion flag first
 //assign zeroFlag = inTwo == 0 ? invertZeroFlag==1 ? 0 : 1 : 0; // Flag is set if inTwo is a 0

 reg [3:0] syncALU;
 initial begin syncALU = 0; end
 
 always @(posedge clock) begin
        //figure out the zero flag. If the invertflag is on flip it
        if (inTwo == 0) begin
            if (invertZeroFlag == 1) begin
                zeroFlag = 0;
            end
            else begin
                zeroFlag = 1;
            end
        end
        else begin
            if (invertZeroFlag == 1) begin
                zeroFlag = 1;
            end
            else begin
                zeroFlag = 0;
            end
        end
        syncALU = syncALU + 1;
        
        if (syncALU == 3) begin
            case(opcode)
                4'b0010: {carryBit,result} = inOne + inTwo;    //LD_STR_ADD opcode
                4'b0111: result = inTwo;       //CBZ opcode
                4'b1010: {carryBit,result} = inOne - inTwo;    //SUB opcode
                4'b0110: result = inOne & inTwo;    //bitwise AND opcode
                4'b0100: result = inOne | inTwo;    //bitwise OR opcode
                4'b1001: result = inOne ^ inTwo;    //bitwise XOR opcode
                4'b0101: result = ! (inOne | inTwo);//NOR opcode
                4'b1100: result = ! (inOne & inTwo);//NAND opcode
                4'b1101: result = inOne;            //MOV opcode
                default: result = 0;                //undefined opcode
            endcase
        end
        else if (syncALU==5) begin
            syncALU = 0;
        end
	end
endmodule

`endif

/*********************************    END ALU MODULE     ************************************/



/*********************************    DATA CACHE MODULE  **********************************/
`ifndef DATACACHE
`define DATACACHE

module DataCache( memWrite,  memRead, memToReg, address,  writeData,  readData, clock, memContentReturn, selectMem);

    input clock; // Clock
    input memWrite; // Controls weather we are writing to memory
    input memRead; // Controls weather we are reading from the memory
    input memToReg; // Controls weather we are ouputting to a register
    input [31:0] address; // Address to read or write to. Update by 8 each time
    input [31:0] writeData; // Data to write into address
	 input [4:0] selectMem;

    output reg[31:0] readData; // Data read from address
	 output reg[31:0] memContentReturn;
 
	reg [28:0]setAddress[0:15]; //1 line per set (16 sets). So I do one reg per set.
   reg [31:0]setData[0:15]; 
	reg [6:0]i;
    wire [28:0]blockAddress = address[31:3];

	wire [3:0] setID = blockAddress % 16; // I have 16 sets
    assign setID = blockAddress % 16;

    //You are a 4th stage and ONLY a 4th stage
    reg [3:0] syncData;
    initial begin syncData = 0; end
 

	always @(posedge clock) begin : search
        syncData = syncData + 1;
        if (syncData == 4) begin
        
            //Not accessing any of the cache
            if (memToReg==0) begin
                readData = address;
            end
            
            if(blockAddress == setAddress[setID]) begin
                //if we are reading return the data that is there
                if(memRead) begin
                    readData = setData[setID];
                end //if
                //we are writing and want to update what was there
                else if(memWrite) begin
                    setData[setID] = writeData;
                    readData = setData[setID];
                end //else
                //disable search;
            end
            //dont have anything. Put the shit in the right spot. Should not ever happen for this processor
            else begin
                if(memRead) begin
                    setAddress[setID] = blockAddress;
                    //We would fetch the data up but we don't know what is there since 1 level
                    //fill with the special sauce
                    setData[setID] = 32'hDEAD_BEEF;
                    readData = 32'hDEAD_BEEF;
                end
                else if (memWrite) begin
                    setAddress[setID] = blockAddress;
                    setData[setID] = writeData;
                    readData = setData[setID];
                end
            
            end
            
            //Shitty solution. Fix later
            //Not accessing any of the cache
            if (memToReg==0) begin
                readData = address;
            end
        end
        else begin
            readData =32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
        end
        if (syncData == 5) begin
            syncData = 0;
        end
       memContentReturn = setData[selectMem];

    end

	initial begin
        //I spit their address into their index here
        //FIX THIS DAVID AND FIND WAY TO WORD ALLIGN TO MAXIMIZE SPACE.
        //Probbably LSR 2. Update think the block address does this already
		setAddress[0] = 29'h000000A0; setData[0] = 32'b00000001000000010000000100000001;
		setAddress[1] = 29'h000000A1; setData[1] = 32'b00000010000000100000001000000010;
        setAddress[2] = 29'h000000A2; setData[2] = 32'b00000011000000110000001100000011;
        setAddress[3] = 29'h000000A3; setData[3] = 32'b00000100000001000000010000000100;
        setAddress[4] = 29'h000000A4; setData[4] = 32'b00000101000001010000010100000101;
        setAddress[5] = 29'h000000A5; setData[5] = 32'b00000110000001100000011000000110;
        setAddress[6] = 29'h000000A6; setData[6] = 32'b00000111000001110000011100000111;
        setAddress[7] = 29'h000000A7; setData[7] = 32'b00001000000010000000100000001000;
        setAddress[8] = 29'h000000A8; setData[8] = 32'b00001001000010010000100100001001;
        setAddress[9] = 29'h000000A9; setData[9] = 32'h00000000;
        setAddress[10] = 29'h000000AA; setData[10] = 32'h00000000;
        setAddress[11] = 29'h000000AB; setData[11] = 32'h00000000;
        setAddress[12] = 29'h000000AC; setData[12] = 32'h00000000;
        setAddress[13] = 29'h000000AD; setData[13] = 32'h00000000;
        setAddress[14] = 29'h000000AE; setData[14] = 32'h00000000;
        setAddress[15] = 29'h000000AF; setData[15] = 32'h00000000;
        
        
        
        
	end

  
  
  
endmodule

`endif
/***************************    END DATA CACHE MODULE    *************************/

