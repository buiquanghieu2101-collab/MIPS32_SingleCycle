`timescale 1ns / 1ps

module data_memory(
    input  wire        clk,
    input  wire        MemRead,
    input  wire        MemWrite,

    input  wire [31:0] addr,
    input  wire [31:0] WriteData,

    output wire [31:0] ReadData
);

reg [31:0] mem [0:255];

// Asynchronous Read
assign ReadData = MemRead ? mem[addr[31:2]] : 32'd0;

// Synchronous Write
always @(posedge clk) begin
    if (MemWrite)
        mem[addr[31:2]] <= WriteData;
end

endmodule