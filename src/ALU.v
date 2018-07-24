`ifndef ALU
`define ALU

module ALU (inOne, inTwo, opcode,result, zeroFlag, clock, carryBit, invertZeroFlag);

 wire memReadFlag;               //flag from Decoder & Control for use in Data Cache
 input clock;                    //Main clock
 input [31:0] inOne;             //data field 1 input
 input [31:0] inTwo;             //data field 2 input
 input [3:0] opcode;             //ALU control code
 input invertZeroFlag;

 output reg [31:0] result;      //result of ALU operation
 output reg zeroFlag;
 output reg carryBit;
 //check if our second input is 0. If it is we should output a 1, but check the 
 //inversion flag first
 //assign zeroFlag = inTwo == 0 ? invertZeroFlag==1 ? 0 : 1 : 0; // Flag is set if inTwo is a 0

 reg [3:0] syncALU;
 initial begin syncALU = 0; end
 
 always @(posedge clock) begin
        //figure out the zero flag. If the invertflag is on flip it
        if (inTwo == 0) begin
            if (invertZeroFlag == 1) begin
                zeroFlag = 0;
            end
            else begin
                zeroFlag = 1;
            end
        end
        else begin
            if (invertZeroFlag == 1) begin
                zeroFlag = 1;
            end
            else begin
                zeroFlag = 0;
            end
        end
        syncALU = syncALU + 1;
        
        if (syncALU == 3) begin
            case(opcode)
                4'b0010: {carryBit,result} = inOne + inTwo;    //LD_STR_ADD opcode
                4'b0111: result = inTwo;       //CBZ opcode
                4'b1010: {carryBit,result} = inOne - inTwo;    //SUB opcode
                4'b0110: result = inOne & inTwo;    //bitwise AND opcode
                4'b0100: result = inOne | inTwo;    //bitwise OR opcode
                4'b1001: result = inOne ^ inTwo;    //bitwise XOR opcode
                4'b0101: result = ! (inOne | inTwo);//NOR opcode
                4'b1100: result = ! (inOne & inTwo);//NAND opcode
                4'b1101: result = inOne;            //MOV opcode
                default: result = 0;                //undefined opcode
            endcase
        end
        else if (syncALU==5) begin
            syncALU = 0;
        end
	end
endmodule

`endif
