###  I/O addresses reference
###  0x000007f0  7-segment LED output
###  0x000007f4  SW[1:0] input
###  0x000007f8  SW[2] input

.data
pattern: .word 0x00200000,0x00004000,0x00000080,0x00000001,0x00000002,0x00000004,0x00000008,0x00000400,0x00020000,0x01000000,0x02000000,0x04000000
loopcnt: .word 0x0007a121,0x000f4242,0x001e8484,0x003d0908

.text
    addi    t5, x0, 48
    addi    s1, x0, 1
    addi    s2, x0, 2
    addi    s3, x0, 3

restart_fw:
    addi    t4, x0, 0

forward:
    beq     t4, t5, restart_fw
    lw      t0, 0(t4)
    sw      t0, 0x7f0(x0)
    addi    t2, x0, 0

    lw      t6, 0x7f8(x0)
    beq     t6, s1, backward
    addi    t4, t4, 4
    j       speed

backward:
    beq     t4, x0, restart_bw
    addi    t4, t4, -4
    j       speed

restart_bw:
    addi    t4, x0, 44

speed:
    lw      t6, 0x7f4(x0)
    addi    t1, x0, 0
    beq     t6, x0, jump
    addi    t1, t1, 4
    beq     t6, s1, jump
    addi    t1, t1, 4
    beq     t6, s2, jump
    addi    t1, t1, 4
    beq     t6, s3, jump

jump:
    lw      t3, 48(t1)

wait:
    beq     t2, t3, forward
    addi    t2, t2, 1
    j       wait
