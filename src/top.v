module top;

    wire [31:0] result;             //ALU result. output from ALU to data cache.
    wire [3:0] aluControlCode;      //ALU control code
    reg clock;                      //clock for entire processor
    wire zeroFlag;                  //zero flag from ALU for use in PC
    wire carryBit;                  //carrybit flag

    wire memWriteFlag;              //flag from Decoder & Control for use in Data Cache
    wire memReadFlag;               //flag from Decoder & Control for use in Data Cache
    wire memToRegFlag;              //flag from Decoder & Control for use in Data Cache
    wire [31:0] PC;                 //output from PC for use in instruction cache

    wire [31:0] readData;           //doubles as write data for operand prep input
                                    //read data output from data cache

    wire [31:0] instruction;        //instruction value output from instruction cache
    wire unconditionalBranchFlag;   //flag from Decoder & Control for use in PC
    wire branchFlag;                //flag from Decoder & Control for use in PC
    wire aluSRC;                    //flag from Decoder & Control for u1se in ALU
    wire regWriteFlag;              //flag from Decoder & Control for use in PC
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
        regWriteFlag, readRegister1, readRegister2, writeRegister, clock);
    //InstructionCache instructionCacheInstance(PC, instruction, clock);
    OperationPrep operationPrepInstance(regWriteFlag, readRegister1, readRegister2,
        writeRegister, readData, readData1, readData2, aluSRC, pcOffsetOrig,
        pcOffsetFilled, clock);
    PC pcInstance(branchFlag, unconditionalBranchFlag, zeroFlag, PC,
        pcOffsetFilled, clock);



    //initial begin
    //    $monitor("readData1: ", readData1, "\t readData2: ",readData2,"\t aluControlCode: ",aluControlCode,
    //    "\t result: ",result, "\t zeroFlag ", zeroFlag, "\t carryBit ", carryBit);
    //end

    //This is a workaround to couple both inputs AND outputs from modules to a register.
    //reg [31:0] readData1VAL         = 0;
    //reg [31:0] readData2VAL         = 0;
    //reg [31:0] aluControlCodeVAL    = 0;
    reg [31:0] instructionVAL       = 0;
    //
    //assign readData1 = readData1VAL;
    //assign readData2 = readData2VAL;
    //assign aluControlCode = aluControlCodeVAL;
    assign instruction = instructionVAL;
    //assign pcOffsetOrig = instructionVAL; //PC offset orig is just raw instruction.

    //This is the test function all of the #number represents a timing delay
    initial begin
        clock = 0;
    //    readData1VAL = 15; readData2VAL = 15; aluControlCodeVAL = 2;  //Test the add
    //    #2 aluControlCodeVAL = 7;                                     //Test the CBZ
    //    #2 readData1VAL = 10;                                         //change readData1VAL to 10
    //    #2 aluControlCodeVAL = 10;                                     //Test the subtraction
    //    //Test a large addition
    //    #2 readData1VAL = 2140483647;
    //    #2 readData2VAL = 2141483647;
    //    #2 aluControlCodeVAL = 2;
    //    
    //    #2 readData1VAL = 5;                                          //change readData1VAL to 5
    //    #2 aluControlCodeVAL = 6;                                     //Test the bitwise AND
    //    #2 aluControlCodeVAL = 4;                                     //Test the bitwise OR
    //    #2 readData2VAL = 10;                                         //change readData2 to 10
    //    #2 aluControlCodeVAL = 9;                                     //Test the bitwise XOR
    //    #2 aluControlCodeVAL = 5;                                     //Test the NOR
    //    #2 aluControlCodeVAL = 12;                                    //Test the NAND
    //    #2 aluControlCodeVAL = 13;                                    //Test the MOV
        #3 instructionVAL = 32'h8B150289;                             //ADD R9, R20, R21
        #2 instructionVAL = 32'hcB150289;                             //SUB R9, R20, R21
        #2 instructionVAL = 32'h8A150289;                             //AND R9, R20, R21
        #2 instructionVAL = 32'hAA150289;                             //OR R9, R20, R21

        #2 instructionVAL = 32'h910006D6;                             //ADDI R22, R22, #1
        #2 instructionVAL = 32'hF8400149;                             //LDR  R9, [R10, #0]
        //do a store next STUR X10, [X1, #0]
        //1111 1000 0000 0000 0000 0000 0010 1010
        //F   8    0     0    0    0    2   a
        #2 instructionVAL = 32'hF800002A;                              //STR R10, [R1, #0]
        //CBZ 1011 0100 0000 1000 0000 0000 0000 0000
        //     b    4    0     8   0   0     0     0
        //Here CBZ R1 Here
        #2 instructionVAL = 32'hB4080000;                             //Here CBZ R1 Here
        //0001 0100 0000 0000 0000 0000 0000 0000
        //1     4    0    0     0    0    0    0       
        #2 instructionVAL = 32'h14000000;                              //Here B Here
        //This mov command is from the textbook pg 116. Verify the outputs are ok for this one as we did add.
        #2 instructionVAL = 32'hD2A01FE9;                              //MOVZ X9, 255, LSL 16
        
    end
    always
        #1 clock = ~clock;
endmodule
