module PC(branchFlag, unconditionalBranchFlag, zeroFlag,
	 PC, pcOffsetFilled, clock);

input clock;
input branchFlag;
input unconditionalBranchFlag;
input zeroFlag;
input [31:0] pcOffsetFilled;

inout [31:0] PC;

reg [31:0] pcScaledOffset;

wire muxSelect;
assign muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag; // The mux for what the PC should be set to (branch or next instruction)

assign PC = (muxSelect == 0) ? PC + 4 : PC + pcScaledOffset; // If mux == 0 next instruction otherwise branch;


	always @(posedge clock) begin
		pcScaledOffset = pcOffsetFilled << 2; // Multiplying the offset by 4
	end
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule
