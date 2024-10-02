module Pipeline_CPU( clk_i, rst_n );

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
wire [32-1:0] PC_add1, PC_add2, DM_ReadData;
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

wire [31:0] pc_IF_ID_o, inst_IF_ID_o; // data out from IF/ID

wire [31:0] pc_ID_EX_o, ReadData1_ID_EX_o, ReadData2_ID_EX_o, signextend_ID_EX_o; // data out from ID/EX
wire [4:0] WBaddr1_ID_EX_o, WBaddr2_ID_EX_o; // data out from ID/EX
wire [2:0] ALUop_ID_EX_o; // data out from ID/EX
wire [1:0] RegDst_ID_EX_o, MemtoReg_ID_EX_o;  // data out from ID/EX
wire RegWrite_ID_EX_o, ALUSrc_ID_EX_o, Branch_ID_EX_o; // data out from ID/EX
wire BranchType_ID_EX_o, MemWrite_ID_EX_o, MemRead_ID_EX_o; // data out from ID/EX

wire [31:0] pc_cal; // wire in EX
wire [4:0] WBaddr; // wire in EX
wire [31:0] pc_cal_EX_ME_o, ALUResult_EX_ME_o, ReadData2_EX_ME_o; // data out from EX/ME
wire [4:0] WBaddr_EX_ME_o; // data out from EX/ME
wire [1:0] MemtoReg_EX_ME_o; // data out from EX/ME
wire RegWrite_EX_ME_o, zero_EX_ME_o, Branch_EX_ME_o; // data out from EX/ME
wire BranchType_EX_ME_o, MemWrite_EX_ME_o, MemRead_EX_ME_o; // data out from EX/ME

wire [31:0] DM_ReadData_ME_WB_o, ALUResult_ME_WB_o; // data out from ME/WB
wire [4:0] WBaddr_ME_WB_o; // data out from ME/WB
wire [1:0] MemtoReg_ME_WB_o; // data out from ME/WB
wire RegWrite_ME_WB_o; // data out from ME/WB


// IF stage
Mux2to1 #(.size(32)) ChoosePC(
        .data0_i(pc_add4),
        .data1_i(pc_cal_EX_ME_o),
        .select_i(PC_srcs),
        .data_o(PC_i)
        );

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

Instr_Memory IM(
        .pc_addr_i(PC_o),  
	    .instr_o(instr)    
	    );

pipeline_reg IF_ID(
        .clk_i(clk_i), .rst_n(rst_n),  
        .pc_i(pc_add4), .pc_o(pc_IF_ID_o),
        .data1_i(instr), .data1_o(inst_IF_ID_o),
        .data2_i(), .data2_o(),
        .data3_i(), .data3_o(),
        .addr1_i(), .addr1_o(),
        .addr2_i(), .addr2_o(),
        .RegWrite_i(), .RegWrite_o(),
        .ALUop_i(), .ALUop_o(),
        .ALUSrc_i(), .ALUSrc_o(),
        .RegDst_i(), .RegDst_o(),
        .MemtoReg_i(), .MemtoReg_o(),
        .Branch_i(), .Branch_o(),
        .BranchType_i(), .BranchType_o(),
        .MemWrite_i(), .MemWrite_o(),
        .MemRead_i(), .MemRead_o()
        );

// ID stage		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(inst_IF_ID_o[25:21]) ,  
        .RTaddr_i(inst_IF_ID_o[20:16]) ,  
        .Wrtaddr_i(WBaddr_ME_WB_o) ,  
        .Wrtdata_i(WriteData)  , 
        .RegWrite_i(RegWrite_ME_WB_o),
        .RSdata_o(ReadData1) ,  
        .RTdata_o(ReadData2)   
        );
	
