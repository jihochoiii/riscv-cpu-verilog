module DataReg (
    input             CLK,
    input             RESET,
    input             WE,
    input      [31:0] RegDataBar,
    output reg [31:0] RegData
);

    always @(posedge CLK, negedge RESET) begin
        if (!RESET)  RegData <= 32'b0;
        else if (WE) RegData <= RegDataBar;
    end

endmodule
