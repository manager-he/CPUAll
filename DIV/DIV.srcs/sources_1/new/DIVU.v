`timescale 1ns / 1ps

module DIVU(
    input [31:0]dividend,
    input [31:0]divisor,
    input start,
    input clock,
    input reset,
    output [31:0]q,
    output [31:0]r,
    output reg busy
    );

    integer count;
    reg [31:0] reg_q;    // 被除数，左移后变成商
    reg [31:0] reg_r;    // 余数
    reg [31:0] reg_b;    // 除数
    reg r_sign;
    
    wire [32:0] sub_add = r_sign?({reg_r,reg_q[31]} + {1'b0,reg_b}):({reg_r,reg_q[31]} - {1'b0,reg_b}); //加、减法器
    // 实现左移然后加或者减除数的功能

    always @ (posedge clock or posedge reset)begin
        if (reset == 1) begin //重置
            count <= 0;
            busy <= 0;
        end 
        else begin
            if (start & !busy) begin //开始除法运算，初始化
                reg_r <= 0;
                r_sign <= 0;
                reg_q <= dividend;
                reg_b <= divisor;
                count <= 0;
                busy <= 1'b1;
            end else if (busy) begin //循环操作
                reg_r <= sub_add[31:0]; //部分余数
                r_sign <= sub_add[32]; //如果为负，下次相加
                reg_q <= {reg_q[30:0],~sub_add[32]};  // 左移，低位上商
                count <= count + 1; //计数器加一
                if (count == 31) busy <= 0; //结束除法运算
            end
        end
    end
    // 输出
    assign r = r_sign? reg_r + reg_b : reg_r;
    assign q = reg_q;

endmodule
