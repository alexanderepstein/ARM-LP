module ALU (inOne, inTwo, opcode,result, zeroFlag, clock, carryBit);

 wire memReadFlag;               //flag from Decoder & Control for use in Data Cache
 input clock;                    //Main clock
 input [31:0] inOne;             //data field 1 input
 input [31:0] inTwo;             //data field 2 input
 input [3:0] opcode;             //ALU control code

 output reg [31:0] result;      //result of ALU operation
 output wire zeroFlag;
 output wire carryBit;
 reg [32:0] maxNum = 2147483647;
 reg [32:0] minNum = -2147483648;
 assign zeroFlag = inTwo == 0 ? 1 : 0; // Flag is set if inTwo is a 0
 assign carryBit = (((inOne + inTwo) > maxNum) || ((inOne + inTwo) < minNum)
                    || ((inOne - inTwo) < maxNum) || ((inOne - inTwo) > maxNum))
                    ? 1 : 0;


 always @(posedge clock) begin
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
	end
endmodule
