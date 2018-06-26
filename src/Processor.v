`include "./ALU.v"
`include "./Controller.v"
`include "./DataCache.v"
`include "./InstructionCache.v"
`include "./Op-Prep.v"
`include "./PC.v"

`ifndef PROCESSOR
`define PROCESSOR

`ifdef DEBUG
  module Processor(instructionVAL, regWriteOUT, opTypeOUT, memWriteOUT, memReadOUT,
     aluControlCodeOUT, branchFlagOUT, ubranchOUT, aluSRCOUT);
  input [31:0] instructionVAL;

  output regWriteOUT;
  output [2:0] opTypeOUT;
  output memWriteOUT;
  output memReadOUT;
  output branchFlagOUT;
  output ubranchOUT;
  output [3:0] aluControlCodeOUT;
  output aluSRCOUT;

  assign regWriteOUT = regWriteFlag;
  assign opTypeOUT = opType;
  assign memWriteOUT = memWriteFlag;
  assign memReadOUT = memReadFlag;
  assign branchFlagOUT = branchFlag;
  assign ubranchOUT = unconditionalBranchFlag;
  assign aluControlCodeOUT = aluControlCode;
  assign aluSRCOUT = aluSRC;
  //This is a workaround to couple both inputs AND outputs from modules to a register.
  reg [31:0] readData1VAL;
  reg [31:0] readData2VAL;
  reg [3:0] aluControlCodeVAL;
  assign instruction = instructionVAL;
  assign readData1 = readData1VAL;
  assign readData2 = readData2VAL;
  //assign aluControlCode = aluControlCodeVAL;
`else
  module Processor;
`endif

wire regWriteFlag;              //flag from Decoder & Control for use in PC
wire [2:0] opType;
wire [31:0] result;             //ALU result. output from ALU to data cache.
wire [3:0] aluControlCode;      //ALU control code
reg clock;                      //clock for entire processor
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
wire [4:0] readRegister1;       //register 1 ID from Decoder & Control to Operand Prep
wire [4:0] readRegister2;       //register 2 ID from Decoder & Control to Operand Prep
wire [4:0] writeRegister;       //write register ID from Decoder & Control to Operand Prep

wire [31:0] readData1;          //input to ALU from operand preperation
wire [31:0] readData2;          //input to ALU from operand preperation
wire [31:0] pcOffsetOrig;       //original PC counter.
wire [31:0] pcOffsetFilled;     //Sign extended PC offset.

ALU aluInstance(readData1, readData2, aluControlCode, result, zeroFlag,
    clock, carryBit);
DataCache dataCacheInstance(memWriteFlag, memReadFlag, memToRegFlag, result,
    readData2, readData, clock);
Controller controllerInstance(instruction, unconditionalBranchFlag,
    branchFlag, memReadFlag, memToRegFlag, aluControlCode, memWriteFlag, aluSRC,
    regWriteFlag, readRegister1, readRegister2, writeRegister, clock, opType);
InstructionCache instructionCacheInstance(PC, instruction, clock);
OperationPrep operationPrepInstance(regWriteFlag, readRegister1, readRegister2,
    writeRegister, readData, readData1, readData2, aluSRC, pcOffsetOrig,
    pcOffsetFilled, clock);
PC pcInstance(branchFlag, unconditionalBranchFlag, zeroFlag, PC,
    pcOffsetFilled, clock);

    initial begin clock = 0; end // Start clock low
    always #1 clock = ~clock; // Clock cycle every two ticks

endmodule

`endif
