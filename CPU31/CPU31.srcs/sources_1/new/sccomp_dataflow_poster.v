`timescale 1ns / 1ps
module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
    );

    wire clk;   // cpu clk
    assign clk = clk_in;

    wire [31:0] mem_out;
    wire DM_EN, DM_W;
    wire [31:0] pc_out, dm_addr_out, dm_wdata;

    // CPU
    CPU sccpu(clk, reset, inst, mem_out, DM_EN, DM_W, pc_out, dm_addr_out, dm_wdata);
    assign pc = pc_out;

    // IMEM
    wire [31:0] im_addr;
    assign im_addr = (pc_out - 32'h00400000) / 4;
    IMEM imem_(reset, im_addr, inst);

    // DMEM
    wire [31:0] dm_addr;
    assign dm_addr = (dm_addr_out - 32'h10010000) / 4;
    DMEM dmem_(clk, reset, DM_EN, DM_W, dm_addr, dm_wdata, mem_out);

endmodule



