`timescale 1ns / 1ps

module control_unit(
    input  wire [5:0] opcode,

    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp
);

always @(*) begin

    // Default values
    RegDst   = 1'b0;
    ALUSrc   = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    Branch   = 1'b0;
    Jump     = 1'b0;
    ALUOp    = 2'b00;

    case(opcode)

        //=========================
        // R-Type
        //=========================
        6'b000000: begin
            RegDst   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b10;
        end

        //=========================
        // LW
        //=========================
        6'b100011: begin
            ALUSrc   = 1'b1;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            MemRead  = 1'b1;
            ALUOp    = 2'b00;
        end

        //=========================
        // SW
        //=========================
        6'b101011: begin
            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        //=========================
        // BEQ
        //=========================
        6'b000100: begin
            Branch = 1'b1;
            ALUOp  = 2'b01;
        end

        //=========================
        // ADDI
        //=========================
        6'b001000: begin
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        //=========================
        // J
        //=========================
        6'b000010: begin
            Jump = 1'b1;
        end

        default: begin
            // gi? các giá tr? m?c ??nh
        end

    endcase

end

endmodule