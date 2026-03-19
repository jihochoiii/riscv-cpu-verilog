`timescale 1ns / 1ps

module InstructionMemory (
    input  [31:0] ReadAddr,
    output [31:0] Inst
);

    reg [31:0] inst_mem [63:0];

    initial begin
        $readmemh("instmem_h.txt", inst_mem);
    end

    assign Inst = inst_mem[ReadAddr[7:2]];

endmodule
