module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  
  /*your code here*/
  // less still need modification
  wire carryIn[32:0];
  wire set;
  wire [31:0] ans;

  // and check_carryIn(carryIn[0],invertB,1);
  assign carryIn[0] = (invertB)?1:0;
  ALU_1bit alu0(.result(result[0]),
                .carryOut(carryIn[1]),
                .a(aluSrc1[0]),
                .b(aluSrc2[0]),
                .invertA(invertA),
                .invertB(invertB),
                .operation(operation),
                .carryIn(carryIn[0]),
                .less(set));
    
  generate
    genvar j;
    for(j = 1;j < 31;j = j + 1) begin
      ALU_1bit alu_else(.result(result[j]),
                .carryOut(carryIn[j + 1]),
                .a(aluSrc1[j]),
                .b(aluSrc2[j]),
                .invertA(invertA),
                .invertB(invertB),
                .operation(operation),
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
                .invertA(invertA),
                .invertB(invertB),
                .operation(operation),
                .carryIn(carryIn[31]),
                .less(0));

  assign zero = (result)?0:1;

	  
endmodule