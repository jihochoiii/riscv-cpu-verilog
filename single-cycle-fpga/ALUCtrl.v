`timescale 1ns / 1ps

module ALUCtrl (
    input      [1:0] ALUOp,
    input            funct7,
    input      [2:0] funct3,
    output reg [3:0] ALUCtrl
);
    /*
     * ALU Control Generation Logic
     * ------------------------------------------------------------------
     *  ALUOp | funct3 | funct7 | ALUCtrl | ALU action       | Used for
     * -------|--------|--------|---------|------------------|-----------
     *  00    |  XXX   |   X    |  0010   | add              | lw, sw
     *  01    |  XXX   |   X    |  0110   | subtract         | beq
     *  10    |  000   |   0    |  0010   | add              | add
     *  11    |  000   |   X    |  0010   | add              | addi
     *  10    |  000   |   1    |  0110   | subtract         | sub
     *  10/11 |  111   |   X    |  0000   | AND              | and, andi
     *  10/11 |  110   |   X    |  0001   | OR               | or, ori
     *  10/11 |  010   |   X    |  0111   | set-on-less-than | slt, slti
     * ------------------------------------------------------------------
    */

    localparam [3:0] ALU_AND = 4'b0000;
    localparam [3:0] ALU_OR  = 4'b0001;
    localparam [3:0] ALU_ADD = 4'b0010;
    localparam [3:0] ALU_SUB = 4'b0110;
    localparam [3:0] ALU_SLT = 4'b0111;
    
    always @(*) begin
        case (ALUOp)
            2'b00: ALUCtrl = ALU_ADD;
            2'b01: ALUCtrl = ALU_SUB;
            2'b10, 2'b11: begin
                case (funct3)
                    3'b000: begin
                        if (ALUOp == 2'b11 || funct7 == 1'b0) ALUCtrl = ALU_ADD;
                        else                                  ALUCtrl = ALU_SUB;
                    end
                    3'b111: ALUCtrl = ALU_AND;
                    3'b110: ALUCtrl = ALU_OR;
                    3'b010: ALUCtrl = ALU_SLT;
                    default: ALUCtrl = 4'bXXXX;
                endcase
            end
            default: ALUCtrl = 4'bXXXX;
        endcase
    end

endmodule
