module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [31:0] cur_pc; //current program counter
wire [31:0] next_pc; //next program counter

wire [31:0] instr; //instruction
wire [4:0] reg_to_write; //register need to write

wire [31:0] rs; //register soruce 1
wire [31:0] rt; //register source 2
wire [31:0] extend_const; //extend constant/address
wire [31:0] rt_choose; //chosen register source 2

wire [31:0] result_from_alu; //result from alu
wire [31:0] result_from_shift; //result from shifter
wire zero;
wire overflow;
wire [31:0] write_value; //value that need to write into register

wire reg_dst; //register destination, control signal
wire reg_write; //register write, control signal
wire [2:0] alu_op; //alu operation code, control signal
wire alu_source; // alu source, control signal

wire [3:0] alu_func; //control alu function, alu control signal
wire [1:0] fur_slt; //fur slt, alu control signal



//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(next_pc) ,   
	    .pc_out_o(cur_pc) 
	    );
	
Adder Adder1(
        .src1_i(cur_pc),     
	    .src2_i(32'd4),
	    .sum_o(next_pc)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(cur_pc),  
	    .instr_o(instr)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(reg_dst),
        .data_o(reg_to_write)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(reg_to_write) ,  
        .RDdata_i(write_value)  , 
        .RegWrite_i(reg_write),
        .RSdata_o(rs) ,  
        .RTdata_o(rt)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(reg_write), 
	    .ALUOp_o(alu_op),   
	    .ALUSrc_o(alu_source),   
	    .RegDst_o(reg_dst)   
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(alu_op),   
        .ALU_operation_o(alu_func),
		.FURslt_o(fur_slt)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(extend_const)
        );

Zero_Filled ZF(
        .data_i(),
        .data_o()
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(rt),
        .data1_i(extend_const),
        .select_i(alu_source),
        .data_o(rt_choose)
        );	
		
ALU ALU(
		.aluSrc1(rs),
	    .aluSrc2(rt_choose),
	    .ALU_operation_i(alu_func),
		.result(result_from_alu),
		.zero(zero),
		.overflow(overflow)
	    );
		
Shifter shifter( 
		.result(result_from_shift), 
		.leftRight(alu_func[0]),
		.shamt(instr[10:6]),
		.sftSrc(rt_choose) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(result_from_alu),
        .data1_i(result_from_shift),
		.data2_i(),
        .select_i(fur_slt),
        .data_o(write_value)
        );			

endmodule



