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
    
    //We will have to do some masking and things to parse the instruction

    always @(posedge clock) begin


    end

endmodule
