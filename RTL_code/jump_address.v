`timescale 1ns / 1ps

module jump_address(
    input  wire [31:0] pc_plus4,
    input  wire [25:0] instr_index,

    output wire [31:0] jump_addr
);

assign jump_addr = {pc_plus4[31:28], instr_index, 2'b00};

endmodule