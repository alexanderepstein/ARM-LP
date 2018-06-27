`ifdef DEBUG
`include "./Processor.v"

`ifndef TOP
`define TOP

module top;

wire [31:0] instruction;
wire regWriteFlag;
wire [2:0] opType;
reg [31:0] instructionVAL;
reg [31:0] readData1VAL;
wire memWriteFlag;
wire memReadFlag;
wire [3:0] aluControlCode;
wire branchFlag;
wire unconditionalBranchFlag;
wire aluSRC;

assign instruction = instructionVAL;
Processor cpuInstance(instruction, regWriteFlag, opType, memWriteFlag,
                      memReadFlag, aluControlCode, branchFlag, unconditionalBranchFlag, aluSRC);
  initial begin
        /* For testing the ALU
        $monitor("readData1: ", readData1, "\t readData2: ",readData2,"\t aluControlCode: ",aluControlCode,
        "\t result: ",result, "\t zeroFlag: ", zeroFlag, "\t carryBit: ", carryBit);*/

        $monitor("instruction: ", instruction,  "\t regWriteFlag: ",
          regWriteFlag, "\t opType: ", opType, "\t memWriteFlag: ",
          memWriteFlag, "\t memReadFlag: ", memReadFlag, "\naluControlCode: ",
          aluControlCode, "\t branchFlag: ", branchFlag, "\t\t uBranchFlag: ",
          unconditionalBranchFlag, "\t aluSRC: ", aluSRC, "\n\n");
  end

    //This is the test function all of the #number represents a timing delay
    initial begin

        /*
        ALU Testing
        readData1VAL = 15; readData2VAL = 15; aluControlCodeVAL = 2;  //Test the add
        #2 aluControlCodeVAL = 7;                                     //Test the CBZ
        #2 readData1VAL = 10;                                         //change readData1VAL to 10
        #2 aluControlCodeVAL = 10;                                     //Test the subtraction
        //Test a large addition
        #2 readData1VAL = 2140483647;
        #2 readData2VAL = 2141483647;
        #2 aluControlCodeVAL = 2;

        #2 readData1VAL = 5;                                          //change readData1VAL to 5
        #2 aluControlCodeVAL = 6;                                     //Test the bitwise AND
        #2 aluControlCodeVAL = 4;                                     //Test the bitwise OR
        #2 readData2VAL = 10;                                         //change readData2 to 10
        #2 aluControlCodeVAL = 9;                                     //Test the bitwise XOR
        #2 aluControlCodeVAL = 5;                                     //Test the NOR
        #2 aluControlCodeVAL = 12;                                    //Test the NAND
        #2 aluControlCodeVAL = 13;                                    //Test the MOV
        */
        #2 instructionVAL <= 2**22 | 2**28; // Load
        #2 instructionVAL <= 2**26 | 2**29; // Conditional Branch
        #2 instructionVAL <= 2**27; // RTYPE
        #2 instructionVAL <= 2**27 | 2**28; // Store
        #2 instructionVAL <= 2**28; // IType
        #2 instructionVAL <= 2**26; // BTYPE
        #2 instructionVAL <= 2**23 | 2**28; //MOV

    end

endmodule

`endif
`endif
