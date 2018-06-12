module PC(input wire branchFlag, input wire unconditionalBranchFlag, input wire zeroFlag, input reg[31:0] PCOffset, output reg[31:0] readAddress);
	
	wire muxSelect;

	always @ * begin
		PCOffset = PCOffset << 2; // Multiplying the offset by 4 
		muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag; // The mux for what the PC should be set to (branch or next instruction) 
		readAddress = (muxSelect == 0) ? readAddress + 4 : readAddress + PCOffset;  // If mux == 0 next instruction otherwise branch
	end
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule 
