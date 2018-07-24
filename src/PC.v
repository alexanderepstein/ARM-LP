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
    assign PC = (PC_out != 0)? PC_out : PC_in;

    reg [31:0] pcScaledOffset;
    reg [31:0] internalPCReg;
    reg [2:0] syncPC; //want to sync the PC every 5th clock cycle

    // The mux for what the PC should be set to (branch or next instruction)
    wire muxSelect;
    assign muxSelect = (zeroFlag & branchFlag) | unconditionalBranchFlag;
    
    initial begin
        syncPC = 0;
        PC_out = 0;
        PC_in = 32'h100;
    end
    //This is not going to work.Going to be updating the PC a shit ton.
    //assign PC to track internalPCReg, which only updates on rising edges
    //assign PC = internalPCReg; // If mux == 0 next instruction otherwise branch;

	always @(posedge clock) begin
		pcScaledOffset <= pcOffsetFilled << 3; // Multiplying the offset by 4. UPDATE NOW 8 DUE TO HOW WE HAVE DONE THE CACHES INCREMENTING BY 8
        //Fuck you our processor now does 64 bit addressing. IF NOT WE NEED TO CHANGE CACHE TO DROP 2 BIT INSTEAD OF 3
        internalPCReg <= (muxSelect == 0) ? PC + 8 : PC + pcScaledOffset; 
        syncPC = syncPC + 1;
        if (syncPC == 5) begin
            PC_out = internalPCReg;
            syncPC = 0;
        end
	end
    
	// Check that you can use the readAddress as an input and output (if i had to guess this is not a valid practice)
endmodule

`endif
