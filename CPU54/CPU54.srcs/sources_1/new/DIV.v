`timescale 1ns / 1ps

module DIV(
	input clk,
	input reset,
	input ena,
    input Signed,
    input [31:0] dividend,
    input [31:0] divisor,
    output [63:0] Z64,
    output busy
);
    reg _Signed;
    always @(posedge ena) _Signed = Signed;

    wire [31:0] div_q, div_r, divu_q, divu_r;
    wire div_busy, divu_busy;
    DIVU divu (.clock(clk), .reset(reset), .start(ena), .dividend(dividend), .divisor(divisor), .q(divu_q), .r(divu_r), .busy(divu_busy));
    DIVS divs (.clock(clk), .reset(reset), .start(ena), .dividend(dividend), .divisor(divisor), .q(div_q), .r(div_r), .busy(div_busy));

    assign Z64 = _Signed? {div_r, div_q} : {divu_r, divu_q};// �������޷���
    assign busy = div_busy | divu_busy;
endmodule

module DIVU( 
    input [31:0] dividend,  //������
    input [31:0] divisor,   //����
    input start,            //������������
    input clock,            //ʱ���ź�
    input reset,            //��λ�źţ��ߵ�ƽ��Ч
    output [31:0] q,        //��
    output [31:0] r,        //����
    output reg busy             //������æ��־λ
    );
    //�Ĵ���
    reg [63:0] a_temp;
    reg [63:0] res; //��32λΪ��������32λΪ��
    integer cnt;
    
    always @ (posedge clock or posedge reset) begin
        //reset
        if(reset) begin
            busy = 0;
            a_temp = 0;
            res = 0;
            cnt = 0;
        end
        
        else begin
            //������������
            if(start & !busy) begin
                a_temp = {32'h00000000, dividend};
                busy = 1;
            end
            //���г���ѭ������
            if(busy) begin
                a_temp = {a_temp[62:0], 1'b0}; //����һλ�����һλ����
                if(a_temp[63:32] >= divisor) begin
                    a_temp = {a_temp[63:32]-divisor, a_temp[31:0]+1};
                end
                cnt = cnt + 1;
                if(cnt == 32) begin
                    res = a_temp;
                    busy = 0;
                    cnt = 0;
                end
            end
        end
    end
    assign q = res[31:0];
    assign r = res[63:32];
endmodule

module DIVS( 
    input [31:0] dividend,  //������
    input [31:0] divisor,   //����
    input start,            //������������
    input clock,            //ʱ���ź�
    input reset,            //��λ�źţ��ߵ�ƽ��Ч
    output [31:0] q,        //��
    output [31:0] r,        //����
    output reg busy             //������æ��־λ
    );
    //�Ĵ���
    reg [63:0] a_temp;
    reg [31:0] b_temp;
    reg [63:0] res; //��32λΪ��������32λΪ��
    integer cnt;
    reg a_sign;
    reg b_sign;
    reg sign;
    
    always @ (posedge clock or posedge reset) begin
        //reset
        if(reset) begin
            busy = 0;
            a_temp = 0;
            b_temp = 0;
            res = 0;
            cnt = 0;
            a_sign = 0;
            b_sign = 0;
        end
        
        else begin
            //������������
            if(start & !busy) begin
                a_sign = dividend[31];
                b_sign = divisor[31];
                if(!dividend) sign=0;
                else sign=a_sign^b_sign;
                a_temp = !a_sign ? {32'h00000000, dividend} : {32'h00000000, ~dividend+1};
                b_temp = !b_sign ? divisor : ~divisor+1;
                busy = 1;
            end
            //���г���ѭ������
            if(busy) begin
                a_temp = {a_temp[62:0], 1'b0}; //����һλ�����һλ����
                if(a_temp[63:32] >= b_temp) begin
                    a_temp = {a_temp[63:32]-b_temp, a_temp[31:0]+1};
                end
                cnt = cnt + 1;
                if(cnt == 32) begin
                    if(sign) a_temp = {a_temp[63:32], ~a_temp[31:0]+1};
                    if(a_sign) a_temp = {~a_temp[63:32]+1, a_temp[31:0]};
                    res = a_temp;
                    busy = 0;
                    cnt = 0;
                end
            end
        end
    end
    assign q = res[31:0];
    assign r = res[63:32];
endmodule
