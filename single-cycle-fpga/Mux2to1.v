`timescale 1ns / 1ps

module Mux2to1 #(
    parameter size = 32
)
(
    input             sel,
    input  [size-1:0] s0,
    input  [size-1:0] s1,
    output [size-1:0] out
);

    assign out = sel ? s1 : s0;

endmodule
