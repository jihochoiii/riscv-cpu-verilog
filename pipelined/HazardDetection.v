module HazardDetection (
    input            ID_EX_MemRead,
    input      [4:0] IF_ID_Rs1,
    input      [4:0] IF_ID_Rs2,
    input      [4:0] ID_EX_Rd,
    output reg       Stall,
    output reg       PCWrite,
    output reg       IF_IDWrite
);

    always @(*) begin
        Stall = 1'b0; PCWrite = 1'b1; IF_IDWrite = 1'b1;

        // Hazard detection
        if (ID_EX_MemRead && ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2))) begin
            Stall = 1'b1; PCWrite = 1'b0; IF_IDWrite = 1'b0;
        end
    end

endmodule
