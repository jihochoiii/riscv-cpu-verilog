module InstructionMemory (
    input  [31:0] ReadAddr,
    output [31:0] Inst
);

    reg [31:0] inst_mem [63:0];

    assign Inst = (ReadAddr >= 256) ? 32'b0 : inst_mem[ReadAddr[7:2]];

    initial begin
        $readmemh("TEST_INSTRUCTIONS.txt", inst_mem);
    end

endmodule
