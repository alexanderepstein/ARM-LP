`ifndef DATACACHE
`define DATACACHE

module DataCache( memWrite,  memRead, memToReg, address,  writeData,  readData, clock);

 input clock; // Clock
 input memWrite; // Controls weather we are writing to memory
 input memRead; // Controls weather we are reading from the memory
 input memToReg; // Controls weather we are ouputting to a register
 input [31:0] address; // Address to read or write to
 input [31:0] writeData; // Data to write into address

 output reg[31:0] readData; // Data read from address

	always @(posedge clock) begin

  end
endmodule

`endif
