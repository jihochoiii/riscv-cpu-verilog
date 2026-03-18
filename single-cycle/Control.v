module Control (
    input  [6:0] opcode,
    output       Branch,
    output       MemRead,
    output       MemtoReg,
    output [1:0] ALUOp,
    output       MemWrite,
    output       ALUSrc,
    output       RegWrite
);

    localparam [6:0] OP_RTYPE = 7'b0110011;  // add, sub, and, or, slt
    localparam [6:0] OP_ITYPE = 7'b0010011;  // addi, andi, ori, slti
    localparam [6:0] OP_LW    = 7'b0000011;  // lw
    localparam [6:0] OP_SW    = 7'b0100011;  // sw
    localparam [6:0] OP_BEQ   = 7'b1100011;  // beq

    assign Branch   = (opcode == OP_BEQ);

    assign MemRead  = (opcode == OP_LW);

    assign MemtoReg = (opcode == OP_LW);
    
    assign ALUOp    = (opcode == OP_LW) || (opcode == OP_SW) ? 2'b00 :
                      (opcode == OP_BEQ)                     ? 2'b01 :
                      (opcode == OP_RTYPE)                   ? 2'b10 :
                                                               2'b11;
    
    assign MemWrite = (opcode == OP_SW);

    assign ALUSrc   = (opcode == OP_ITYPE) | (opcode == OP_LW) | (opcode == OP_SW);

    assign RegWrite = (opcode == OP_RTYPE) | (opcode == OP_ITYPE) | (opcode == OP_LW);

endmodule
