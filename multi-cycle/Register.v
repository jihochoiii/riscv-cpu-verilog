module Register (
    input         CLK,
    input         RESET,
    input         RegWrite,
    input   [4:0] ReadReg1,
    input   [4:0] ReadReg2,
    input   [4:0] WriteReg,
    input  [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

    reg [31:0] regs [0:31];

    assign ReadData1 = regs[ReadReg1];
    assign ReadData2 = regs[ReadReg2];

    always @(negedge CLK, negedge RESET) begin
        if (~RESET) begin
            regs[0] <= 0; regs[2] <= 32'd256;
        end
        else if (RegWrite)
            regs[WriteReg] <= (WriteReg == 0) ? 0 : WriteData;
    end

endmodule
