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


output reg [31:0] readData1; // Data from reg1
output reg [31:0] readData2; // Data from reg2 or instruction
output reg [31:0] pcOffsetFilled; // PC padded with 0s to be 32 bits;

reg [31:0] register[4:0]; //These are the registers

//This screams timing conflict
//assign readData1 = register[reg1];
//assign readData2 = register[reg1];

	always @(posedge clock) begin
        //I would rather do it this way as it avoid timing conflicts
        readData1 <= register[reg1];
        readData2 <= register[reg2];
        
        //verify that this does not have timing issues. I am reading the data 
        //above first before any potential modification
        if (regWrite == 1) begin  register[writeRegister] = writeData; end
    
        //Sign extending the PC
        //see if opcode is a branch
        if(pcOffsetOrig[31:26] == 6'b100101 || pcOffsetOrig == 6'b000101) begin
            pcOffsetFilled[31:0] <= { {6{pcOffsetOrig[25]}}, pcOffsetOrig[25:0] };
        end
        //conditional branch
        else begin
            pcOffsetFilled[31:0] <= { {13{pcOffsetOrig[18]}}, pcOffsetOrig[18:0] };
        end
        
    end

endmodule

`endif
