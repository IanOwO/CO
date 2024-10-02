module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
localparam R_TYPE = 3'b010;
localparam ADDI = 3'b011;
localparam LUI = 3'b101;
localparam LW_SW = 3'b000;
localparam BEQ = 3'b001;
localparam BNE = 3'b110;

assign ALU_operation_o = (ALUOp_i == LW_SW)?4'b0010: // lw, sw
                         (ALUOp_i == BEQ || ALUOp_i == BNE)?4'b0110: // beq
                         (ALUOp_i == LUI)?4'b0001: // lui
                         (ALUOp_i == ADDI)?4'b0010: // addi
                         (ALUOp_i == R_TYPE)?(funct_i == 6'b010010)?4'b0010: // add
                                                 (funct_i == 6'b010000)?4'b0110: // sub
                                                 (funct_i == 6'b010100)?4'b0001: // and
                                                 (funct_i == 6'b010110)?4'b0000: // or
                                                 (funct_i == 6'b010101)?4'b1101: // nor
                                                 (funct_i == 6'b100000)?4'b0111: // slt
                                                 (funct_i == 6'b000000)?4'bxxx1: // sll
                                                 (funct_i == 6'b000010)?4'bxxx0: // srl
                                                                        4'bzzzz: // error funct
                                                                        4'bzzzz; // jump

assign FURslt_o = (ALUOp_i == ADDI)?2'b00: // addi
                  (ALUOp_i == R_TYPE && funct_i == 6'b010010)?2'b00: // add
                  (ALUOp_i == R_TYPE && funct_i == 6'b010000)?2'b00: // sub
                  (ALUOp_i == R_TYPE && funct_i == 6'b010100)?2'b00: // and
                  (ALUOp_i == R_TYPE && funct_i == 6'b010110)?2'b00: // or
                  (ALUOp_i == R_TYPE && funct_i == 6'b010101)?2'b00: // nor
                  (ALUOp_i == R_TYPE && funct_i == 6'b100000)?2'b00: // slt
                  (ALUOp_i == R_TYPE && funct_i == 6'b000000)?2'b01: // sll
                  (ALUOp_i == R_TYPE && funct_i == 6'b000010)?2'b01: // srl
                                                              2'b00; // other instr.
endmodule     
