`timescale 1ns / 1ps

module Adder (
    input  signed [31:0] A,
    input  signed [31:0] B,
    output signed [31:0] Sum
);
    // Adder computes Sum = A + B
    
    assign Sum = A + B;

endmodule
