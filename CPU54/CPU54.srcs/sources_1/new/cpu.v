`timescale 1ns / 1ps
module CPU (
    input clk, rst,
    input [31:0] imem_out,
    input [31:0] dmem_out,
    output DM_EN, DM_W, DM_bit, DM_halfw, DM_word, DM_signed, 
    output [31:0] pc_out, inst, dm_addr, dm_wdata,
    output PRINTCLK
);
    // PC
    wire [31:0] pc, next;
    wire PCin;
    PC REG_PC(clk, rst, PCin, next, pc);
    wire [1:0] MuxPC;
    wire [31:0] Z_out, rs, target, CP0_exc_addr;
    assign next = MuxPC==0? Z_out : MuxPC==1? rs : MuxPC==2 ? target : CP0_exc_addr;
    assign pc_out = pc;
    
    // IR
    // wire [31:0] inst;
    wire IRin;
    REG REG_IR(clk, rst, IRin, imem_out, inst);


    // address
    wire [4:0] rsc, rtc, rdc, base, sa5;
    wire [25:0] target26;
    wire [15:0] imm16;
    // wire [31:0] target;
    assign rsc = inst[25:21];
    assign rtc = inst[20:16];
    assign rdc = inst[15:11];
    assign base = inst[25:21];
    assign sa5 = inst[10:6];
    assign target26 = inst[25:0];
    assign imm16 = inst[16:0];

    // extend
    assign target = {pc[31:28], target26, 2'b00};
    // Ext
    wire [31:0] sa, imm, offset, offset_times4;
    Ext5 ext5_(sa5, sa);
    Ext16 ext16_(imm16, imm);
    S_Ext16 s_ext16_(imm16, offset);
    S_Ext18 s_ext18_({imm16, 2'b00}, offset_times4);

    // RegFile
    wire [4:0] waddr;
    wire [31:0] wdata, rt; // rs;
    wire RF_W;
    RegFile cpu_ref(clk, rst, RF_W, rsc, rtc, waddr, wdata, rs, rt);
    wire [1:0] MuxRF_waddr;
    assign waddr = MuxRF_waddr==0? rdc : MuxRF_waddr==1? rtc : 31;  // MUXRF_waddr
    wire [2:0] MuxRF;
    wire [31:0] CP0_out, hi_out, lo_out;    // Z_out;
    assign wdata = MuxRF==0? Z_out : MuxRF==1? hi_out : MuxRF==2? lo_out : MuxRF==3? CP0_out : MuxRF==4? pc_out : dmem_out; // MUXRF

    // ALU
    wire [31:0] alu_a, alu_b, alu_f;
    wire Zin;   // Z_out
    REG REG_Z(clk, rst, Zin, alu_f, Z_out);
    wire [3:0] ALUC;
    wire alu_zero, alu_negative;
    ALU alu_(alu_a, alu_b, ALUC, alu_f, alu_zero, alu_negative);
    wire [1:0] MuxA;
    wire [2:0] MuxB;
    assign alu_a = MuxA==0? rs : MuxA==1? sa : pc_out;  // MUXA
    assign alu_b = MuxB==0? rt : MuxB==1? 0 : MuxB==2? offset_times4 : MuxB==3? imm : MuxB==4? offset : 4;  // MUXB

    // MUL & DIV
    wire MUL_ena, MUL_mul, MUL_signed;
    wire [31:0] Z1, Z2;
    wire mul_busy;  // export to control unit
    MUL_DIV MUL_DIV(clk, rst, MUL_ena, MUL_mul, MUL_signed, rs, rt, Z1, Z2, mul_busy);

    // HI & LO
    wire LOin, HIin, MuxLO, MuxHI;
    wire [31:0] hi_in, lo_in; // hi_out, lo_in, lo_out;
    REG REG_HI(clk, rst, HIin, hi_in, hi_out);
    REG REG_LO(clk, rst, LOin, lo_in, lo_out);
    assign lo_in = MuxLO? rs : Z2;  // MUXLO
    assign hi_in = MuxHI? rs : Z1;  // MUXHI

    // CP0
    wire MFC0, MTC0, Exception, ERET;
    wire [4:0] cause;
    wire [31:0] CP0_status;
    wire timer_int;
    // CP0 CP0(clk, rst, MFC0, MTC0, pc, rdc, rt, Exception, ERET, cause, CP0_out, CP0_status, timer_int, CP0_exc_addr);
    CP0 CP0(.clk(clk), .rst(rst), .mfc0(MFC0), .mtc0(MTC0), .pc(pc), .Rd(rdc), .wdata(rt), .exception(Exception), .eret(ERET),
         .cause(cause), .rdata(CP0_out), .status(CP0_status), .timer_int(timer_int), .exc_addr(CP0_exc_addr));


    // Contrl
    wire [5:0] op, func;
    assign op = inst[31:26];
    assign func = inst[5:0];
    // CU CU(clk, rst, op, func, alu_zero, alu_negative, mul_busy,
    //     IRin, PCin, MuxPC, MuxA, MuxB, ALUC, Zin, RF_W, MuxRF, MuxRF_waddr, 
    //     DM_EN, DM_W, DM_bit, DM_halfw, DM_word, DM_signed,
    //     MUL_ena, MUL_mul, MUL_signed, LOin, HIin, MuxLO, MuxHI);    
    CU CU(.clk(clk), .rst(rst), .op(op), .func(func), .base(rsc), .alu_zero(alu_zero), .alu_negative(alu_negative), .mul_busy(mul_busy),
        .IRin(IRin), .PCin(PCin), .MuxPC(MuxPC), .MuxA(MuxA), .MuxB(MuxB), .ALUC(ALUC), .Zin(Zin), .RF_W(RF_W), .MuxRF(MuxRF), .MuxRF_waddr(MuxRF_waddr), 
        .DM_EN(DM_EN), .DM_W(DM_W), .DM_bit(DM_bit), .DM_halfw(DM_halfw), .DM_word(DM_word), .DM_signed(DM_signed),
        .MUL_ena(MUL_ena), .MUL_mul(MUL_mul), .MUL_signed(MUL_signed), .LOin(LOin), .HIin(HIin), .MuxLO(MuxLO), .MuxHI(MuxHI),
        .MFC0(MFC0), .MTC0(MTC0), .Exception(Exception), .ERET(ERET), .cause(cause), .Print(PRINTCLK));

    // DMEM
    // wire [31:0] dmem_out;
    // DMEM dmem_(clk, rst, DM_EN, DM_W, alu_f, rt, dmem_out);
    assign dm_addr = Z_out;
    assign dm_wdata = rt;


endmodule