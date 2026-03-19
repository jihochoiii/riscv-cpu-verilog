`timescale 1ns / 1ps

module ALU (
    input              [3:0] ALUCtrl,
    input      signed [31:0] A,
    input      signed [31:0] B,
    output reg signed [31:0] ALUResult,
    output                   Zero,
    output                   Sign,
    output                   Overflow
);
    // ALU performs operations based on a 4-bit ALUCtrl signal
    // The Zero detection output is used to support branch instructions like beq

    always @(*) begin
        case (ALUCtrl)
            4'b0000: ALUResult = A & B;            // AND
            4'b0001: ALUResult = A | B;            // OR
            4'b0010: ALUResult = A + B;            // add
            4'b0110: ALUResult = A - B;            // subtract
            4'b0111: ALUResult = (A < B) ? 1 : 0;  // set-on-less-than
            default: ALUResult = 32'b0;
        endcase
    end

    // Flags for branch instructions
    assign Zero = (ALUResult == 32'b0);
    assign Sign = ALUResult[31];
    assign Overflow = (A[31] != B[31]) & (ALUResult[31] != A[31]);

endmodule
