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

	initial begin
        //I spit their address into their index here
        //FIX THIS DAVID AND FIND WAY TO WORD ALLIGN TO MAXIMIZE SPACE.
        //Probbably LSR 2. Update think the block address does this already
		setAddress[256%16] = 29'h00000201; setData[256%16] = 32'h01010101;
		setAddress[257%16] = 29'h00000202; setData[257%16] = 32'h02020202;
		setAddress[258%16] = 29'h00000203; setData[258%16] = 32'h03030303;
   		setAddress[259%16] = 29'h00000204; setData[259%16] = 32'h04040404;
		setAddress[260%16] = 29'h00000205; setData[260%16] = 32'h05050505;
		setAddress[261%16] = 29'h00000206; setData[261%16] = 32'h06060606;
		setAddress[262%16] = 29'h00000207; setData[262%16] = 32'h07070707;
		setAddress[263%16] = 29'h00000208; setData[263%16] = 32'h08080808;
		setAddress[264%16] = 29'h00000209; setData[264%16] = 32'h09090909;
        setAddress[265%16] = 29'h0000020a; setData[265%16] = 32'hDEADBEEF;
        setAddress[266%16] = 29'h0000020b; setData[266%16] = 32'hFADECAFE;
        setAddress[267%16] = 29'h0000020c; setData[267%16] = 32'hBA5EBA11;
        setAddress[268%16] = 29'h0000020d; setData[268%16] = 32'hC0DEBABE;
        setAddress[269%16] = 29'h0000020e; setData[269%16] = 32'hFEEDFACE;
		setAddress[270%16] = 29'h0000020f; setData[270%16] = 32'h000FADED;
        
	end

endmodule

`endif
