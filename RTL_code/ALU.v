`timescale 1ns / 1ps

module ALU(
    input [3:0] ALU_ctr,
    input [31:0] A, B,
    output reg [31:0] Result,
    output zero
);

always @ (*)
begin 
    case(ALU_ctr)
    4'b0000:  Result = A & B;
    4'b0001:  Result = A | B;
    4'b0010:  Result = A + B;
    4'b0110:  Result = A - B;
    4'b0111:  Result = (A < B) ? 32'd1 : 32'd0 ;
    4'b1100:  Result = ~(A | B);
    default: Result = 32'd0;
    endcase 
end 
assign zero = (Result == 0);
endmodule
