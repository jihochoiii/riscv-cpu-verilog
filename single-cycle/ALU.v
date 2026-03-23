module ALU (
    input              [3:0] ALUCtrl,
    input      signed [31:0] A,
    input      signed [31:0] B,
    output reg signed [31:0] ALUResult,
    output                   Zero,
    output                   Sign,
    output                   Overflow,
    output                   Borrow
);
    // ALU performs operations based on a 4-bit ALUCtrl signal

    wire [32:0] sub_unsigned = {1'b0, A} - {1'b0, B};

    always @(*) begin
        case (ALUCtrl)
            4'b0000: ALUResult = A & B;            // AND
            4'b0001: ALUResult = A | B;            // OR
            4'b0100: ALUResult = A ^ B;            // XOR
            4'b0010: ALUResult = A + B;            // add
            4'b0110: ALUResult = A - B;            // subtract
            4'b1000: ALUResult = A << B[4:0];      // shift left logical
            4'b1001: ALUResult = A >> B[4:0];      // shift right logical
            4'b1010: ALUResult = A >>> B[4:0];     // shift right arithmetic
            4'b0111: ALUResult = (A < B) ? 1 : 0;  // set on less than
            4'b0011: ALUResult = Borrow ? 1 : 0;   // set on less than unsigned
            default: ALUResult = 32'b0;
        endcase
    end

    // Flags for branch instructions
    assign Zero = (ALUResult == 32'b0);
    assign Sign = ALUResult[31];
    assign Overflow = (A[31] != B[31]) & (ALUResult[31] != A[31]);
    assign Borrow = sub_unsigned[32];

endmodule
