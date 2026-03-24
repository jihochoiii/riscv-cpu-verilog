module IF_ID (
    input             CLK,
    input             RESET,
    input             IFFlush,
    input             IF_IDWrite,
    input      [31:0] PC_i,
    input      [31:0] Inst_i,
    output reg [31:0] PC_o,
    output reg [31:0] Inst_o
);

    wire [63:0] IF_ID_i = {PC_i, Inst_i};

    always @(posedge CLK, negedge RESET) begin
        if      (!RESET || IFFlush) {PC_o, Inst_o} <= 0;
        else if (IF_IDWrite)        {PC_o, Inst_o} <= IF_ID_i;
    end

endmodule
