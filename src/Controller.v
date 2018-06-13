module Controller(input[10:0] instruction, output wire unconditionalBranch,
    output wire branch, output wire memRead, output wire memToReg,
    output wire aluOP, output wire memWrite, output wire aluSRC,
    output wire regWrite, output reg [4:0] readRegister1,
    output reg [4:0] readRegister2, output reg [4:0] writeRegister, input reg clock) ;

    //reg2Loc field stays within this field and can thus be handled as a local variable.
    reg reg2Loc;

    always @(posedge clock) begin

    
    end
    
endmodule 
