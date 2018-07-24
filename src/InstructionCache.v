`ifndef INSTRUCTIONCACHE
`define INSTRUCTIONCACHE

module InstructionCache(PC, instruction, clock);

input clock; // Main clock
input [31:0] PC; // Address to read for instruction
//You may have to update the PC and all addresses by 8 all the time in order 
//for the caches to function properly

`ifdef DEBUG
  input [31:0] instruction; //For now when testing controller
`else
  output reg[31:0] instruction; // Current instruction being read
`endif
   
	reg [28:0]setAddress[0:15]; //1 line per set (16 sets). So I do one reg per set.
   	reg [31:0]setData[0:15]; 
	reg [6:0]i;
    wire [28:0]blockAddress = PC[31:3];

	wire [3:0] setID = blockAddress % 16; // I have 16 sets
    assign setID = blockAddress % 16;

	always @(posedge clock) begin : search
        //Item was in the cache
        if(blockAddress == setAddress[setID]) begin
            //if we are reading return the data that is there
            instruction = setData[setID];
            disable search;
        end
        //dont have anything. Put the shit in the right spot. Should not ever happen for this processor
        else begin
                setAddress[setID] = blockAddress;
                //We would fetch the data up but we don't know what is there since 1 level
                //fill with the special sauce
                setData[setID] = 32'hDEAD_BEEF;
                instruction = 32'hDEAD_BEEF;           
        end
       

    end

    //TEST A NEGATIVE NUMBER YOU FUCK
	initial begin
        //I spit their address into their index here
        //FIX THIS DAVID AND FIND WAY TO WORD ALLIGN TO MAXIMIZE SPACE.
        //Probbably LSR 2. Update think the block address does this already
        //These will ALL work
		setAddress[0] = 29'h00000020; setData[0] = 32'b10010001000000000000011011010110; // ADDI X22, X22, #1; May God save us
   		setAddress[1] = 29'h00000021; setData[1] = 32'b10010001000000000010000011000110; // ADDI X6, X6, #8; May God save us
   		setAddress[2] = 29'h00000022; setData[2] = 32'b10010001000000000100000000100001; // ADDI X1, X1, #16; May God save us
        setAddress[3] = 29'h00000023; setData[3] = 32'b10001011000000010000001011000001; // ADD X1,X22,X1 //Works
        //All of the above function properly
        setAddress[4] = 29'h00000024; setData[4] = 32'b10010001000000000001001111100000; // ADDI R0, RZR, #4 //works
        
        setAddress[5] = 29'h00000025; setData[5] = 32'b10010001000101000000001111100010; //ADDI R2, R31, #1280 (0x500); //Works
        setAddress[6] = 29'h00000026; setData[6] = 32'b11111000010000000000000001000011; //LDUR R3, [R2, #0] // Should load 0x101 0101 //Works
        setAddress[7] = 29'h00000027; setData[7] = 32'b11111000010000010000000001000100; //LDUR R4, [R2, #16]//works
        setAddress[8] = 29'h00000028; setData[8] = 32'b10001011000001000000000001100101; //ADD R5, R3, R4 //89ns works
        setAddress[9] = 29'h00000029; setData[9] = 32'b11111000000000000000000001000101; //STUR R5, [R2,#0] //91ns begin. Works 97ns
        setAddress[10] = 29'h0000002A; setData[10] = 32'b10010001000000000010000001000010;  //ADDI R2, R2, #8 //works 109ns
        setAddress[11] = 29'h0000002B; setData[11] = 32'b11010001000000000000010000000000; //SUBI R0, R0, #1 /works 109ns
        setAddress[12] = 29'h0000002C; setData[12] = 32'b10110101111111111111111101000000; //CBNZ R0, Loop
        setAddress[13] = 29'h0000002D; setData[12] = 32'b11001011000001100000000011000110; //SUB R6, R6, R6




		//setAddress[258%16] = 29'h00000202; setData[258%16] = 32'b11101010000101010000001010001001; // XOR X9,X20,X21
		
		//setAddress[260%16] = 29'h00000205; setData[260%16] = 32'h05050505;
		//setAddress[261%16] = 29'h00000206; setData[261%16] = 32'h06060606;
		//setAddress[262%16] = 29'h00000207; setData[262%16] = 32'h07070707;
		//setAddress[263%16] = 29'h00000208; setData[263%16] = 32'h08080808;
		//setAddress[264%16] = 29'h00000209; setData[264%16] = 32'h09090909;

        
	end

endmodule

`endif
