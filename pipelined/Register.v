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

    assign ReadData1 = (RegWrite && (WriteReg != 0) && (WriteReg == ReadReg1)) ? WriteData : regs[ReadReg1];
    assign ReadData2 = (RegWrite && (WriteReg != 0) && (WriteReg == ReadReg2)) ? WriteData : regs[ReadReg2];

    always @(posedge CLK, negedge RESET) begin
        if (~RESET) begin
            regs[0]  <= 0; regs[1]  <= 0; regs[2]  <= 32'd128; regs[3]  <= 0;
            regs[4]  <= 0; regs[5]  <= 0; regs[6]  <= 0;       regs[7]  <= 0;
            regs[8]  <= 0; regs[9]  <= 0; regs[10] <= 0;       regs[11] <= 0;
            regs[12] <= 0; regs[13] <= 0; regs[14] <= 0;       regs[15] <= 0;
            regs[16] <= 0; regs[17] <= 0; regs[18] <= 0;       regs[19] <= 0;
            regs[20] <= 0; regs[21] <= 0; regs[22] <= 0;       regs[23] <= 0;
            regs[24] <= 0; regs[25] <= 0; regs[26] <= 0;       regs[27] <= 0;
            regs[28] <= 0; regs[29] <= 0; regs[30] <= 0;       regs[31] <= 0;
        end
        else if (RegWrite)
            regs[WriteReg] <= (WriteReg == 0) ? 0 : WriteData;
    end

endmodule
