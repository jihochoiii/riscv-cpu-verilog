.text

main:
    # -------------------------------------------------------------------------
    # 1. Initialization
    # -------------------------------------------------------------------------
    # x10 will hold 0
    addi    x10, x0, 0

    # -------------------------------------------------------------------------
    # 2. Arithmetic & Logical
    # -------------------------------------------------------------------------
    # x11 = 0x7FFFFFFF (max positive)
    lui     x11, 0x80000
    addi    x11, x11, -1

    addi    x12, x0, 1       # x12 = 1
    add     x13, x11, x12    # x13 = 0x80000000 (-2,147,483,648)
    sub     x14, x13, x12    # x14 = 0x7FFFFFFF

    auipc   x15, 0           # x15 = PC = 24

    addi    x16, x0, -1      # x16 = 0xFFFFFFFF (-1)
    slti    x17, x16, 1      # x17 = 1 (Signed: -1 < 1)
    sltiu   x18, x16, 1      # x18 = 0 (Unsigned: 0xFFFFFFFF > 1)
    slt     x17, x16, x12    # x17 = 1 (Signed: -1 < 1)
    sltu    x18, x16, x12    # x18 = 0 (Unsigned: 0xFFFFFFFF > 1)

    andi    x19, x16, 15     # x19 = 0xF
    ori     x20, x19, 16     # x20 = 0x1F
    xori    x21, x20, 31     # x21 = 0

    and     x22, x16, x20    # x22 = 0x1F
    or      x23, x21, x22    # x23 = 0x1F
    xor     x24, x23, x22    # x24 = 0

    srai    x25, x13, 1      # x25 = 0xC0000000
    srli    x26, x13, 1      # x26 = 0x40000000
    slli    x27, x12, 4      # x27 = 0x10

    sra     x25, x13, x12    # x25 = 0xC0000000
    srl     x26, x13, x12    # x26 = 0x40000000
    sll     x27, x12, x19    # x27 = 0x8000

    # -------------------------------------------------------------------------
    # 3. Memory
    # -------------------------------------------------------------------------
    lui     x29, 0xABCDE
    addi    x29, x29, 0x7FF  # x29 = 0xABCDE7FF
    sw      x29, -4(sp)
    lw      x30, -4(sp)      # x30 = 0xABCDE7FF

    bne     x29, x30, fail

    # -------------------------------------------------------------------------
    # 4. Control Flow
    # -------------------------------------------------------------------------
    jal     x1, test_jal     # x1 = PC+4

    addi    x5, x0, 1        # x5 = 1
    beq     x5, x5, test_branch
    jal     x0, fail

test_jal:
    addi    x6, x0, 100      # x6 = 100
    jalr    x0, 0(x1)
    jal     x0, fail

    # -------------------------------------------------------------------------
    # 5. Branches
    # -------------------------------------------------------------------------
test_branch:
    addi    x8, x0, 10       # x8 = 10
    addi    x9, x0, 20       # x9 = 20

b1:
    blt     x16, x8, b2      # -1 < 10 (Signed)
    jal     x0, fail
b2:
    bge     x8, x16, b3      # 10 >= -1 (Signed)
    jal     x0, fail
b3:
    bltu    x8, x16, b4      # 10 < 0xFFFFFFFF (Unsigned)
    jal     x0, fail
b4:
    bgeu    x16, x8, pass    # 0xFFFFFFFF >= 10 (Unsigned)
    jal     x0, fail

# -------------------------------------------------------------------------
# 6. Result Verification
# -------------------------------------------------------------------------
pass:
    lui     x10, 0x55555     # x10 = 0x55555000
    jal     x0, end_halt

fail:
    lui     x10, 0xEEEE1     # x10 = 0xEEEE1000

end_halt:
    jal     x0, end_halt
