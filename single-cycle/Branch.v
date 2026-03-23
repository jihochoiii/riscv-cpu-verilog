module Branch (
    input [2:0] funct3,
    input       Zero,
    input       Sign,
    input       Overflow,
    input       Borrow,
    output reg  BrTaken
);

    localparam [2:0] FT_BEQ  = 3'b000;
    localparam [2:0] FT_BNE  = 3'b001;
    localparam [2:0] FT_BLT  = 3'b100;
    localparam [2:0] FT_BGE  = 3'b101;
    localparam [2:0] FT_BLTU = 3'b110;
    localparam [2:0] FT_BGEU = 3'b111;

    always @(*) begin
        case (funct3)
            FT_BEQ:  BrTaken = Zero;
            FT_BNE:  BrTaken = ~Zero;
            FT_BLT:  BrTaken = (Sign != Overflow);
            FT_BGE:  BrTaken = (Sign == Overflow);
            FT_BLTU: BrTaken = Borrow;
            FT_BGEU: BrTaken = ~Borrow;
            default: BrTaken = 1'b0;
        endcase
    end

endmodule
