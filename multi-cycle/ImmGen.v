module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input      [31:0] Inst,
    output reg [31:0] Imm
);

    wire [6:0] opcode = Inst[6:0];

    always @(*) begin
        case (opcode)
            7'b0100011: Imm = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]};                               // sw
            7'b1100011: Imm = {{19{Inst[31]}}, Inst[31], Inst[7], Inst[30:25], Inst[11:8], 1'b0} - 4;  // beq
            default:    Imm = {{20{Inst[31]}}, Inst[31:20]};                                           // addi, andi, ori, slti, lw
        endcase
    end

endmodule
