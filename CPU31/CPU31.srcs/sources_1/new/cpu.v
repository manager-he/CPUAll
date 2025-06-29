`timescale 1ns / 1ps
module CPU (
    input clk, rst,
    input [31:0] inst,
    input [31:0] mem_out,
    output DM_EN, DM_W,
    output [31:0] pc_out, dm_addr, dm_wdata
);
    wire [31:0] pc, npc_out, next;
    // wire [31:0] inst;

    wire [4:0] rsc, rtc, rdc, base, sa5;
    wire [25:0] target26;
    wire [15:0] imm16;
    wire [31:0] target;

    // address
    assign rsc = inst[25:21];
    assign rtc = inst[20:16];
    assign rdc = inst[15:11];
    assign base = inst[25:21];
    assign sa5 = inst[10:6];
    assign target26 = inst[25:0];
    assign imm16 = inst[16:0];

    // extend
    assign target = {pc[31:28], target26, 2'b00};

    // pc
    PC pc_(clk, rst, next, pc);
    NPC npc_(pc, npc_out);

    // IMEM
    // IMEM imem_(rst, pc, inst);
    assign pc_out = pc;

    // Contrl
    wire [5:0] op, func;
    // wire DM_EN, DM_W;
    wire RF_W;
    wire [3:0] ALUC;
    wire M11, M12, M13, M2, M31, M32, M41, M42, M43, M51, M52;
    assign op = inst[31:26];
    assign func = inst[5:0];
    wire z;
    CU cu_(op, func, z, DM_EN, DM_W, RF_W, ALUC, M11, M12, M13, M2, M31, M32, M41, M42, M43, M51, M52);

    // RegFile
    wire [4:0] waddr;
    wire [31:0] wdata, rs, rt;
    RegFile cpu_ref(clk, rst, RF_W, rsc, rtc, waddr, wdata, rs, rt);
    wire [4:0] muxout51;
    MUX5 mux51_(M51, rdc, rtc, muxout51);
    MUX5 mux52_(M52, muxout51, 31, waddr);

    // Ext
    wire [31:0] sa, imm, offset, offset_times4;
    Ext5 ext5_(sa5, sa);
    Ext16 ext16_(imm16, imm);
    S_Ext16 s_ext16_(imm16, offset);
    S_Ext18 s_ext18_({imm16, 2'b00}, offset_times4);

    // ALU
    wire [31:0] alu_a, alu_b, alu_f;
    // wire z;
    ALU alu_(alu_a, alu_b, ALUC, alu_f, z);
    wire [31:0] muxout31, muxout41, muxout42;
    MUX32 mux31_(M31, rs, pc, muxout31);
    MUX32 mux32_(M32, muxout31, sa, alu_a);
    MUX32 mux41_(M41, rt, imm, muxout41);
    MUX32 mux42_(M42, offset, 4, muxout42);
    MUX32 mux43_(M43, muxout41, muxout42, alu_b);

    // DMEM
    // wire [31:0] mem_out;
    // DMEM dmem_(clk, rst, DM_EN, DM_W, alu_f, rt, mem_out);
    assign dm_addr = alu_f;
    assign dm_wdata = rt;

    // M2
    MUX32 mux2_(M2, alu_f, mem_out, wdata);

    // ADD
    wire [31:0] add_f;
    ADD add_(npc_out, offset_times4, add_f);

    // M1
    wire [31:0] muxout11, muxout12;
    MUX32 mux11_(M11, npc_out, target, muxout11);
    MUX32 mux12_(M12, add_f, rs, muxout12);
    MUX32 mux13_(M13, muxout11, muxout12, next);

endmodule