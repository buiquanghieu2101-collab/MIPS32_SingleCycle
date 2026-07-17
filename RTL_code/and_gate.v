`timescale 1ns / 1ps

module and_gate(
    input  wire Branch,
    input  wire Zero,

    output wire PCSrc
);

assign PCSrc = Branch & Zero;

endmodule