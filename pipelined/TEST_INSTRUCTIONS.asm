.text

main:
# ---------------------------------------------------------
# 0. Initialization
# ---------------------------------------------------------
    addi    x1, x0, 10       # x1 = 10
    addi    x2, x0, 20       # x2 = 20
    addi    x31, x0, 0       # x31 = 0

# ---------------------------------------------------------
# 1. Write-use data hazards
# ---------------------------------------------------------
    addi    x4, x0, 5        # x4 = 5
    add     x6, x4, x1       # x6 = 15
    sub     x7, x4, x1       # x7 = -5
    or      x8, x4, x1       # x8 = 15

# ---------------------------------------------------------
# 2. Load-use data hazards
# ---------------------------------------------------------
    sw      x2, 4(x0)        # Mem[4] = 20
    lw      x10, 4(x0)       # x10 = 20
    add     x11, x10, x1     # x11 = 30

    sw      x11, 24(x0)      # Mem[24] = 30
    lw      x12, 4(x0)       # x12 = 20
    lw      x13, 4(x12)      # x13 = Mem[24] = 30

# ---------------------------------------------------------
# 3. Branches
# ---------------------------------------------------------
    addi    x14, x0, 3       # Loop counter = x14 = 3

loop1:
    addi    x14, x14, -1     # Decrement counter
    beq     x14, x0, loop_done1
    beq     x0, x0, loop1

loop_done1:
    addi    x14, x0, 3       # Loop counter = x14 = 3

loop2:
    addi    x14, x14, -1     # Decrement counter
    nop
    beq     x14, x0, loop_done2
    beq     x0, x0, loop2

loop_done2:
    sw      x1, 12(x0)       # Mem[12] = 10
    lw      x17, 12(x0)      # x17 = 10
    beq     x17, x1, end_halt
    addi    x31, x31, 4     # Should be flushed

end_halt:
    beq     x0, x0, end_halt
