module Control (
    input            CLK,
    input            RESET,
    input  [6:0]     opcode,
    output reg       PCWriteCond,
    output reg       PCWrite,
    output reg       IorD,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemtoReg,
    output reg       IRWrite,
    output reg       PCSource,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcB,
    output reg       ALUSrcA,
    output reg       RegWrite
);
    /*
     * Actions of the 1-bit control signals
     * ---------------------------------------------------------------------------------------------------------------
     *  Signal name | Effect when deasserted               | Effect when asserted
     * -------------|--------------------------------------|----------------------------------------------------------
     *  RegWrite    | None                                 | The GPR selected by the Write register number is written
     *              |                                      | with the value of the Write data input
     * -------------|--------------------------------------|----------------------------------------------------------
     *  ALUSrcA     | The first ALU operand is the PC      | The first ALU operand comes from the A register
     * -------------|--------------------------------------|----------------------------------------------------------
     *  MemRead     | None                                 | Content of memory at the location specified by the
     *              |                                      | Address input is put on Memory data output
     * -------------|--------------------------------------|----------------------------------------------------------
     *  MemWrite    | None                                 | Memory contents at the location specified by the Address
     *              |                                      | input is replaced by the value on the Write data input
     * -------------|--------------------------------------|----------------------------------------------------------
     *  MemtoReg    | The value fed to the register file   | The value fed to the register file Write data input
     *              | Write data input comes from ALUOut   | comes from the MDR
     * -------------|--------------------------------------|----------------------------------------------------------
     *  IorD        | The PC is used to supply the address | ALUOut is used to supply the address to the memory unit
     *              | to the memory unit                   |
     * -------------|--------------------------------------|----------------------------------------------------------
     *  IRWrite     | None                                 | The output of the memory is written into the IR
     * -------------|--------------------------------------|----------------------------------------------------------
     *  PCWrite     | None                                 | The PC is written; the source is controlled by PCSource
     * -------------|--------------------------------------|----------------------------------------------------------
     *  PCWriteCond | None                                 | The PC is written if the Zero output from the ALU is
     *              |                                      | also active
     * -------------|--------------------------------------|----------------------------------------------------------
     *  PCSource    | Output of the ALU (PC + 4) is sent   | The contents of ALUOut (the branch target address) are
     *              | to the PC for writing                | sent to the PC for writing
     * ---------------------------------------------------------------------------------------------------------------
    */

    /*
     * Actions of the 2-bit control signals
     * ---------------------------------------------------------------------------------------------------------
     *  Signal name | Value (binary) | Effect
     * -------------|----------------|--------------------------------------------------------------------------
     *  ALUOp       |       00       | The ALU performs an add operation
     *              |       01       | The ALU performs a subtract operation
     *              |       10       | The funct field of the instruction determines the ALU operation
     * -------------|----------------|--------------------------------------------------------------------------
     *  ALUSrcB     |       00       | The second input to the ALU comes frome the B register
     *              |       01       | The second input to the ALU is the constant 4
     *              |       10       | The second input to the ALU is the immediate value generated from the IR
     * ---------------------------------------------------------------------------------------------------------
    */

    localparam [6:0] OP_RTYPE = 7'b0110011;  // add, sub, and, or, slt
    localparam [6:0] OP_ITYPE = 7'b0010011;  // addi, andi, ori, slti
    localparam [6:0] OP_LW    = 7'b0000011;  // lw
    localparam [6:0] OP_SW    = 7'b0100011;  // sw
    localparam [6:0] OP_BEQ   = 7'b1100011;  // beq

    // States
    localparam [3:0] IF       = 4'b0000;     // Instruction fetch
    localparam [3:0] ID       = 4'b0001;     // Instruction decode/register fetch
    localparam [3:0] EXE_LS   = 4'b0010;     // Memory address computation
    localparam [3:0] MEMREAD  = 4'b0011;     // Memory access (lw)
    localparam [3:0] WB_LW    = 4'b0100;     // Memory read completion step
    localparam [3:0] MEMWRITE = 4'b0101;     // Memory access (sw)
    localparam [3:0] EXE_R    = 4'b0110;     // Execution (R-type)
    localparam [3:0] EXE_I    = 4'b0111;     // Execution (I-type)
    localparam [3:0] WB_RI    = 4'b1000;     // R, I-type completion
    localparam [3:0] EXE_B    = 4'b1001;     // Branch completion

    reg [3:0] state, nextstate;

    // State register
    always @(posedge CLK, negedge RESET) begin
        if (!RESET) state <= IF;
        else        state <= nextstate;
    end

    // Next state logic
    always @(*) begin
        /* verilator lint_off CASEINCOMPLETE */
        case (state)
            IF:       nextstate = ID;
            ID:
                /* verilator lint_off CASEINCOMPLETE */
                case (opcode)
                    OP_LW, OP_SW: nextstate = EXE_LS;
                    OP_RTYPE:     nextstate = EXE_R;
                    OP_ITYPE:     nextstate = EXE_I;
                    OP_BEQ:       nextstate = EXE_B;
                endcase
            EXE_LS:
                if (opcode == OP_LW) nextstate = MEMREAD;
                else                 nextstate = MEMWRITE;
            MEMREAD:  nextstate = WB_LW;
            WB_LW:    nextstate = IF;
            MEMWRITE: nextstate = IF;
            EXE_R:    nextstate = WB_RI;
            EXE_I:    nextstate = WB_RI;
            WB_RI:    nextstate = IF;
            EXE_B:    nextstate = IF;
        endcase
    end

    // Output logic
    always @(*) begin
        PCWriteCond = 1'b0; PCWrite = 1'b0; MemRead  = 1'b0; 
        MemWrite    = 1'b0; IRWrite = 1'b0; RegWrite = 1'b0;
        /* verilator lint_off CASEINCOMPLETE */
        case (state)
            IF: begin
                MemRead = 1'b1;
                ALUSrcA = 1'b0;
                IorD = 1'b0;
                IRWrite = 1'b1;
                ALUSrcB = 2'b01;
                ALUOp = 2'b00;
                PCWrite = 1'b1;
                PCSource = 1'b0;
            end
            ID:        begin  ALUSrcA = 1'b0; ALUSrcB = 2'b10; ALUOp = 2'b00;  end
            EXE_LS:    begin  ALUSrcA = 1'b1; ALUSrcB = 2'b10; ALUOp = 2'b00;  end
            MEMREAD:   begin  MemRead = 1'b1; IorD = 1'b1;  end
            WB_LW:     begin  RegWrite = 1'b1; MemtoReg = 1'b1;  end
            MEMWRITE:  begin  MemWrite = 1'b1; IorD = 1'b1;  end
            EXE_R:     begin  ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 2'b10;  end
            EXE_I:     begin  ALUSrcA = 1'b1; ALUSrcB = 2'b10; ALUOp = 2'b11;  end
            WB_RI:     begin  RegWrite = 1'b1; MemtoReg = 1'b0;  end
            EXE_B: begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b00;
                ALUOp = 2'b01;
                PCWriteCond = 1'b1;
                PCSource = 1'b1;
            end
        endcase
    end

endmodule
