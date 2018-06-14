module top;

    wire [31:0] result;              //ALU result. output from ALU to data cache.
    reg [3:0] aluControlCode;        //ALU control code
    reg clock;                      //clock for entire processor
    wire zeroFlag;                  //zero flag from ALU for use in PC

    wire memWriteFlag;              //flag from Decoder & Control for use in Data Cache
    wire memReadFlag;               //flag from Decoder & Control for use in Data Cache
    wire memToRegFlag;              //flag from Decoder & Control for use in Data Cache
    wire [31:0] readAddress;        //output from PC for use in instruction cache

    wire [31:0] readData;           //doubles as write data for operand prep input
                                    //read data output from data cache

    wire [31:0] instruction;        //instruction value output from instruction cache
    wire [10:0] opcodeInstruction;  //DO WE WANT OPERAND PREP TO ONLY GET 10bits??? WHO SENDS??
    wire unconditionalBranchFlag;   //flag from Decoder & Control for use in PC
    wire branchFlag;                //flag from Decoder & Control for use in PC
    wire aluOP;                     //flag from Decoder & Control for use in ALU. May be wider than 1 bit?
    wire aluSRC;                    //flag from Decoder & Control for u1se in ALU
    wire regWriteFlag;              //flag from Decoder & Control for use in PC
    wire [4:0] readRegister1;       //register 1 ID from Decoder & Control to Operand Prep
    wire [4:0] readRegister2;       //register 2 ID from Decoder & Control to Operand Prep
    wire [4:0] writeRegister;       //write register ID from Decoder & Control to Operand Prep

    wire [31:0] readData1;  //input to ALU from operand preperation
    wire [31:0] readData2;  //input to ALU from operand preperation
    wire [31:0] pcOffsetOrig;       //original PC counter. Used in PC and operand preperation. SHOULD THIS BE AN INOUT??Needs to get changed.
    wire [31:0] pcOffsetFilled;     //Sign extended PC offset. NOT SURE HOW THIS IS BEING LINKED
    wire [31:0] pcScaledOffset;     //I DO NOT THINK THAT THIS VARIABLE SHOULD EXIST. SHOULD BE A LOCAL WITHIN PC NOT OUTPUT BACK.


  ALU aluInstance(readData1, readData2, aluControlCode, result, zeroFlag, clock);
    DataCache dataCacheInstance(memWriteFlag, memReadFlag, memToRegFlag, result,
        readData2, readData, clock);
    Controller controllerInstance(opcodeInstruction, unconditionalBranchFlag,
        branchFlag, memReadFlag, memToRegFlag, aluOP, memWriteFlag, aluSRC,
        regWriteFlag, readRegister1, readRegister2, writeRegister, clock);
    InstructionCache instructionCacheInstance(readAddress, instruction, clock);
    OperationPrep operationPrepInstance(regWriteFlag, readRegister1, readRegister2,
        writeRegister, readData, readData1, readData2, aluSRC, pcOffsetOrig,
        pcOffsetFilled, clock);
    PC pcInstance(branchFlag, unconditionalBranchFlag, zeroFlag, pcOffsetOrig,
        readAddress, pcScaledOffset, clock);



  initial begin
    $monitor("readData1: ", readData1, "\t readData2: ",readData2,"\t aluControlCode: ",aluControlCode,
        "\t result: ",result);
  end
reg [31:0] test1;
reg [31:0] test2;
assign readData1 = test1;
assign readData2 = test2;

  //This is the test function all of the #number represents a timing delay
initial begin
  test1 = 15; test2 = 15; aluControlCode = 2;   //Test the add
  #2 aluControlCode = 7;                          //Test the CBZ
  #2 test1 = 10;                         //change test1 to 10
  #2 aluControlCode = 3;                          //Test the subtraction
  #2 test1 = 5;                          //change test1 to 5
  #2 aluControlCode = 6;                          //Test the bitwise AND
  #2 aluControlCode = 4;                          //Test the bitwise OR
  #2 test2 = 10;                         //change readData2 to 10
  #2 aluControlCode = 9;                          //Test the bitwise XOR
  #2 aluControlCode = 5;                          //Test the NOR
  #2 aluControlCode = 12;                         //Test the NAND
  #2 aluControlCode = 13;                         //Test the MOV
end
  always
      #1 clock = ~clock;
endmodule
