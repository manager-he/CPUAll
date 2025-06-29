`timescale 1ns / 1ps
module DIV(
    input [31:0]dividend,
    input [31:0]divisor,
    input start,
    input clock,
    input reset,
    output [31:0]q,
    output [31:0]r,
    output reg busy
    );
    wire sign1 = dividend[31]; // �������������ķ���
    wire sign2 = divisor[31]; // �����ķ���
    
    integer count;
    reg [31:0] reg_q;    // �����������ƺ�����
    reg [31:0] reg_r;    // ����
    reg [31:0] reg_b;    // ����
    reg r_sign;         // 0 ��ʾ������ͬ����ȥ����
    
    always @(posedge clock or posedge reset) begin
        if (reset) begin //����
            count = 0;
            busy = 0;
        end else begin
            if(start & !busy) begin
                reg_q = sign1? ~dividend+1 : dividend;
                reg_b = sign2? ~divisor+1 : divisor;
                // ���б�����С�ڳ��������
                if(reg_q < reg_b) begin
                    reg_q = 0; reg_r = dividend;
                    busy = 0;
                end else begin
                    reg_r = 0;
                    r_sign = 0;
                    count = 0;
                    busy = 1;
                end
            end    
            else if(busy) begin
                reg_r = {reg_r[31:0], reg_q[30]};
                reg_q = {reg_q[31], reg_q[29:0], 1'b0};
                if(r_sign==0) reg_r = reg_r + (~reg_b + 1);
                else reg_r = reg_r + reg_b;
                if(reg_r[31]==0) reg_q[0] = 1;
                if(reg_r[31]==1) r_sign = 1;
                else r_sign = 0;
                count = count + 1;
            end
            if(count == 31) begin
                if(r_sign==1) reg_r = reg_r + reg_b;    // �ָ�����
                if(sign1 ^ sign2) reg_q = ~reg_q + 1;
                if(sign1) reg_r = ~reg_r + 1;
                count = 0;
                busy = 0;
            end
        end
    end
    
    assign r = reg_r;
    assign q = reg_q;
            
        
endmodule
