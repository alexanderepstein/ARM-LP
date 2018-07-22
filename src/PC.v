`ifndef PC
`define PC

module PC(branchFlag, unconditionalBranchFlag, zeroFlag,
	 PC, pcOffsetFilled, clock);

    input clock;
    input branchFlag;
    input unconditionalBranchFlag;
    input zeroFlag;
    input [31:0] pcOffsetFilled;

    inout [31:0] PC;
    reg [31:0] PC_in;
    reg [31:0] PC_out;

    reg [31:0] pcScaledOffset;
    reg [31:0] internalPCReg;
    reg [2:0] syncPC; //want to sync the PC every 5th clock cycle

    // The mux for what the PC should be set to (branch or next instruction)
    wire muxSelect;
    assign muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag;
    
    initial begin
        syncPC = 0;
        PC_out = 0;
        PC_in = PC;
    end
    //This is not going to work.Going to be updating the PC a shit ton.
    //assign PC to track internalPCReg, which only updates on rising edges
    //assign PC = internalPCReg; // If mux == 0 next instruction otherwise branch;

	always @(posedge clock) begin
		pcScaledOffset <= pcOffsetFilled << 2; // Multiplying the offset by 4
        internalPCReg <= (muxSelect == 0) ? PC + 4 : PC + pcScaledOffset;
        syncPC = syncPC + 1;
        if (syncPC == 5) begin
            PC_out = internalPCReg;
            syncPC = 0;
        end
	end
    
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule

`endif
