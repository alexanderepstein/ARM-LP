`ifndef DATACACHE
`define DATACACHE

module DataCache( memWrite,  memRead, memToReg, address,  writeData,  readData, clock);

    input clock; // Clock
    input memWrite; // Controls weather we are writing to memory
    input memRead; // Controls weather we are reading from the memory
    input memToReg; // Controls weather we are ouputting to a register
    input [31:0] address; // Address to read or write to. Update by 8 each time
    input [31:0] writeData; // Data to write into address

    output reg[31:0] readData; // Data read from address
 
	reg [28:0]setAddress[0:15]; //1 line per set (16 sets). So I do one reg per set.
   	reg [31:0]setData[0:15]; 
	reg [6:0]i;
    wire [28:0]blockAddress = address[31:3];

	wire [3:0] setID = blockAddress % 16; // I have 16 sets
    assign setID = blockAddress % 16;



	always @(posedge clock) begin : search
        //Not accessing any of the cache
        if (memToReg==0) begin
            readData = address;
            disable search;
        end
        
        if(blockAddress == setAddress[setID]) begin
            //if we are reading return the data that is there
            if(memRead) begin
                readData = setData[setID];
            end //if
            //we are writing and want to update what was there
            else if(memWrite) begin
                setData[setID] = writeData;
                readData = setData[setID];
            end //else
            disable search;
        end
        //dont have anything. Put the shit in the right spot. Should not ever happen for this processor
        else begin
            if(memRead) begin
                setAddress[setID] = blockAddress;
                //We would fetch the data up but we don't know what is there since 1 level
                //fill with the special sauce
                setData[setID] = 32'hDEAD_BEEF;
                readData = 32'hDEAD_BEEF;
            end
            else if (memWrite) begin
                setAddress[setID] = blockAddress;
                setData[setID] = writeData;
                readData = setData[setID];
            end
           
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
