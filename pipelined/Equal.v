module Equal (
    input  [31:0] A,
    input  [31:0] B,
    output        Equal
);
    // Checks if A == B

    assign Equal = ((A ^ B) == 32'b0);

endmodule
