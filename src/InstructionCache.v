`ifndef INSTRUCTIONCACHE
`define INSTRUCTIONCACHE

module InstructionCache(PC, instruction, clock);

input clock; // Main clock
input [31:0] PC; // Address to read for instruction

`ifdef DEBUG
  input [31:0] instruction; //For now when testing controller
`else
  output reg[31:0] instruction; // Current instruction being read
`endif

 	always @(posedge clock) begin
    // instruction = readInstruction?
  end
endmodule

`endif
