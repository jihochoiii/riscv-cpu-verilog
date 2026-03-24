module PC (
    input             CLK,
    input             RESET,
    input             PCWrite,
    input      [31:0] PCBar,
    output reg [31:0] PC
);

    always @(posedge CLK, negedge RESET) begin
        if      (!RESET)  PC <= 32'b0;
        else if (PCWrite) PC <= PCBar;
    end

endmodule
