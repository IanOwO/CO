module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
   wire a_out,b_out;
  xor x1(a_out,a,invertA);
  xor x2(b_out,b,invertB);

  wire AND,OR,ADD;
  and and_out(AND,a_out,b_out);
  or or_out(OR,a_out,b_out);
  Full_adder add_out(.sum(ADD),.carryOut(carryOut),
        .carryIn(carryIn),.input1(a_out),.input2(b_out));
  
  assign result = (operation == 2'b00)?OR:
                  (operation == 2'b01)?AND:
                  (operation == 2'b10)?ADD:
                  (operation == 2'b11)?less:0;
  
endmodule

module ALU_for_31( result, carryOut, overflow, set, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  output wire overflow;
  output wire set;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  wire a_out,b_out;
  xor x1(a_out,a,invertA);
  xor x2(b_out,b,invertB);

  wire AND,OR,ADD;
  and and_out(AND,a_out,b_out);
  or or_out(OR,a_out,b_out);
  Full_adder add_out(.sum(ADD),.carryOut(carryOut),
        .carryIn(carryIn),.input1(a_out),.input2(b_out));

  assign result = (operation == 2'b00)?OR:
                  (operation == 2'b01)?AND:
                  (operation == 2'b10)?ADD:
                  (operation == 2'b11)?less:0;
  assign overflow = carryIn^carryOut;
  assign set = (ADD)?1:0;
  

endmodule