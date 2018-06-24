module Controller(instruction, unconditionalBranch, branch, memRead, memToReg,
    aluControlCode, memWrite, aluSRC, regWriteFlag, readRegister1,
    readRegister2,  writeRegister, clock) ;
    
    input [31:0] instruction; //instruction being input into the controller from instruction cache for parsing
    
    output wire unconditionalBranch; //Flag output from the controller into the pc
    output wire branch;              //Flag output from the controller into the pc
    output wire memRead;             //Flag output from the controller for use in Data Cache
    output wire memToReg;            //Flag output from the controller for use in Data Cache
    output wire [3:0] aluControlCode;//Output from the controller for use in ALU.
    output wire memWrite;            //Flag output from the controller for use in Data Cache
    output wire aluSRC;              //Flag output from the controller for use in ALU
    output wire regWriteFlag;        //Flag output from the controller for use in Data Cache
    
    output reg [4:0] readRegister1;  //register 1 ID from Decoder & Control to Operand Prep
    output reg [4:0] readRegister2;  //register 2 ID from Decoder & Control to Operand Prep
    output reg [4:0] writeRegister;  //write register ID from Decoder & Control to Operand Prep
    
    input clock;                     ///Main clock

    //reg2Loc field stays within this field and can thus be handled as a local variable.
    reg reg2Loc;
    
    reg [1:0] aluOp;
    
    reg unconditionalBranchReg;
    reg branchReg;
    reg memReadReg;
    reg memToRegReg;
    reg memWriteReg;
    reg aluSRCReg;
    reg regWriteFlagReg;
    reg [3:0] aluControlCodeVal;
    //Internal assigns to registers to allow compile and constrain updates to clocks
    assign unconditionalBranch = unconditionalBranchReg;
    assign branch = branchReg;
    assign memRead = memReadReg;
    assign memToReg = memToRegReg;
    assign memWrite = memWriteReg;
    assign aluSRC = aluSRCReg;
    assign regWriteFlag = regWriteFlagReg;
    assign aluControlCode = aluControlCodeVal;
        
    always @(posedge clock) begin        
        //bit 31 always on for all instructions
        //reg2loc i25 and i28 are the dependent bits
        reg2Loc = (instruction[28] == 1 && instruction[25] == 0) ? 1 : 0;
        
        //aluSRC  dependent on i25 and i28 OR i26 and i30 
        //check to see if i25 and i28 are set
        if (instruction[28] == 1 && instruction[25] == 0) begin
            //rule out CBZ
            if (instruction[30] == 0 && instruction[26] == 1) begin
                aluSRCReg = 0;
            end
            //accept others
            else begin
                aluSRCReg = 1;
            end
        end
        //refuse those with i25 and i28 not in correct configuration
        else begin
            aluSRCReg = 0;
        end
        
        //memToReg can be based soley on i22
        memToRegReg = (instruction[22] == 1) ? 1 : 0;
        
        //i22 & i26 also ldr for regWriteFlag
        if (instruction[22] == 1 && instruction[26] == 0) begin
            regWriteFlagReg = 1;
        end
        //i25 and i28 for r type (and mov)
        else if (instruction[25] == 1 && instruction[28] == 0) begin
            regWriteFlagReg = 1;
        end
        //i26 and i27 for i type
        else if (instruction[26] == 0 && instruction[27] == 0) begin
            regWriteFlagReg = 1;
        end
        //Those all have it on. Other wise, off.
        else begin
            regWriteFlagReg = 0;
        end
        
        //memRead only load does this. i22 and i26 and i25
        if (instruction[22] == 1 && instruction[26] == 0 && instruction[25] == 0) begin
            memReadReg = 1;
        end
        else begin
            memReadReg = 0;
        end
        
        //memWrite only str does this. Dependent on i22, i25, i26, i27
        if (instruction[22] == 0 && instruction[25] == 0 && instruction[26] == 0 
            && instruction[27] == 1) begin
            memWriteReg = 1;
        end
        else begin
            memWriteReg = 0;
        end
        
        //branch flag is set on the CBZs. 
        //I am ruling OUT i24 bit 8 as CBZ and CBNZ differ on it
        //based soley on i26
        if (instruction[26] == 1) begin
            branchReg = 1;
        end
        else begin
            branchReg = 0;
        end
        
        //unconditionalBranch occurs only on a branch and a branch and link
        if (instruction[30] == 0 && instruction[29] == 0 && instruction[28] == 1 
            && instruction[27] == 0 && instruction[26] == 1) begin
            unconditionalBranchReg = 1;
        end
        else begin
            unconditionalBranchReg = 0;
        end
        
        //aluOp[1]
        //i22 rules out load
        if (instruction[22] == 1) begin
            aluOp[1] = 0;
        end
        //i26 rules out cbz
        else if (instruction[26] == 1) begin
            aluOp[1] = 0;
        end
        //i25 then i27 to rule out store.
        else if (instruction[25] == 0 && instruction[27] == 1) begin
            aluOp[1] = 0;
        end
        //rule out MOV. i26 and i23
        else if (instruction[26] == 0 && instruction[23] == 1) begin
            aluOp[1] = 0;
        end
        else begin
            aluOp[1] = 1;
        end
        
        //ALUOP0 is only on for branching
        if (instruction[26] == 1) begin
            aluOp[0] = 1;
        end
        else begin 
            aluOp[0] = 0;
        end

        //set up the read registers.
        //register 2 is based on mux select reg2Loc
        if(reg2Loc == 1) begin
            //grab lower 5 bits
            readRegister2 = (instruction & 32'h0000001F);
            //0000_0000_0000_0000_0000_0000_000x_xxxx is the masking
            // 0    0    0    0     0    0    1    F
        end
        else begin
            //bits 16-20
            //0000_0000_000x_xxxx_0000_0000_0000_0000 is the mask
            //0     0    1    F    0    0     0     0
            //then slam it right 16 bits
            readRegister2 = (instruction & 32'h001F0000) >> 16;
        end
        
        //bits 5-9
        //0000_0000_0000_0000_0000_00xx_xxx0_0000 is the masking
        //0     0    0    0    0    3    e    0
        //then slam it right 5 bits
        readRegister1 = (instruction & 32'h000003E0) >> 5;
        
        //lowest 5 bits
        writeRegister = (instruction & 32'h0000001F);

        
        //ALU control code logic is on pg 273 in book.
        //ALU control code 0001 is based soley off of ALUOP1 and i29
        if (aluOp[1] == 1 && instruction[29] == 1) begin
            aluControlCodeVal = 4'b001;
        end
        //i29 and i24
        else if (aluOp[1] == 1 && instruction[29] == 0 && instruction[24] == 0) begin
            aluControlCodeVal = 4'b0000;
        end
        //i30
        else if (aluOp[1] == 1 && instruction[30] == 1) begin
            aluControlCodeVal = 4'b0110;
        end
        //also i30
        else if (aluOp[1] == 1 && instruction[30] == 0) begin
            aluControlCodeVal = 4'b0010;
        end
        //aluOp0 dependents now
        else if (aluOp[0] == 1) begin
            aluControlCodeVal = 4'b0111;
        end
        else if (aluOp[1] == 0 && aluOp[0] == 0) begin
            aluControlCodeVal = 4'b0010;
        end
        //This is the MOV ALU OP code as defined by the ARM TRM
        else if (aluOp[1] == 0 && aluOp[0] == 0 && instruction[23] == 1 && instruction[26] == 0) begin
            aluControlCodeVal = 4'b1101;
        end
        else begin
            //unaccounted for case. Throwing up a debug register
            //Used for debugging. Thats it.
            aluControlCodeVal = 'bx;
        end
                
        
    end

endmodule
