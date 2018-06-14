module top;

	wire [31:0]result;              //ALU result. output from ALU to data cache.
	reg [3:0]aluControlCode;        //ALU control code
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
    wire aluSRC;                    //flag from Decoder & Control for use in ALU
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
		$monitor("input1: ", input1, "\t input2: ",input2,"\t aluControlCode: ",aluControlCode,
        "\t result: ",result);
	end	

    //This is the test function all of the #number represents a timing delay
	initial begin
		input1 = 15; input2 = 15; aluControlCode = 2;   //Test the add
		#2 aluControlCode = 7;                          //Test the CBZ
		#2 input1 = 10;                         //change input1 to 10
		#2 aluControlCode = 3;                          //Test the subtraction
		#2 input1 = 5;                          //change input1 to 5
		#2 aluControlCode = 6;                          //Test the bitwise AND
		#2 aluControlCode = 4;                          //Test the bitwise OR
		#2 input2 = 10;                         //change input2 to 10
		#2 aluControlCode = 9;                          //Test the bitwise XOR
		#2 aluControlCode = 5;                          //Test the NOR
		#2 aluControlCode = 12;                         //Test the NAND
		#2 aluControlCode = 13;                         //Test the MOV
	end
    always
        #1 clock = ~clock;
endmodule

module ALU (input[31:0] inOne,input[31:0] inTwo, input[3:0]aluControlCode,
 output reg [31:0]result, output reg zeroFlag, input clock);
	always @(posedge clock) begin
		case(aluControlCode)
			4'b0010: result = inOne + inTwo;    //LD_STR_ADD aluControlCode
			4'b0111: result = inOne == 0;       //CBZ aluControlCode
			4'b1010: result = inOne - inTwo;    //SUB aluControlCode
			4'b0110: result = inOne & inTwo;    //bitwise AND aluControlCode
			4'b0100: result = inOne | inTwo;    //bitwise OR aluControlCode
			4'b1001: result = inOne ^ inTwo;    //bitwise XOR aluControlCode
			4'b0101: result = ! (inOne | inTwo);//NOR aluControlCode
			4'b1100: result = ! (inOne & inTwo);//NAND aluControlCode
			4'b1101: result = inOne;            //MOV aluControlCode
			default: result = 0;                //undefined aluControlCode
		endcase
            //determine the flag output for use in conditional branching
            if (inOne == 0) begin
            		zeroFlag = 1;
        	end
        	else begin
            		zeroFlag = 0;
        	end
	end
endmodule 
