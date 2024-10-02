module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] instr, PC_i, PC_o, ReadData1, ReadData2, WriteData;
wire [32-1:0] signextend, zerofilled, ALUinput2, ALUResult, ShifterResult;
wire [5-1:0] WriteReg_addr, Shifter_shamt;
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOP;
wire [2-1:0] FURslt;
wire [2-1:0] RegDst, MemtoReg;
wire RegWrite, ALUSrc, zero, overflow;
wire Jump, Branch, BranchType, MemWrite, MemRead;
wire [32-1:0] PC_add1, PC_add2, PC_no_jump, PC_t, Mux3_result, DM_ReadData;
wire Jr;
assign Jr = ((instr[31:26] == 6'b000000) && (instr[20:0] == 21'd8)) ? 1 : 0;
//modules
/*your code here*/
wire [31:0] pc_add4; //next program counter
wire need_branch; // check if need to branch or not;
wire PC_srcs; // PC's source
wire [31:0] value_out_3to1; // value goes out from 3to1 mux
wire [31:0] branch_addr; // branch address
wire [31:0] sum_branch; // address come out from adder

Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(PC_i) ,   
	    .pc_out_o(PC_o) 
	    );
	
Adder Adder1(
        .src1_i(PC_o),     
	    .src2_i(32'd4),
	    .sum_o(pc_add4)    
	    );
// new
Adder Calculate_Branch_Address(
        .src1_i(pc_add4),
        .src2_i({signextend[29:0],2'b00}),
        .sum_o(sum_branch)
        );
// new
Mux2to1 #(.size(32)) Final_PC_Choose(
        .data0_i(pc_add4),
        .data1_i(sum_branch),
        .select_i(PC_srcs),
        .data_o(branch_addr)
        );
// new
Mux2to1 #(.size(32)) Jump_or_not(
        .data0_i(branch_addr),
        .data1_i({pc_add4[31:28],instr[25:0],2'b00}),
        .select_i(Jump),
        .data_o(PC_i)
        );

Instr_Memory IM(
        .pc_addr_i(PC_o),  
	    .instr_o(instr)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst[0]),
        .data_o(WriteReg_addr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(WriteReg_addr) ,  
        .RDdata_i(WriteData)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(ReadData1) ,  
        .RTdata_o(ReadData2)   
        );
// new	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOP),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),
            .Jump_o(Jump),
            .Branch_o(Branch),
            .BranchType_o(BranchType),
            .MemWrite_o(MemWrite),
            .MemRead_o(MemRead),
            .MemtoReg_o(MemtoReg)   
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOP),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(signextend)
        );

Zero_Filled ZF(
        .data_i(),
        .data_o()
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(ReadData2),
        .data1_i(signextend),
        .select_i(ALUSrc),
        .data_o(ALUinput2)
        );	
		
ALU ALU(
		.aluSrc1(ReadData1),
	    .aluSrc2(ALUinput2),
	    .ALU_operation_i(ALU_operation),
		.result(ALUResult),
		.zero(zero),
		.overflow(overflow)
	    );
// new
Mux2to1 #(.size(1)) Branch_Choose(
        .data0_i(zero),
        .data1_i(~zero),
        .select_i(BranchType),
        .data_o(need_branch)
        );	
// new
and(PC_srcs,Branch,need_branch);

Shifter shifter( 
		.result(ShifterResult), 
		.leftRight(ALU_operation[0]),
		.shamt(instr[10:6]),
		.sftSrc(ALUinput2) 
		);
// new		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALUResult),
        .data1_i(ShifterResult),
		.data2_i(),
        .select_i(FURslt),
        .data_o(value_out_3to1)
        );			
// new
Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(value_out_3to1),
        .data_i(ReadData2),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(DM_ReadData)
        );
// new
Mux2to1 #(.size(32)) Result_Choose(
        .data0_i(value_out_3to1),
        .data1_i(DM_ReadData),
        .select_i(MemtoReg[0]),
        .data_o(WriteData)
        );
endmodule


