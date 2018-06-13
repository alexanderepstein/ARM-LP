module OperationPrep(input wire regWrite, input [4:0] reg1, input[4:0] reg2,
  input[4:0] writeRegister, input[31:0] writeData, output reg [31:0] readData1,
  output reg[31:0] readData2, input wire aluSRC, input [31:0] pcOffsetOrig,
  output reg [31:0] pcOffsetFilled
);

endmodule 