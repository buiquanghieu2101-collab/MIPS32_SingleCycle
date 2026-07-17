`timescale 1ns / 1ps

module registers_file(
    input clk,
    input rst,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    
    input [31:0] WriteData,
    input RegWrite,
    
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

reg [31:0] regs [31:0];
integer i;

always @ (posedge clk or posedge rst)   begin
    if(rst) begin
      for( i = 0; i < 32; i = i + 1)
       regs[i] <= 32'd0;
    end
    else if(RegWrite && ( rd != 5'd0)) begin
        regs[rd] <= WriteData;
    end
end 

assign ReadData1 = (rs == 5'd0) ? 32'd0 : regs[rs];
assign ReadData2 = (rt == 5'd0) ? 32'd0 : regs[rt];

endmodule
