module ALU (inOne, inTwo, opcode,result, zeroFlag, clock);

 input clock;
 input[31:0] inOne;
 input[31:0] inTwo;
 input[3:0] opcode;

 output reg [31:0] result;
 output reg zeroFlag;

 always @(*) begin
		case(opcode)
			4'b0010: result = inOne + inTwo;    //LD_STR_ADD opcode
			4'b0111: result = inOne == 0;       //CBZ opcode
			4'b1010: result = inOne - inTwo;    //SUB opcode
			4'b0110: result = inOne & inTwo;    //bitwise AND opcode
			4'b0100: result = inOne | inTwo;    //bitwise OR opcode
			4'b1001: result = inOne ^ inTwo;    //bitwise XOR opcode
			4'b0101: result = ! (inOne | inTwo);//NOR opcode
			4'b1100: result = ! (inOne & inTwo);//NAND opcode
			4'b1101: result = inOne;            //MOV opcode
			default: result = 0;                //undefined opcode
		endcase
    zeroFlag = inOne == 0 ? 1 : 0;
	end
endmodule
