`timescale 1ns / 1ps
`define idle 1'b0//CPU待机状态
`define exec 1'b1//CPU运行状态

//定义指令的操作码
`define NOP   4'b0000
`define HALT  4'b0001
`define ADD   4'b0010
`define ADDI  4'b0011
`define SUB   4'b0100
`define SUBI  4'b0101
`define SRL   4'b0110
`define CMP   4'b0111
`define JUMP  4'b1000
`define BN    4'b1001
`define BNN   4'b1010
`define BZ    4'b1011
`define BNZ   4'b1100
`define LOAD  4'b1101
`define STORE 4'b1110

module pcpu(
    input clk,
    input enable,               //使能信号，高电平有效
    input reset,                //复位信号，高电平有效
    input start,                //CPU启动信号，高电平有效
    input [15:0] inst,          //从指令存储器读取的指令
    input [15:0] datain,        //从数据存储器读取的数据
    output reg [7:0] i_addr,    //下一条指令地址
    output [7:0] d_addr,        //数据地址
    output reg wena,            //数据写入信号，高电平有效
    output [15:0] dataout       //输出的数据
);
    
    reg cpu_state;
    reg next_cpu_state;    
    
    wire is_branch;//是否进行跳转的标志位
    
    reg [15:0] src_regA, src_regB;
    reg [15:0] dst_regC1, dst_regC2;
    reg [15:0] store_data;    
    reg [15:0] general_reg[15:0];
    wire [15:0] ALU_result;
    
    //CPU状态切换
    //每次时钟上升沿切换到下一个状态，若遇到复位信号则待机
    always @ (posedge clk)
    begin
        if (reset) cpu_state <= `idle;
        else cpu_state <= next_cpu_state;
    end
    //根据当前状态和输入确定下一个状态
    always @ (*) begin
        if (cpu_state == `idle) begin
            if ((enable == 1'b1) && (start == 1'b1)) next_cpu_state <= `exec;
            else next_cpu_state <= `idle;
        end
        else begin
            if ((enable == 1'b0) || (wb_input[15:12] == `HALT)) next_cpu_state <= `idle;
            else next_cpu_state <= `exec;
        end
    end
    //指令寄存器轮转
    reg [15:0] id_input, ex_input, mem_input, wb_input;//各阶段从上一个阶段拿到的指令
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            id_input <= 0;
            ex_input <= 0;
            mem_input <= 0;
            wb_input <= 0;
        end
        else if (cpu_state == `exec) begin
            id_input <= inst;
            ex_input <= id_input;
            mem_input <= ex_input;
            wb_input <= mem_input;
        end
    end
            
    
    //-------------------IF阶段-------------------
    always @ (posedge clk or posedge reset)
    begin
        if (reset) i_addr <= 0;
        else if (cpu_state == `exec)
        begin
            if (is_branch) i_addr <= dst_regC1[7:0];
            else i_addr <= i_addr + 1;
        end//根据跳转标志位来决定下一条要取的指令
    end
    
    //-------------------ID阶段-------------------
    wire EX_WRITE = ex_input[15:12] == `ADDI || ex_input[15:12] == `ADD || ex_input[15:12] == `SUBI || ex_input[15:12] == `SUB || ex_input[15:12] == `SRL;
    wire MEM_WRITE = mem_input[15:12] == `ADDI || mem_input[15:12] == `ADD || mem_input[15:12] == `SUBI || mem_input[15:12] == `SUB || mem_input[15:12] == `SRL;
    always @ (posedge clk or posedge reset)
    begin
        if (reset)
        begin            
            src_regA <= 0;
            src_regB <= 0;
        end//复位
        else if (cpu_state == `exec)
        begin                            
            if (id_input[15:12] == `JUMP)
                src_regA <= 0;
            else if (id_input[15:12] == `ADDI || id_input[15:12] == `SUBI || id_input[15:12] == `BN || id_input[15:12] == `BNN || id_input[15:12] == `BZ || id_input[15:12] == `BNZ)
                if ((ex_input[11:8] == id_input[11:8])&&EX_WRITE) src_regA <= ALU_result;
                else if((mem_input[11:8] == id_input[11:8])&&MEM_WRITE) src_regA <= dst_regC1;
                else src_regA <= general_reg[id_input[11:8]];
            else if (id_input[15:12] == `ADD || id_input[15:12] == `SUB || id_input[15:12] == `SUB || id_input[15:12] == `SRL || id_input[15:12] == `CMP ||  id_input[15:12] == `LOAD ||  id_input[15:12] == `STORE)
                if ((ex_input[11:8] == id_input[7:4])&&EX_WRITE) src_regA <= ALU_result;
                else if((mem_input[11:8] == id_input[7:4])&&MEM_WRITE) src_regA <= dst_regC1;
                else src_regA <= general_reg[id_input[7:4]];
            else
                src_regA <= src_regA;
                
            if (id_input[15:12] == `SRL || id_input[15:12] == `LOAD || id_input[15:12] == `STORE)
                src_regB <= {12'b0000_0000_0000, id_input[3:0]};
            else if (id_input[15:12] == `ADDI || id_input[15:12] == `SUBI || id_input[15:12] == `JUMP || id_input[15:12] == `BN || id_input[15:12] == `BNN || id_input[15:12] == `BZ || id_input[15:12] == `BNZ)
                src_regB <= {8'b0000_0000, id_input[7:0]};
            else if (id_input[15:12] == `ADD || id_input[15:12] == `SUB || id_input[15:12] == `CMP)
                if ((ex_input[11:8] == id_input[3:0])&&EX_WRITE) src_regB <= ALU_result;
                else if((mem_input[11:8] == id_input[3:0])&&MEM_WRITE) src_regB <= dst_regC1;
                else src_regB <= general_reg[id_input[3:0]];
            else
                src_regB <= src_regB;
        end
    end
    
    //-------------------EX阶段-------------------
    //根据指令的类型进行计算操作
    wire [1:0] aluc;
    assign aluc[0] = ex_input[15:12] == `SUB || ex_input[15:12] == `SUBI || ex_input[15:12] == `CMP? 1 : 0;
    assign aluc[1] = ex_input[15:12] == `SRL? 1 : 0;
    wire zf_tmp, nf_tmp, cf_tmp;
    reg zf_1, nf_1, cf_1;
    ALU ALU(.A(src_regA), .B(src_regB), .ALUC(aluc), .F(ALU_result), .Z(zf_tmp), .N(nf_tmp), .C(cf_tmp));
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            zf_1 <= 0;
            nf_1 <= 0;
        end
        else if (cpu_state == `exec) begin
            zf_1 <= zf_tmp;
            nf_1 <= nf_tmp;
        end
    end
    //设置标志位并传递store要存的值
    always @ (posedge clk or posedge reset)
    begin
        if (reset)
        begin
            dst_regC1 <= 0;
            store_data <= 0;
            wena <= 0;
        end//复位
        else if (cpu_state == `exec)
        begin
            dst_regC1 <= ALU_result;
            store_data <= general_reg[ex_input[11:8]];  
            wena <= ex_input[15:12] == `STORE? 1 : 0;
        end
    end
    
    //-------------------MEM阶段-------------------
    // 从EX阶段继承标志位
    reg zf_MEM, nf_MEM;
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            zf_MEM <= 0;
            nf_MEM <= 0;
        end
        else if (cpu_state == `exec) begin
            zf_MEM <= zf_1;
            nf_MEM <= nf_1;
        end
    end
    assign d_addr = dst_regC1[7:0];
    assign dataout = store_data;
    assign is_branch = ((mem_input[15:12] == `JUMP)
                     || ((mem_input[15:12] == `BN) && (nf_MEM == 1'b1)) 
                     || ((mem_input[15:12] == `BNN) && (nf_MEM == 1'b0))
                     || ((mem_input[15:12] == `BZ) && (zf_MEM == 1'b1))
                     || ((mem_input[15:12] == `BNZ) && (zf_MEM == 1'b0)));
    always @ (posedge clk or posedge reset)
    begin
        if (reset) dst_regC2 <= 0;
        else if (cpu_state == `exec)
        begin
            if (mem_input[15:12] == `LOAD) dst_regC2 <= datain;
            else dst_regC2 <= dst_regC1;
        end
    end
    
    //-------------------WB阶段-------------------
    integer i;
    always @ (negedge clk or posedge reset)
    begin
        if (reset)
        for (i = 0; i < 16; i = i + 1) begin
            general_reg[i] <= 16'b0;  // 将每个寄存器初始化为0
        end        
        else if (cpu_state == `exec)
        begin
            if (wb_input[15:12] == `ADD || wb_input[15:12] == `ADDI || wb_input[15:12] == `SUB || wb_input[15:12] == `SUBI ||wb_input[15:12] == `SRL || wb_input[15:12] == `LOAD)
                general_reg[wb_input[11:8]] <= dst_regC2;
        end
    end
endmodule
