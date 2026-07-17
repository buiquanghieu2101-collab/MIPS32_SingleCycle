`timescale 1ns / 1ps

module tb_instruction_memory;

reg  [31:0] addr;
wire [31:0] instruction;

instruction_memory DUT(
    .addr(addr),
    .instruction(instruction)
);

initial begin

    // ??i $readromb() ??c file
    #1;

    $display("========= Instruction romory =========");

    $display("rom[0] = %b", DUT.rom[0]);
    $display("rom[1] = %b", DUT.rom[1]);
    $display("rom[2] = %b", DUT.rom[2]);
    $display("rom[3] = %b", DUT.rom[3]);

    $display("--------------------------------------");

    addr = 32'd0;
    #10;
    $display("PC = %0d  Instruction = %b", addr, instruction);

    addr = 32'd4;
    #10;
    $display("PC = %0d  Instruction = %b", addr, instruction);

    addr = 32'd8;
    #10;
    $display("PC = %0d  Instruction = %b", addr, instruction);

    addr = 32'd12;
    #10;
    $display("PC = %0d  Instruction = %b", addr, instruction);

    $finish;

end

endmodule