Decoder Decoder(
        .instr_op_i(inst_IF_ID_o[31:26]), 
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
	
Sign_Extend SE(
        .data_i(inst_IF_ID_o[15:0]),
        .data_o(signextend)
        );

Zero_Filled ZF(
        .data_i(),
        .data_o()
        );

pipeline_reg ID_EX(
        .clk_i(clk_i), .rst_n(rst_n),  
        .pc_i(pc_IF_ID_o), .pc_o(pc_ID_EX_o),
        .data1_i(ReadData1), .data1_o(ReadData1_ID_EX_o),
        .data2_i(ReadData2), .data2_o(ReadData2_ID_EX_o),
        .data3_i(signextend), .data3_o(signextend_ID_EX_o),
        .addr1_i(inst_IF_ID_o[20:16]), .addr1_o(WBaddr1_ID_EX_o),
        .addr2_i(inst_IF_ID_o[15:11]), .addr2_o(WBaddr2_ID_EX_o),
        .RegWrite_i(RegWrite && inst_IF_ID_o), .RegWrite_o(RegWrite_ID_EX_o),
        .ALUop_i(ALUOP), .ALUop_o(ALUop_ID_EX_o),
        .ALUSrc_i(ALUSrc), .ALUSrc_o(ALUSrc_ID_EX_o),
        .RegDst_i(RegDst), .RegDst_o(RegDst_ID_EX_o),
        .MemtoReg_i(MemtoReg), .MemtoReg_o(MemtoReg_ID_EX_o),
        .Branch_i(Branch), .Branch_o(Branch_ID_EX_o),
        .BranchType_i(BranchType), .BranchType_o(BranchType_ID_EX_o),
        .MemWrite_i(MemWrite), .MemWrite_o(MemWrite_ID_EX_o),
        .MemRead_i(MemRead), .MemRead_o(MemRead_ID_EX_o)
        );

// EX stage
Adder Calculate_Branch_Address(
        .src1_i(pc_ID_EX_o),
        .src2_i({signextend_ID_EX_o[29:0],2'b00}),
        .sum_o(pc_cal)
        );       

Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(ReadData2_ID_EX_o),
        .data1_i(signextend_ID_EX_o),
        .select_i(ALUSrc_ID_EX_o),
        .data_o(ALUinput2)
        );	

ALU_Ctrl AC(
        .funct_i(signextend_ID_EX_o[5:0]),   
        .ALUOp_i(ALUop_ID_EX_o),   
        .ALU_operation_o(ALU_operation),
	.FURslt_o(FURslt)
        );

ALU ALU(
	.aluSrc1(ReadData1_ID_EX_o),
	.aluSrc2(ALUinput2),
	.ALU_operation_i(ALU_operation),
	.result(ALUResult),
	.zero(zero),
	.overflow(overflow)
	);	

Mux2to1 #(.size(5)) Write_Back_Address(
        .data0_i(WBaddr1_ID_EX_o),
        .data1_i(WBaddr2_ID_EX_o),
        .select_i(RegDst_ID_EX_o[0]),
        .data_o(WBaddr)
        );

pipeline_reg EX_ME(
        .clk_i(clk_i), .rst_n(rst_n),  
        .pc_i(pc_cal), .pc_o(pc_cal_EX_ME_o),
        .data1_i(ALUResult), .data1_o(ALUResult_EX_ME_o),
        .data2_i(ReadData2_ID_EX_o), .data2_o(ReadData2_EX_ME_o),
        .data3_i(), .data3_o(),
        .addr1_i(WBaddr), .addr1_o(WBaddr_EX_ME_o),
        .addr2_i(), .addr2_o(),
        .RegWrite_i(RegWrite_ID_EX_o), .RegWrite_o(RegWrite_EX_ME_o),
        .ALUop_i(), .ALUop_o(),
        .ALUSrc_i(zero), .ALUSrc_o(zero_EX_ME_o),
        .RegDst_i(), .RegDst_o(),
        .MemtoReg_i(MemtoReg_ID_EX_o), .MemtoReg_o(MemtoReg_EX_ME_o),
        .Branch_i(Branch_ID_EX_o), .Branch_o(Branch_EX_ME_o),
        .BranchType_i(BranchType_ID_EX_o), .BranchType_o(BranchType_EX_ME_o),
        .MemWrite_i(MemWrite_ID_EX_o), .MemWrite_o(MemWrite_EX_ME_o),
        .MemRead_i(MemRead_ID_EX_o), .MemRead_o(MemRead_EX_ME_o)
        );

// MEM stage
and(PC_srcs, Branch_EX_ME_o, zero_EX_ME_o);		

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(ALUResult_EX_ME_o),
        .data_i(ReadData2_EX_ME_o),
        .MemRead_i(MemRead_EX_ME_o),
        .MemWrite_i(MemWrite_EX_ME_o),
        .data_o(DM_ReadData)
        );

pipeline_reg ME_WB(
        .clk_i(clk_i), .rst_n(rst_n),  
        .pc_i(), .pc_o(),
        .data1_i(DM_ReadData), .data1_o(DM_ReadData_ME_WB_o),
        .data2_i(ALUResult_EX_ME_o), .data2_o(ALUResult_ME_WB_o),
        .data3_i(), .data3_o(),
        .addr1_i(WBaddr_EX_ME_o), .addr1_o(WBaddr_ME_WB_o),
        .addr2_i(), .addr2_o(),
        .RegWrite_i(RegWrite_EX_ME_o), .RegWrite_o(RegWrite_ME_WB_o),
        .ALUop_i(), .ALUop_o(),
        .ALUSrc_i(), .ALUSrc_o(),
        .RegDst_i(), .RegDst_o(),
        .MemtoReg_i(MemtoReg_EX_ME_o), .MemtoReg_o(MemtoReg_ME_WB_o),
        .Branch_i(), .Branch_o(),
        .BranchType_i(), .BranchType_o(),
        .MemWrite_i(), .MemWrite_o(),
        .MemRead_i(), .MemRead_o()
        );

// WB stage
Mux2to1 #(.size(32)) Result_Choose(
        .data0_i(ALUResult_ME_WB_o),
        .data1_i(DM_ReadData_ME_WB_o),
        .select_i(MemtoReg_ME_WB_o[0]),
        .data_o(WriteData)
        );

endmodule


