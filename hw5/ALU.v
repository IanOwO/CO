module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
/*your code here*/
wire carryIn[32:0];
  wire set;
  wire [31:0] ans;


  // and check_carryIn(carryIn[0],invertB,1);
  assign carryIn[0] = (ALU_operation_i[2])?1:0;
  ALU_1bit alu0(.result(result[0]),
                .carryOut(carryIn[1]),
                .a(aluSrc1[0]),
                .b(aluSrc2[0]),
                .invertA(ALU_operation_i[3]),
                .invertB(ALU_operation_i[2]),
                .operation(ALU_operation_i[1:0]),
                .carryIn(carryIn[0]),
                .less(set));
    
  generate
    genvar j;
    for(j = 1;j < 31;j = j + 1) begin
      ALU_1bit alu_else(.result(result[j]),
                .carryOut(carryIn[j + 1]),
                .a(aluSrc1[j]),
                .b(aluSrc2[j]),
                .invertA(ALU_operation_i[3]),
                .invertB(ALU_operation_i[2]),
                .operation(ALU_operation_i[1:0]),
                .carryIn(carryIn[j]),
                .less(0));
    end
  endgenerate

  ALU_for_31 alu31(.result(result[31]),
                .carryOut(carryIn[32]),
                .set(set),
                .overflow(overflow),
                .a(aluSrc1[31]),
                .b(aluSrc2[31]),
                .invertA(ALU_operation_i[3]),
                .invertB(ALU_operation_i[2]),
                .operation(ALU_operation_i[1:0]),
                .carryIn(carryIn[31]),
                .less(0));

  assign zero = (result)?0:1;

endmodule
