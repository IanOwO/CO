module pipeline_reg( 
    input clk_i,
    input rst_n,
    input [31:0] pc_i, output [31:0] pc_o,
    input [31:0] data1_i, output [31:0] data1_o,
    input [31:0] data2_i, output [31:0] data2_o,
    input [31:0] data3_i, output [31:0] data3_o,
    input [4:0] addr1_i, output [4:0] addr1_o,
    input [4:0] addr2_i,output [4:0] addr2_o,
    input RegWrite_i, output RegWrite_o,
    input [2:0] ALUop_i, output [2:0] ALUop_o,
    input ALUSrc_i, output ALUSrc_o,
    input [1:0] RegDst_i, output [1:0] RegDst_o,
    input [1:0] MemtoReg_i, output [1:0] MemtoReg_o,
    input Branch_i, output Branch_o,
    input BranchType_i, output BranchType_o,
    input MemWrite_i, output MemWrite_o,
    input MemRead_i,output MemRead_o
    );
    reg [31:0] pc, data1, data2, data3;
    reg [4:0] addr1, addr2;
    reg [2:0] ALUop;
    reg [1:0] RegDst, MemtoReg;
    reg RegWrite, ALUSrc, Branch, BranchType, MemWrite, MemRead;

    assign pc_o = pc;
    assign data1_o = data1;
    assign data2_o = data2;
    assign data3_o = data3;
    assign addr1_o = addr1;
    assign addr2_o = addr2;
    assign ALUop_o = ALUop;
    assign RegDst_o = RegDst;
    assign MemtoReg_o = MemtoReg;
    assign RegWrite_o = RegWrite;
    assign ALUSrc_o = ALUSrc;
    assign Branch_o = Branch;
    assign BranchType_o = BranchType;
    assign MemWrite_o = MemWrite;
    assign MemRead_o = MemRead;

    always @ (posedge clk_i) begin
        if(~rst_n)begin
            pc <= 0; data1 <= 0; data2 <= 0; data3 <= 0; addr1 <= 0; addr2 <= 0;
            ALUop <= 0; RegDst <= 0; MemtoReg <= 0; RegWrite <= 0; ALUSrc <= 0;
            Branch <= 0; BranchType <= 0; MemWrite <= 0; MemRead <= 0;
        end
        else begin
            pc <= pc_i; data1 <= data1_i; data2 <= data2_i; data3 <= data3_i; addr1 <= addr1_i; addr2 <= addr2_i;
            ALUop <= ALUop_i; RegDst <= RegDst_i; MemtoReg <= MemtoReg_i; RegWrite <= RegWrite_i; ALUSrc <= ALUSrc_i;
            Branch <= Branch_i; BranchType <= BranchType_i; MemWrite <= MemWrite_i; MemRead <= MemRead_i;
        end
    end

endmodule
