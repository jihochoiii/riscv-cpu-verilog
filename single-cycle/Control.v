module Control (
    input  [6:0] opcode,
    output       Jump,
    output       Branch,
    output       MemRead,
    output       MemtoReg,
    output [1:0] ALUOp,
    output       MemWrite,
    output [1:0] ALUSrcA,
    output       ALUSrcB,
    output       RegWrite
);

    localparam [6:0] OP_RTYPE = 7'b0110011;  // add, sub, sll, slt, sltu, xor, srl, sra, or, and
    localparam [6:0] OP_ITYPE = 7'b0010011;  // addi, slti, sltiu, xori, ori, andi, slli, srli, srai
    localparam [6:0] OP_LW    = 7'b0000011;  // lw
    localparam [6:0] OP_SW    = 7'b0100011;  // sw
    localparam [6:0] OP_BTYPE = 7'b1100011;  // beq, bne, blt, bge, bltu, bgeu
    localparam [6:0] OP_JAL   = 7'b1101111;  // jal
    localparam [6:0] OP_JALR  = 7'b1100111;  // jalr
    localparam [6:0] OP_LUI   = 7'b0110111;  // lui
    localparam [6:0] OP_AUIPC = 7'b0010111;  // auipc

    assign Jump     = (opcode == OP_JAL) | (opcode == OP_JALR);

    assign Branch   = (opcode == OP_BTYPE);

    assign MemRead  = (opcode == OP_LW);

    assign MemtoReg = (opcode == OP_LW);
    
    assign ALUOp    = (opcode == OP_LW) || (opcode == OP_SW) || (opcode == OP_LUI) || (opcode == OP_AUIPC) ? 2'b00 :
                      (opcode == OP_BTYPE)                                                                 ? 2'b01 :
                      (opcode == OP_RTYPE)                                                                 ? 2'b10 :
                                                                                                             2'b11;

    assign MemWrite = (opcode == OP_SW);

    assign ALUSrcA = (opcode == OP_LUI)   ? 2'b00 :
                     (opcode == OP_AUIPC) ? 2'b01 :
                                            2'b10;

    assign ALUSrcB  = (opcode == OP_ITYPE) | (opcode == OP_LW) | (opcode == OP_SW)
                    | (opcode == OP_LUI) | (opcode == OP_AUIPC);

    assign RegWrite = (opcode == OP_RTYPE) | (opcode == OP_ITYPE) | (opcode == OP_LW)
                    | (opcode == OP_JAL) | (opcode == OP_JALR) | (opcode == OP_LUI) | (opcode == OP_AUIPC);

endmodule
