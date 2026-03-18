module InstructionMemory (
    input  [31:0] ReadAddr,
    output [31:0] Inst
);

    reg [7:0] inst_mem [127:0];
    
    assign Inst = (ReadAddr >= 128) ? 32'b0 :
                                     {inst_mem[ReadAddr], inst_mem[ReadAddr + 1], inst_mem[ReadAddr + 2], inst_mem[ReadAddr + 3]};

    initial begin
        inst_mem[0]  = 8'b0; inst_mem[1]  = 8'b0; inst_mem[2]  = 8'b0; inst_mem[3]  = 8'b0;
        inst_mem[4]  = 8'b0; inst_mem[5]  = 8'b0; inst_mem[6]  = 8'b0; inst_mem[7]  = 8'b0;
        inst_mem[8]  = 8'b0; inst_mem[9]  = 8'b0; inst_mem[10] = 8'b0; inst_mem[11] = 8'b0;
        inst_mem[12] = 8'b0; inst_mem[13] = 8'b0; inst_mem[14] = 8'b0; inst_mem[15] = 8'b0;
        inst_mem[16] = 8'b0; inst_mem[17] = 8'b0; inst_mem[18] = 8'b0; inst_mem[19] = 8'b0;
        inst_mem[20] = 8'b0; inst_mem[21] = 8'b0; inst_mem[22] = 8'b0; inst_mem[23] = 8'b0;
        inst_mem[24] = 8'b0; inst_mem[25] = 8'b0; inst_mem[26] = 8'b0; inst_mem[27] = 8'b0;
        inst_mem[28] = 8'b0; inst_mem[29] = 8'b0; inst_mem[30] = 8'b0; inst_mem[31] = 8'b0;
        $readmemb("TEST_INSTRUCTIONS.txt", inst_mem);
    end

endmodule
