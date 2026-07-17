`timescale 1ns / 1ps

module instruction_memory(
    input [31:0] addr,
    output [31:0] instruction
);
reg [31:0] rom [0:255];

initial begin
    $readmemb ("program.txt", rom);
end 

assign instruction = rom[addr[31:2]];

endmodule
