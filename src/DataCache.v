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

    //You are a 4th stage and ONLY a 4th stage
    reg [3:0] syncData;
    initial begin syncData = 0; end
 

	always @(posedge clock) begin : search
        syncData = syncData + 1;
        if (syncData == 4) begin
        
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
        else begin
            readData =32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
        end
        if (syncData == 5) begin
            syncData = 0;
        end
       

    end

	initial begin
        //I spit their address into their index here
        //FIX THIS DAVID AND FIND WAY TO WORD ALLIGN TO MAXIMIZE SPACE.
        //Probbably LSR 2. Update think the block address does this already
		setAddress[0] = 29'h000000A0; setData[0] = 32'b00000001000000010000000100000001;
		setAddress[1] = 29'h000000A1; setData[1] = 32'b00000010000000100000001000000010;
        setAddress[2] = 29'h000000A2; setData[2] = 32'b00000011000000110000001100000011;
        setAddress[3] = 29'h000000A3; setData[3] = 32'b00000100000001000000010000000100;
        setAddress[4] = 29'h000000A4; setData[4] = 32'b00000101000001010000010100000101;
        setAddress[5] = 29'h000000A5; setData[5] = 32'b00000110000001100000011000000110;
        setAddress[6] = 29'h000000A6; setData[6] = 32'b00000111000001110000011100000111;
        setAddress[7] = 29'h000000A7; setData[7] = 32'b00001000000010000000100000001000;
        setAddress[8] = 29'h000000A8; setData[8] = 32'b00001001000010010000100100001001;
        setAddress[9] = 29'h000000A9; setData[9] = 32'h00000000;
        setAddress[10] = 29'h000000AA; setData[10] = 32'h00000000;
        setAddress[11] = 29'h000000AB; setData[11] = 32'h00000000;
        setAddress[12] = 29'h000000AC; setData[12] = 32'h00000000;
        setAddress[13] = 29'h000000AD; setData[13] = 32'h00000000;
        setAddress[14] = 29'h000000AE; setData[14] = 32'h00000000;
        setAddress[15] = 29'h000000AF; setData[15] = 32'h00000000;
        
        
        
        
	end

  
  
  
endmodule

`endif
