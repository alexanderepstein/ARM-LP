`ifndef OP_PREP
`define OP_PREP

module OperationPrep(regWrite, reg1, reg2,  writeRegister,
   writeData,  readData1,  readData2, aluSRC, pcOffsetOrig, pcOffsetFilled, clock
);

input clock; // Main clock
input regWrite; // write writeData to writeRegister
input aluSRC; // Mux selector bit for input2 to ALU

input [4:0] reg1; // First register address
input [4:0] reg2; // Second register address
input [4:0] writeRegister; // Register address to write to
input [31:0] writeData; // Data to write to writeRegister
input [31:0] pcOffsetOrig; // Original PC offset


output wire [31:0] readData1; // Data from reg1
output wire [31:0] readData2; // Data from reg2 or instruction
output reg [31:0] pcOffsetFilled; // PC padded with 0s to be 32 bits;


	always @(posedge clock) begin
    //readData1 = reg1; How to get value at this?
    end

endmodule

`endif
