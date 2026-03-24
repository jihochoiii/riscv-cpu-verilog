module MEM_WB (
    input             CLK,
    input             RESET,
    input             MemtoReg_i,
    input             RegWrite_i,
    input      [31:0] MemReadData_i,
    input      [31:0] ALUResult_i,
    input       [4:0] WriteReg_i,
    output reg        MemtoReg_o,
    output reg        RegWrite_o,
    output reg [31:0] MemReadData_o,
    output reg [31:0] ALUResult_o,
    output reg  [4:0] WriteReg_o
);

    wire [70:0] MEM_WB_i = {MemtoReg_i, RegWrite_i, MemReadData_i, ALUResult_i, WriteReg_i};

    always @(posedge CLK, negedge RESET) begin
        if (!RESET) {MemtoReg_o, RegWrite_o, MemReadData_o, ALUResult_o, WriteReg_o} <= 0;
        else        {MemtoReg_o, RegWrite_o, MemReadData_o, ALUResult_o, WriteReg_o} <= MEM_WB_i;
    end

endmodule
