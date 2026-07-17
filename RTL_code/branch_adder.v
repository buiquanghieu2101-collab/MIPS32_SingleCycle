`timescale 1ns / 1ps

module branch_adder(
    input  wire [31:0] pc_plus4,
    input  wire [31:0] branch_offset,

    output wire [31:0] branch_addr
);

assign branch_addr = pc_plus4 + branch_offset;

endmodule