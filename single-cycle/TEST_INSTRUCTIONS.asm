# add, addi, sub, and, andi, or, ori
addi x1, x0, 10       # x1 = 10
addi x2, x0, 20       # x2 = 20
add  x3, x1, x2       # x3 = 30
sub  x4, x2, x1       # x4 = 10
and  x5, x1, x2       # x5 = 10 & 20
andi x6, x1, 5        # x6 = 10 & 5
or   x7, x1, x2       # x7 = 10 | 20
ori  x8, x1, 3        # x8 = 10 | 3

# slt, slti
slt  x9, x1, x2       # x9 = 1
slti x10, x2, 15      # x10 = 0

# sw, lw
addi x11, x0, 100     # x11 = 100
sw   x11, 4(x0)
lw   x12, 4(x0)       # x12 = 100

# beq, bne, blt, bge
beq  x1, x1, L_BNE    # Jump to L_BNE
addi x13, x0, 999

L_BNE:
bne  x1, x2, L_BLT    # Jump to L_BLT
addi x13, x0, 999

L_BLT:
blt  x1, x2, L_BGE    # Jump to L_BGE
addi x13, x0, 999

L_BGE:
bge  x2, x1, L_JAL    # Jump to L_JAL
addi x13, x0, 999

# jal, jalr
L_JAL:
jal  x14, FUNCTION
addi x15, x0, 777
jal  x0, END

FUNCTION:
addi x16, x0, 555
jalr x0, 0(x14)

END:
