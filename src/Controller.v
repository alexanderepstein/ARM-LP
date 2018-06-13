module Controller(input[10:0] instruction, output reg unconditionalBranch,
    output reg branch, output reg memRead, output reg memToReg,
    output reg aluOP, output reg memWrite, output reg aluSRC,
    output reg regWrite, output reg [4:0] readRegister1,
    output reg [4:0] readRegister2, output reg [4:0] writeRegister, input clock) ;

    reg reg2Loc;

    always @(posedge clock) begin

    
        //reg2Loc field stays within this field and can thus be handled as a local variable.
    end
    
endmodule 