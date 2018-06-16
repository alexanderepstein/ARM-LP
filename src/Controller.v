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
    
    reg aluOp1;
    reg aluOp0;
    
    reg unconditionalBranchReg;
    reg branchReg;
    reg memReadReg;
    reg memToRegReg;
    reg memWriteReg;
    reg aluSRCReg;
    reg regWriteFlagReg;
    //Internal assigns to registers to allow compile and constrain updates to clocks
    assign unconditionalBranch = unconditionalBranchReg;
    assign branch = branchReg;
    assign memRead = memReadReg;
    assign memToReg = memToRegReg;
    assign memWrite = memWriteReg;
    assign aluSRC = aluSRCReg;
    assign regWriteFlag = regWriteFlagReg;
    
    //We will have to do some masking and things to parse the instruction

    always @(posedge clock) begin
        //the endianess for the table I am using starts bit 31 as bit 0 as indexed
        //here in this code, hence why the array indexing appears off.
        
        //bit 31 always on for all instructions
        //reg2loc i25 and i28 are the dependent bits
        reg2Loc = (instruction[3] == 1 && instruction[6] == 0) ? 1 : 0;
        
        //aluSRC  dependent on i25 and i28 OR i26 and i30 
        //check to see if i25 and i28 are set
        if (instruction[3] == 1 && instruction[6] == 0) begin
            //rule out CBZ
            if (instruction[1] == 0 && instruction[5] == 1) begin
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
        memToRegReg = (instruction[9] == 1) ? 1 : 0;
        
        //i22 & i26 also ldr for regWriteFlag
        if (instruction[9] == 1 && instruction[5] == 0) begin
            regWriteFlagReg = 1;
        end
        //i25 and i28 for r type
        else if (instruction[6] == 0 && instruction[3] == 0) begin
            regWriteFlagReg = 1;
        end
        //i26 and i27 for i type
        else if (instruction[5] == 0 && instruction[4] == 0) begin
            regWriteFlagReg = 1;
        end
        //Those all have it on. Other wise, off.
        else begin
            regWriteFlagReg = 0;
        end
        
        //memRead only load does this. i22 and i26
        if (instruction[9] == 1 && instruction[5] == 0) begin
            memReadReg = 1;
        end
        else begin
            memReadReg = 0;
        end
        
        //memWrite only str does this. Dependent on i22, i25, i26, i27
        if (instruction[9] == 0 && instruction[6] == 0 && instruction[5] == 0 
            && instruction[4] == 1) begin
            memWriteReg = 1;
        end
        else begin
            memWriteReg = 0;
        end
        
        //branch flag is set on the CBZs. 
        //I am ruling OUT i24 bit 8 as CBZ and CBNZ differ on it
        //based soley on i26
        if (instruction[5] == 1) begin
            branchReg = 1;
        end
        else begin
            branchReg = 0;
        end
        
        //unconditionalBranch occurs only on a branch and a branch and link
        if (instruction[1] == 0 && instruction[2] == 0 && instruction[3] == 1 
            && instruction[4] == 0 && instruction[5] == 1) begin
            unconditionalBranchReg = 1;
        end
        else begin
            unconditionalBranchReg = 0;
        end
        
        //aluOp1
        //i22 rules out load
        if (instruction[9] == 1) begin
            aluOp1 = 0;
        end
        //i26 rules out cbz
        else if (instruction[5] == 1) begin
            aluOp1 = 0;
        end
        //i25 then i27 to rule out store.
        else if (instruction[6] == 0 && instruction[4] == 1) begin
            aluOp1 = 0;
        end
        else begin
            aluOp1 = 1;
        end
        
        //ALUOP0 is only on for branching
        if (instruction[5] == 1) begin
            aluOp0 = 1;
        end
        else begin 
            aluOp0 = 0;
        end
        
        //we need to handle aluControlCode and reg2Loc at some point
        
        //HAVE TO SET UP THE REGISTERS TOO!
        
        
    end

endmodule
