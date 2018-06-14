module InstructionCache(PC, instruction, clock);

input clock; // Main clock
input [31:0] PC; // Address to read for instruction

output reg[31:0] instruction; // Current instruction being read

 	always @(posedge clock) begin
    // instruction = readInstruction?
  end
endmodule
