`timescale 1ns / 1ps
module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
    );

    wire [31:0] imem_out, dmem_out;
    wire DM_EN, DM_W, DM_bit, DM_halfw, DM_word, DM_signed;
    wire [31:0] pc_out, dm_addr_out, dm_wdata;

    // CPU
    wire [31:0] ir_out; 
    wire PRINTCLK;
    CPU sccpu(clk_in, reset, imem_out, dmem_out, DM_EN, DM_W, DM_bit, DM_halfw, DM_word, DM_signed, pc_out, ir_out, dm_addr_out, dm_wdata, PRINTCLK);

    
    // PRINT
    PRINT PRINT(PRINTCLK, reset, pc_out, imem_out, pc, inst);

    // IMEM
    wire [31:0] im_addr;
    assign im_addr = (pc_out - 32'h00400000) / 4;
    IMEM imem_(reset, im_addr, imem_out);

    // DMEM
    wire [31:0] dm_addr;
    assign dm_addr = (dm_addr_out - 32'h10010000) / 4;
    DMEM dmem_(clk_in, reset, DM_EN, DM_W, dm_addr, dm_wdata, DM_bit, DM_halfw, DM_word, DM_signed, dmem_out);

endmodule
