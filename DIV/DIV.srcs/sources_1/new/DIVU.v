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
    reg [31:0] reg_q;    // �����������ƺ�����
    reg [31:0] reg_r;    // ����
    reg [31:0] reg_b;    // ����
    reg r_sign;
    
    wire [32:0] sub_add = r_sign?({reg_r,reg_q[31]} + {1'b0,reg_b}):({reg_r,reg_q[31]} - {1'b0,reg_b}); //�ӡ�������
    // ʵ������Ȼ��ӻ��߼������Ĺ���

    always @ (posedge clock or posedge reset)begin
        if (reset == 1) begin //����
            count <= 0;
            busy <= 0;
        end 
        else begin
            if (start & !busy) begin //��ʼ�������㣬��ʼ��
                reg_r <= 0;
                r_sign <= 0;
                reg_q <= dividend;
                reg_b <= divisor;
                count <= 0;
                busy <= 1'b1;
            end else if (busy) begin //ѭ������
                reg_r <= sub_add[31:0]; //��������
                r_sign <= sub_add[32]; //���Ϊ�����´����
                reg_q <= {reg_q[30:0],~sub_add[32]};  // ���ƣ���λ����
                count <= count + 1; //��������һ
                if (count == 31) busy <= 0; //������������
            end
        end
    end
    // ���
    assign r = r_sign? reg_r + reg_b : reg_r;
    assign q = reg_q;

endmodule
