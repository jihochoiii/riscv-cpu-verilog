module ALU (
    input              [3:0] ALUCtrl,
    input      signed [31:0] A,
    input      signed [31:0] B,
    output reg signed [31:0] ALUResult
);
    // ALU performs operations based on a 4-bit ALUCtrl signal

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

endmodule
