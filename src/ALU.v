module top;

	wire [31:0]result;
	reg [31:0]input1;
	reg [31:0]input2;
	reg [3:0]opcode;
    reg clock;
    wire zeroFlag;
    
    reg memWrite;
    reg memRead;
    reg memToReg;
    reg[31:0] address;
    reg[3:0] writeData;
    wire[31:0] readData;
    
    reg [31:0] instruction;
    reg unconditionalBranch;
    reg branch;
    reg aluOP;
    reg aluSRC;
    reg regWrite;
    reg [4:0] readRegister1;
    reg [4:0] readRegister2;
    reg [4:0] writeRegister;
    
    
    
	ALU ALU_instance(input1, input2, opcode, result, zeroFlag, clock);
    DataCache dataCacheInstance(memWrite, memRead, memToReg, address,
        writeData, readData, clock);
    Controller controllerInstance(instruction, unconditionalBranch,
    branch, memRead, memToReg, aluOP, memWrite, aluSRC, regWrite, readRegister1,
    readRegister2, writeRegister) ;

	initial begin
		$monitor("input1: ", input1, "\t input2: ",input2,"\t opcode: ",opcode,
        "\t result: ",result);
	end	

    //This is the test function all of the #number represents a timing delay
	initial begin
		input1 = 15; input2 = 15; opcode = 2;   //Test the add
		#2 opcode = 7;                          //Test the CBZ
		#2 input1 = 10;                         //change input1 to 10
		#2 opcode = 3;                          //Test the subtraction
		#2 input1 = 5;                          //change input1 to 5
		#2 opcode = 6;                          //Test the bitwise AND
		#2 opcode = 4;                          //Test the bitwise OR
		#2 input2 = 10;                         //change input2 to 10
		#2 opcode = 9;                          //Test the bitwise XOR
		#2 opcode = 5;                          //Test the NOR
		#2 opcode = 12;                         //Test the NAND
		#2 opcode = 13;                         //Test the MOV
	end
    always
        #1 clock = ~clock;
endmodule

module ALU (input[31:0] inOne,input[31:0] inTwo, input[3:0]opcode,
 output reg [31:0]result, output reg zeroFlag, input clock);
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
                if (inOne == 0) begin
            		zeroFlag = 1;
        	end
        	else begin
            		zeroFlag = 0;
        	end
	end
endmodule 
