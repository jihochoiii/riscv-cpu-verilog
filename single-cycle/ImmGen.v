module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input             [31:0] Inst,
    output reg signed [31:0] Imm
);

    wire [6:0] opcode = Inst[6:0];

    always @(*) begin
        case (opcode)
            7'b0100011: Imm = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]};                             // sw
            7'b1100011: Imm = {{19{Inst[31]}}, Inst[31], Inst[7], Inst[30:25], Inst[11:8], 1'b0};    // B-type instructions
            7'b1101111: Imm = {{11{Inst[31]}}, Inst[31], Inst[19:12], Inst[20], Inst[30:21], 1'b0};  // jal
            7'b0110111, 7'b0010111: Imm = {Inst[31:12], 12'b0};                                      // U-type instructions
            default:    Imm = {{20{Inst[31]}}, Inst[31:20]};                                         // else
        endcase
    end

endmodule
