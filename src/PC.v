module PC(branchFlag, unconditionalBranchFlag, zeroFlag, PCOffsetOrig, readAddress, PCScaledOffset, clock);

input clock;
input branchFlag;
input unconditionalBranchFlag;
input zeroFlag;
input [31:0] PCOffsetOrig;

output reg[31:0] readAddress;
output reg[31:0] PCScaledOffset;

wire muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag; // The mux for what the PC should be set to (branch or next instruction)


	always @(posedge clock) begin
		PCScaledOffset = PCOffsetOrig << 2; // Multiplying the offset by 4
		readAddress = (muxSelect == 0) ? readAddress + 4 : readAddress + PCScaledOffset; // If mux == 0 next instruction otherwise branch;
	end
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule
