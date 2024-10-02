module Sign_Extend( data_i, data_o );

//I/O ports
input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;

//Sign extended
/*your code here*/
wire [15:0] extend_part;
assign extend_part = {16{data_i[15]}};
assign data_o = {extend_part, data_i};


endmodule      
