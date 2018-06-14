module top;

    reg clock; // Main clock

    // ALU integration
 	  reg [31:0] input1; // Also connects to operand prep as Read Data 1 (input)
    reg [31:0] input2; // Also connects to operand prep as Read Data 2 (input)
	  reg [3:0] opcode; // Also connects to controller as aluOP
    wire [31:0] result;

    // Controller
    wire memWriteFlag;
    wire memReadFlag;
    wire memToRegFlag;
    wire zeroFlag;
    wire unconditionalBranchFlag;
    wire branchFlag;
    wire aluOP;
    wire aluSRC;
    wire regWrite;

    // Data Cache Integration
    wire [31:0] readData; // Connects to operand prep as Write Data

    // Instruction Cache Integration
    wire [31:0] instruction;
    wire [31:0] readAddress;
    wire [10:0] opcodeInstruction;

    // Operand Prep integration
    wire [4:0] readRegister1;
    wire [4:0] readRegister2;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [4:0] writeRegister;

    // PC integration
    wire [31:0] pcOffsetOrig;
    wire [31:0] pcOffsetFilled;
    wire [31:0] pcScaledOffset;


	ALU aluInstance(input1, input2, opcode, result, zeroFlag, clock);
    DataCache dataCacheInstance(memWriteFlag, memReadFlag, memToRegFlag, result,
        readData2, readData, clock);
    Controller controllerInstance(opcodeInstruction, unconditionalBranchFlag,
        branchFlag, memReadFlag, memToRegFlag, aluOP, memWriteFlag, aluSRC, regWrite,
        readRegister1, readRegister2, writeRegister, clock);
    InstructionCache instructionCacheInstance(readAddress, instruction, clock);
    OperationPrep operationPrepInstance(regWrite, readRegister1, readRegister2,
        writeRegister, readData, readData1, readData2, aluSRC, pcOffsetOrig,
        clock);
    PC pcInstance(branchFlag, unconditionalBranchFlag, zeroFlag, pcOffsetOrig,
        readAddress, pcOffsetFilled, clock);



	initial begin
		$monitor("input1: ", input1, "\t input2: ", input2,"\t opcode: ", opcode,
        "\t result: ", result, "\t zeroFlag: ", zeroFlag);
	end

always
   #1 clock = ~clock;

    //This is the test function all of the #number represents a timing delay
	initial begin
		input1 = 15; input2 = 15; opcode = 2;   //Test the add
    #2 input1 = 0;                          //Change input1 to 0
		#2 opcode = 7;                          //Test the CBZ
    #2 input1 = 3;
		#2 input1 = 10;                         //change input1 to 10
		#2 opcode = 3;                          //Test the subtraction
		#2 input1 = 5;                          //change input1 to 5
		#2 opcode = 6;                          //Test the bitwise AND
		#2 opcode = 4;                          //Test the bitwise OR
		#2 input2 = 10;                         //change input2 to 10
		#2 opcode = 9;                          //Test the bitwise XOR
		#2 opcode = 5;                          //Test the NOR
		#2 opcode = 12;                         //Test the NAND
		#2 opcode = 13;                         //Test the MOV
	end

endmodule
