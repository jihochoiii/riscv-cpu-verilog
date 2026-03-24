module EX_MEM (
    input             CLK,
    input             RESET,
    input             MemRead_i,
    input             MemtoReg_i,
    input             MemWrite_i,
    input             RegWrite_i,
    input      [31:0] ALUResult_i,
    input      [31:0] RegReadData2_i,
    input       [4:0] WriteReg_i,
    output reg        MemRead_o,
    output reg        MemtoReg_o,
    output reg        MemWrite_o,
    output reg        RegWrite_o,
    output reg [31:0] ALUResult_o,
    output reg [31:0] RegReadData2_o,
    output reg  [4:0] WriteReg_o
);

    wire [72:0] EX_MEM_i = {MemRead_i, MemtoReg_i, MemWrite_i, RegWrite_i, ALUResult_i, RegReadData2_i, WriteReg_i};

    always @(posedge CLK, negedge RESET) begin
        if (!RESET) {MemRead_o, MemtoReg_o, MemWrite_o, RegWrite_o, ALUResult_o, RegReadData2_o, WriteReg_o} <= 0;
        else        {MemRead_o, MemtoReg_o, MemWrite_o, RegWrite_o, ALUResult_o, RegReadData2_o, WriteReg_o} <= EX_MEM_i;
    end

endmodule
