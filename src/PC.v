module PC(input wire branchFlag, input wire unconditionalBranchFlag,
 input wire zeroFlag, input reg[31:0] PCOffsetOrig, output reg[31:0] readAddress,
 output reg[31:0] PCScaledOffset);
	
	reg muxSelect;

	always @ * begin
		PCScaledOffset = PCOffsetOrig << 2; // Multiplying the offset by 4 
		muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag; // The mux for what the PC should be set to (branch or next instruction) 
		readAddress = (muxSelect == 0) ? readAddress + 4 : readAddress + PCScaledOffset;  // If mux == 0 next instruction otherwise branch
	end
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule 
