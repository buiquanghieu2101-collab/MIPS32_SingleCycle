`timescale 1ns / 1ps

module ALU_control(
    input [5:0] funct,
    input [1:0] ALUOp,
    output reg [3:0] ALU_ctr
);

always @(*) begin
    case (ALUOp)

        2'b00: begin
            // lw, sw, addi
            ALU_ctr = 4'b0010;
        end

        2'b01: begin
            // beq
            ALU_ctr = 4'b0110;
        end

        2'b10: begin
            case (funct)
                6'b100000: ALU_ctr = 4'b0010; // add
                6'b100010: ALU_ctr = 4'b0110; // sub
                6'b100100: ALU_ctr = 4'b0000; // and
                6'b100101: ALU_ctr = 4'b0001; // or
                6'b101010: ALU_ctr = 4'b0111; // slt
                default:   ALU_ctr = 4'b0000;
            endcase
        end

        default: begin
            ALU_ctr = 4'b0000;
        end

    endcase
end
endmodule
