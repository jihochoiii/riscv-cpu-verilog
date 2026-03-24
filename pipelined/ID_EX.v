module ID_EX (
    input             CLK,
    input             RESET,
    input             MemRead_i,
    input             MemtoReg_i,
    input       [1:0] ALUOp_i,
    input             MemWrite_i,
    input             ALUSrc_i,
    input             RegWrite_i,
    input      [31:0] PC_i,
    input      [31:0] RegReadData1_i,
    input      [31:0] RegReadData2_i,
    input      [31:0] Imm_i,
    input             funct7_i,
    input       [2:0] funct3_i,
    input       [4:0] ID_EX_Rs1_i,
    input       [4:0] ID_EX_Rs2_i,
    input       [4:0] WriteReg_i,
    output reg        MemRead_o,
    output reg        MemtoReg_o,
    output reg  [1:0] ALUOp_o,
    output reg        MemWrite_o,
    output reg        ALUSrc_o,
    output reg        RegWrite_o,
    output reg [31:0] PC_o,
    output reg [31:0] RegReadData1_o,
    output reg [31:0] RegReadData2_o,
    output reg [31:0] Imm_o,
    output reg        funct7_o,
    output reg  [2:0] funct3_o,
    output reg  [4:0] ID_EX_Rs1_o,
    output reg  [4:0] ID_EX_Rs2_o,
    output reg  [4:0] WriteReg_o
);

    wire [153:0] ID_EX_i = {MemRead_i, MemtoReg_i, ALUOp_i, MemWrite_i, ALUSrc_i, RegWrite_i, PC_i, RegReadData1_i, RegReadData2_i, Imm_i, funct7_i, funct3_i, ID_EX_Rs1_i, ID_EX_Rs2_i, WriteReg_i};

    always @(posedge CLK, negedge RESET) begin
        if (!RESET) {MemRead_o, MemtoReg_o, ALUOp_o, MemWrite_o, ALUSrc_o, RegWrite_o, PC_o, RegReadData1_o, RegReadData2_o, Imm_o, funct7_o, funct3_o, ID_EX_Rs1_o, ID_EX_Rs2_o, WriteReg_o} <= 0;
        else        {MemRead_o, MemtoReg_o, ALUOp_o, MemWrite_o, ALUSrc_o, RegWrite_o, PC_o, RegReadData1_o, RegReadData2_o, Imm_o, funct7_o, funct3_o, ID_EX_Rs1_o, ID_EX_Rs2_o, WriteReg_o} <= ID_EX_i;
    end

endmodule
