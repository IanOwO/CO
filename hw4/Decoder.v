module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o, MemtoReg_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	[2-1:0]	RegDst_o, MemtoReg_o;
output			Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire	[2-1:0]	RegDst_o, MemtoReg_o;
wire			Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o;

//Main function
/*your code here*/
localparam R_TYPE = 6'b000000;
localparam LW = 6'b100001;
localparam SW = 6'b100011;
localparam BEQ = 6'b111011;
localparam BNE = 6'b100101;
localparam JUMP = 6'b100010;
localparam ADDI = 6'b001000;
localparam LUI = 6'b110111;

assign RegWrite_o = (instr_op_i == R_TYPE || instr_op_i == ADDI || instr_op_i == LUI || instr_op_i == LW)?1:0;
assign ALUOp_o = (instr_op_i == R_TYPE)?3'b010:
                 (instr_op_i == ADDI)?3'b011:
                 (instr_op_i == LUI)?3'b101:
                 (instr_op_i == BEQ)?3'b001:
                 (instr_op_i == BNE)?3'b110:
                 (instr_op_i == LW || instr_op_i == SW)?3'b000:3'bzzz;
assign ALUSrc_o = (instr_op_i == R_TYPE || instr_op_i == BEQ || instr_op_i == BNE)?0:
                  (instr_op_i == ADDI || instr_op_i == LUI || instr_op_i == LW || instr_op_i == SW)?1:1'bz;
assign RegDst_o = (instr_op_i == R_TYPE)?2'b01:
                  (instr_op_i == ADDI || instr_op_i == LUI || instr_op_i == LW)?2'b00:2'bzz;
assign Jump_o = (instr_op_i == JUMP)?1:0;
assign Branch_o = (instr_op_i == BEQ || instr_op_i == BNE)?1:0;
assign BranchType_o = (instr_op_i == BEQ)?0:
                      (instr_op_i == BNE)?1:1'bz;
assign MemWrite_o = (instr_op_i == SW)?1:0;
assign MemRead_o = (instr_op_i == LW)?1:0;
assign MemtoReg_o = (instr_op_i == LW)?2'b01:
                    (instr_op_i == R_TYPE || instr_op_i == ADDI || instr_op_i == LUI)?2'b00:2'bzz;

endmodule
   