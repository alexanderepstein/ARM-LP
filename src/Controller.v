`ifndef CONTROLLER
`define CONTROLLER
module Controller(instruction, unconditionalBranch, branch, memRead, memToReg,
    aluControlCode, memWrite, aluSRC, regWriteFlag, readRegister1,
    readRegister2,  writeRegister, clock , opType) ;

   `define LD_TYPE 0
   `define CB_TYPE 1
   `define R_TYPE  2
   `define ST_TYPE 3
   `define I_TYPE  4
   `define B_TYPE  5
   `define M_TYPE  6


    input clock;              //Main clock
    input [31:0] instruction; //instruction being input into the controller from instruction cache for parsing

    output wire unconditionalBranch; //Flag output from the controller into the pc
    output wire branch;              //Flag output from the controller into the pc x
    output wire memRead;             //Flag output from the controller for use in Data Cache x
    output wire memToReg;            //Flag output from the controller for use in Data Cache x
    output reg [3:0] aluControlCode;//Output from the controller for use in ALU.
    output wire memWrite;            //Flag output from the controller for use in Data Cache x
    output wire aluSRC;              //Flag output from the controller for use in ALU x
    output wire regWriteFlag;        //Flag output from the controller for use in Data Cache x

    output reg [4:0] readRegister1;  //register 1 ID from Decoder & Control to Operand Prep
    output reg [4:0] readRegister2;  //register 2 ID from Decoder & Control to Operand Prep
    output reg [4:0] writeRegister;  //write register ID from Decoder & Control to Operand Prep


    wire reg2Loc; //reg2Loc field stays within this field and can thus be handled as a local variable.
    output reg [2:0] opType;
    reg [1:0] aluOP; // Local feld that will help determine outout for aluControlCode


    assign reg2Loc = opType == `CB_TYPE || opType == `ST_TYPE ? 1 : 0;
    assign aluSRC = opType == `R_TYPE || opType == `CB_TYPE ? 0 : 1;
    assign memToReg = opType == `LD_TYPE ? 1 : 0;
    assign regWriteFlag = opType == `R_TYPE || opType == `LD_TYPE || opType == `M_TYPE ? 1 : 0;
    assign memRead = opType == `LD_TYPE ? 1 : 0;
    assign memWrite = opType == `ST_TYPE ? 1 : 0;
    assign branch = opType == `CB_TYPE ? 1 : 0;
    assign unconditionalBranch = opType == `B_TYPE ? 1 : 0;

    //assign aluControlCode = opType;
    always @* begin
      // determine addresses for op-prep
      readRegister1 = instruction[9:5];
      if (reg2Loc == 0) begin readRegister2 = instruction[20:16]; end
      else begin readRegister2 = instruction[4:0]; end
      writeRegister = instruction[4:0];

      // Determine optype
      if (instruction[26] == 1) begin
        if (instruction[29] == 1) begin opType = `CB_TYPE; end
        else begin opType = `B_TYPE;  end
      end
      else if (instruction[28] == 0) begin opType = `R_TYPE; end
      else if (instruction[23] == 1) begin opType = `M_TYPE; end
      else if (instruction[22] == 1) begin opType = `LD_TYPE; end
      else if (instruction[27] == 1) begin opType = `ST_TYPE; end
      else begin opType = `I_TYPE; end

      // Determine ALU OP
      aluOP = 0;
      if (opType == `R_TYPE) begin aluOP = 2; end
      else if (opType == `CB_TYPE) begin aluOP = 1; end

      //Determine ALU Control Code
      if (opType == `LD_TYPE || opType == `ST_TYPE) begin
        aluControlCode = 4'b0010; // Add opcode for load and store 2
      end
      else if (aluOP == 1) begin aluControlCode = 4'b0111; end // CBZ opcode 7
      else if (opType == `M_TYPE) begin aluControlCode = 4'b1101; end // MOV opcode 13
      else if (aluOP == 2) begin // R_TYPE
        if (instruction[24] == 1) begin //ADD or SUB
          if (instruction[30] == 0) begin aluControlCode = 4'b0010; end // ADD 2
          else begin aluControlCode = 4'b1010; end // SUB 10
        end
        else if (instruction[29] == 0) begin aluControlCode = 4'b0110; end // AND 6
        else if (instruction[30] == 0) begin aluControlCode = 4'b0100; end // OR 4
        else begin aluControlCode = 4'b1001; end //XOR 9
      end
      else if (opType == `I_TYPE) begin
        if (instruction[29] == 1) begin aluControlCode = 4'b0100; end // ORI
        else if (instruction[30] == 1) begin // XORI or SUBI
          if (instruction[25] == 1) begin aluControlCode = 4'b1001; end //XORI 9
          else begin aluControlCode = 4'b1010; end // SUBI 10
        end
        else if (instruction[25] == 1) begin aluControlCode = 4'b0110; end // ANDI 6
        else begin aluControlCode =  4'b0010; end // ADDI 2
      end
      else begin
        aluControlCode = 0; // Default
      end
    end

    always @(posedge clock) begin

    end

endmodule
`endif
