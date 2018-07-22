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
wire [4:0] readRegister1;
wire [4:0] readRegister2;
wire [4:0] writeRegister;
wire memToReg;

assign instruction = instructionVAL;
Processor cpuInstance(instruction, regWriteFlag, opType, memWriteFlag,
                      memReadFlag, aluControlCode, branchFlag, unconditionalBranchFlag,
                      aluSRC, readRegister1, readRegister2, writeRegister, memToReg);
  initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top);
        /* For testing the ALU
        $monitor("readData1: ", readData1, "\t readData2: ",readData2,"\t aluControlCode: ",aluControlCode,
        "\t result: ",result, "\t zeroFlag: ", zeroFlag, "\t carryBit: ", carryBit);*/

        $monitor("\ninstruction: ", instruction,  "\t regWriteFlag: ",  regWriteFlag, "\t opType: ",
          opType, "\t memWriteFlag: ", memWriteFlag, "\t memReadFlag: ", memReadFlag, "\naluControlCode: ",
          aluControlCode, "\t branchFlag: ", branchFlag, "\t\t uBranchFlag: ", unconditionalBranchFlag,
          "\t aluSRC: ", aluSRC, "\t\t readRegister1: ", readRegister1, "\nreadRegister2: ",
          readRegister2, "\t writeRegister: ", writeRegister, "\t memToReg: ", memToReg, "\n");
  end

    //This is the test function all of the #number represents a timing delay
    initial begin
        /*
        // ALU Testing
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

        // Control Testing
        //   instructionVAL <= 32'b11111000010011110000000101001001; // LDUR X9, [X10,#240]
        //#2 instructionVAL <= 32'b11111000000011110000000101001001; // STUR X9, [X10,#240]
        //#2 instructionVAL <= 32'b10001011000101010000001010001001; // ADD X9,X20,X21
        //#2 instructionVAL <= 32'b10010001000000000000011011010110; // ADDI X22, X22, #1
        //#2 instructionVAL <= 32'b11001011000101010000001010001001; // SUB X9,X20,X21
        //#2 instructionVAL <= 32'b11010001000000000000011011010110; // SUBI X22, X22, #1
        //#2 instructionVAL <= 32'b10001010000101010000001010001001; // AND X9,X20,X21
        //#2 instructionVAL <= 32'b10010010000000000000011011010110; // ANDI X22, X22, #1
        //#2 instructionVAL <= 32'b10101010000101010000001010001001; // ORR X9,X20,X21
        //#2 instructionVAL <= 32'b10110010000000000000011011010110; // ORI X22, X22, #1
        //#2 instructionVAL <= 32'b11101010000101010000001010001001; // XOR X9,X20,X21
        //#2 instructionVAL <= 32'b11010010000000000000011011010110; // XORI X22, X22, #1
        //#2 instructionVAL <= 32'b00010100000000000000000000000010; // B 2
        //#2 instructionVAL <= 32'b11010010100000000000000000000000; // MOV R0, R0
        //#2 instructionVAL <= 32'b10110100000000000000000000000000; // CBZ 0, 0, 0
        //#2 instructionVAL = 32'hB4080000;                             //Here CBZ R1 Here
        //#2 instructionVAL = 32'h14000000;                              //Here B Here

        //#2 instructionVAL <= 32'b10010001000000000000011011010110; // ADDI X22, X22, #1
        
        //This should be driven by giving a PC value. Then, that goes into the instruction cache to fetch from.
        //Need to add the test instructions into the instruction cache for this to work properly.




    end
    always
        #1 clock = ~clock;

endmodule

`endif
`endif
