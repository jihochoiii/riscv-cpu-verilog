`timescale 1ns / 1ps

module PC (
    input             CLK,
    input             RESET,
    input      [31:0] PCBar,
    output reg [31:0] PC
);

    always @(posedge CLK, posedge RESET) begin
        if (RESET) PC <= 32'b0;
        else       PC <= PCBar;
    end

endmodule
