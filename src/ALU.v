module ALU (inOne, inTwo, opcode, result);
	input[31:0] inOne;
	input[31:0] inTwo;
	input[3:0] opcode;
	output[31:0] result;
	reg[31:0] result;

	always @* begin
		case(opcode)
			4'b0010: result = inOne + inTwo;
			4'b0111: result = 0;
			4'b1010: result = inOne - inTwo;
			4'b0110: result = inOne & inTwo;
			4'b0100: result = inOne | inTwo;
			4'b1001: result = inOne ^ inTwo;
			4'b0101: result = ! (inOne | inTwo);
			4'b1100: result = ! (inOne & inTwo);
			4'b1101: result = inOne;
			default: result = 0;
		endcase
	end

endmodule 