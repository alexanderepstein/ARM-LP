`ifndef OP_PREP
`define OP_PREP

module OperationPrep(memWriteFlag, memReadFlag, regWrite, reg1, reg2,  writeRegister,
   writeData,  readData1,  readData2, aluSRC, pcOffsetOrig, pcOffsetFilled, 
   writeDataToDCache, clock
);

input clock; // Main clock
input regWrite; // write writeData to writeRegister
input aluSRC; // Mux selector bit for input2 to ALU
input memWriteFlag;              //Used for determining readData2 val. IE it should use 9 bit addr for D type.
input memReadFlag;               //Used for determining readData2 val. IE it should use 9 bit addr for D type.
input [4:0] reg1; // First register address
input [4:0] reg2; // Second register address
input [4:0] writeRegister; // Register address to write to
input [31:0] writeData; // Data to write to writeRegister
input [31:0] pcOffsetOrig; // Original PC offset


output reg [31:0] readData1; // Data from reg1
output reg [31:0] readData2; // Data from reg2 or instruction
output reg [31:0] pcOffsetFilled; // PC padded with 0s to be 32 bits;
output reg [31:0] writeDataToDCache; //going to D Cache

reg [31:0] register[31:0]; //These are the registers

 reg [3:0] syncOpPrep;
 initial begin syncOpPrep = 0; end
 
//This screams timing conflict
//assign readData1 = register[reg1];
//assign readData2 = register[reg1];

	always @(posedge clock) begin
        syncOpPrep = syncOpPrep + 1;
        //zero is for redundancy. SHOULD be 5 at this point
        if (syncOpPrep == 2 || syncOpPrep == 5 || syncOpPrep == 4 || syncOpPrep == 0) begin
            //I would rather do it this way as it avoid timing conflicts
            readData1 = register[reg1];
            
            //verify that this does not have timing issues. I am reading the data 
            //above first before any potential modification
            if (regWrite == 1) begin
                if (writeData !== 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz) begin
                    register[writeRegister] = writeData;
                end
                //otherwise we are not ready to writeback and do not want intermediate values
            end
        
            //Sign extending the PC
            //see if opcode is a branch
            if(pcOffsetOrig[31:26] == 6'b100101 || pcOffsetOrig[31:26] == 6'b000101) begin
                pcOffsetFilled[31:0] <= { {6{pcOffsetOrig[25]}}, pcOffsetOrig[25:0] };
            end
            //conditional branch
            else begin
                pcOffsetFilled[31:0] <= { {18{pcOffsetOrig[18]}}, pcOffsetOrig[18:5] };
            end
            //determine if it should be an immediate or a reg.
            //D type is going to be wonky a bit
            if (aluSRC) begin
                if (memReadFlag || memWriteFlag) begin
                    readData2 = { {23{pcOffsetOrig[20]}}, pcOffsetOrig[20:12]};
                end
                else begin 
                    readData2 = { {20{pcOffsetOrig[21]}}, pcOffsetOrig[21:10]};
                end
            end
            else begin
                readData2 = register[reg2];
            end
            writeDataToDCache = register[reg2];
        end
        if (syncOpPrep == 5) begin
            syncOpPrep = 0;
        end
        

        
    end
    
    
    initial begin
        //Zeroize all the registers
		register[0] <= 0;
        register[1] <= 0;
        register[2] <= 0;
        //register[3] <= 0;
        //Trying to not branch in Carpenters test.
        register[3] <= 1;
        register[4] <= 0;
        register[5] <= 0;
        register[6] <= 0;
        register[7] <= 0;
        register[8] <= 0;
        register[9] <= 0;
        register[10] <= 0;
        register[11] <= 0;
        register[12] <= 0;
        register[13] <= 0;
        register[14] <= 0;
        register[15] <= 0;
        register[16] <= 0;
        register[17] <= 0;
        register[18] <= 0;
        register[19] <= 0;
        //register[20] <= 0;
        //Carpenter test below
        register[20] <= 1280;
        register[21] <= 0;
        register[22] <= 0;
        register[23] <= 0;
        register[24] <= 0;
        //register[25] <= 0;
        //Carpenter test below
        register[25] = 24;
        register[26] <= 0;
        register[27] <= 0;
        register[28] <= 0;
        register[29] <= 0;
        register[30] <= 0;
        register[31] <= 0;
	end

endmodule

`endif
