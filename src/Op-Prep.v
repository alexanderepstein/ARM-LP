module OperationPrep(regWrite, reg1, reg2,  writeRegister,
   writeData,  output1,  output2, aluSRC, pcOffsetOrig, clock
);

input clock; // Main clock
input regWrite; // write writeData to writeRegister
input aluSRC; // Mux selector bit for input2 to ALU

input [4:0] reg1; // First register address
input [4:0] reg2; // Second register address
input [4:0] writeRegister; // Register address to write to
input [31:0] writeData; // Data to write to writeRegister
input [31:0] pcOffsetOrig; // Original PC offset

output reg [31:0] output1; // Data from reg1
output reg [31:0] output2; // Data from reg2 or instruction

	always @(posedge clock) begin
    //  output1 = grabData from reg1;
    // output2 = ~aluSRC ? data from reg2 : pcOffsetOrig;
    end

endmodule
