`timescale 1ns / 1ps

module mips_single_cycle(
    input clk,
    input rst
);

//==================================================
// PC
//==================================================

wire [31:0] PC;
wire [31:0] NextPC;
wire [31:0] PCPlus4;

pc PC_REG(
    .clk(clk),
    .rst(rst),
    .next_pc(NextPC),
    .pc(PC)
);

pc_adder PC_ADDER(
    .pc(PC),
    .pc_plus4(PCPlus4)
);

//==================================================
// Instruction Memory
//==================================================

wire [31:0] instruction;

instruction_memory IM(
    .addr(PC),
    .instruction(instruction)
);

//==================================================
// Decoder
//==================================================

wire [5:0] opcode;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [5:0] funct;
wire [15:0] immediate;
wire [25:0] jump_index;

instruction_decoder DECODER(
    .instruction(instruction),

    .opcode(opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .shamt(shamt),
    .funct(funct),
    .immediate(immediate),
    .jump_addr(jump_index)
);

//==================================================
// Control Unit
//==================================================

wire RegDst;
wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire Jump;
wire [1:0] ALUOp;

control_unit CU(
    .opcode(opcode),

    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jump(Jump),
    .ALUOp(ALUOp)
);

//==================================================
// ALU Control
//==================================================

wire [3:0] ALU_ctr;

ALU_control ALUCTRL(
    .funct(funct),
    .ALUOp(ALUOp),
    .ALU_ctr(ALU_ctr)
);

//==================================================
// Register File
//==================================================

wire [4:0] WriteReg;
wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] WriteBackData;

mux2 #(.WIDTH(5)) REGDST_MUX(
    .in0(rt),
    .in1(rd),
    .sel(RegDst),
    .out(WriteReg)
);

registers_file RF(
    .clk(clk),
    .rst(rst),

    .rs(rs),
    .rt(rt),
    .rd(WriteReg),

    .WriteData(WriteBackData),
    .RegWrite(RegWrite),

    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

//==================================================
// Sign Extend
//==================================================

wire [31:0] SignImm;

sign_extend SE(
    .in(immediate),
    .out(SignImm)
);

//==================================================
// ALU Source MUX
//==================================================

wire [31:0] ALU_B;

mux2 ALUSRC_MUX(
    .in0(ReadData2),
    .in1(SignImm),
    .sel(ALUSrc),
    .out(ALU_B)
);

//==================================================
// ALU
//==================================================

wire [31:0] ALUResult;
wire Zero;

ALU ALU_CORE(
    .ALU_ctr(ALU_ctr),
    .A(ReadData1),
    .B(ALU_B),
    .Result(ALUResult),
    .zero(Zero)
);

//==================================================
// Data Memory
//==================================================

wire [31:0] MemReadData;

data_memory DM(
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .addr(ALUResult),
    .WriteData(ReadData2),
    .ReadData(MemReadData)
);

//==================================================
// Write Back MUX
//==================================================

mux2 MEMTOREG_MUX(
    .in0(ALUResult),
    .in1(MemReadData),
    .sel(MemtoReg),
    .out(WriteBackData)
);

//==================================================
// Branch
//==================================================

wire [31:0] ShiftImm;

shift_left2 SHIFT(
    .in(SignImm),
    .out(ShiftImm)
);

wire [31:0] BranchAddr;

branch_adder BRANCH_ADDER(
    .pc_plus4(PCPlus4),
    .branch_offset(ShiftImm),
    .branch_addr(BranchAddr)
);

wire PCSrc;

and_gate BRANCH_AND(
    .Branch(Branch),
    .Zero(Zero),
    .PCSrc(PCSrc)
);

wire [31:0] BranchPC;

mux2 BRANCH_MUX(
    .in0(PCPlus4),
    .in1(BranchAddr),
    .sel(PCSrc),
    .out(BranchPC)
);

//==================================================
// Jump
//==================================================

wire [31:0] JumpAddr;

jump_address JUMP_ADDR(
    .pc_plus4(PCPlus4),
    .instr_index(jump_index),
    .jump_addr(JumpAddr)
);

mux2 JUMP_MUX(
    .in0(BranchPC),
    .in1(JumpAddr),
    .sel(Jump),
    .out(NextPC)
);

endmodule