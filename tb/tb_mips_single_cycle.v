`timescale 1ns / 1ps

module tb_mips_single_cycle;

reg clk;
reg rst;

//==================================================
// DUT
//==================================================

mips_single_cycle dut(
    .clk(clk),
    .rst(rst)
);

//==================================================
// Clock Generation (100MHz)
//==================================================

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//==================================================
// Reset
//==================================================

initial begin
    rst = 1;
    #7;
    rst = 0;
end

//==================================================
// Initialize Data Memory
//==================================================

integer i;

initial begin

    // Kh?i t?o Data Memory = 0
    for(i = 0; i < 256; i = i + 1)
        dut.DM.mem[i] = 32'd0;

end

//==================================================
// Monitor
//==================================================

always @(posedge clk) begin

    $display("======================================================");
    $display("Time = %0t", $time);

    $display("PC          = %h", dut.PC);
    $display("Instruction = %h", dut.instruction);

    $display("Opcode      = %b", dut.opcode);
    $display("rs=%0d rt=%0d rd=%0d", dut.rs, dut.rt, dut.rd);

    $display("ReadData1   = %d", dut.ReadData1);
    $display("ReadData2   = %d", dut.ReadData2);

    $display("ALUResult   = %d", dut.ALUResult);
    $display("Zero        = %b", dut.Zero);

    $display("RegWrite    = %b", dut.RegWrite);
    $display("MemRead     = %b", dut.MemRead);
    $display("MemWrite    = %b", dut.MemWrite);

    $display("WriteBack   = %d", dut.WriteBackData);

end

//==================================================
// Finish
//==================================================

initial begin

    #300;

    $display("");
    $display("=============== REGISTER FILE ===============");

    $display("$t0 (r8 ) = %d", dut.RF.regs[8]);
    $display("$t1 (r9 ) = %d", dut.RF.regs[9]);
    $display("$t2 (r10) = %d", dut.RF.regs[10]);
    $display("$t3 (r11) = %d", dut.RF.regs[11]);
    $display("$t4 (r12) = %d", dut.RF.regs[12]);
    $display("$t5 (r13) = %d", dut.RF.regs[13]);
    $display("$t6 (r14) = %d", dut.RF.regs[14]);
    $display("$t7 (r15) = %d", dut.RF.regs[15]);

    $display("");
    $display("================ DATA MEMORY ================");

    $display("MEM[0] = %d", dut.DM.mem[0]);
    $display("MEM[1] = %d", dut.DM.mem[1]);
    $display("MEM[2] = %d", dut.DM.mem[2]);

    $display("");
    $display("============= INSTRUCTION MEMORY ============");

    $display("ROM[0] = %b", dut.IM.rom[0]);
    $display("ROM[1] = %b", dut.IM.rom[1]);
    $display("ROM[2] = %b", dut.IM.rom[2]);
    $display("ROM[3] = %b", dut.IM.rom[3]);

    $display("=============================================");

    $finish;

end

endmodule