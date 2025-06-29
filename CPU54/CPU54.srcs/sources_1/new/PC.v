`timescale 1ns / 1ps

module PC(                  //PC�Ĵ�����ͬ��д�루ʱ�������أ����첽��ȡ
    input clk,
    input rst,              //��λ�źţ��ߵ�ƽ��Ч
    input wena,
    input [31:0] iData,     //32λ�������ݣ���һ��ִ��ָ���ַ��
    output [31:0] oData     //32λ������ݣ�����ִ��ָ���ַ��
//    output [31:0] pc_pre
    );
    reg [31:0] oData_t,PC_EXC;
    
    always @ (posedge clk or posedge rst) begin //ʱ��������д�룬��λ�ź���������Ч
        if(rst) begin
            oData_t = 32'h00400000;
            PC_EXC = 32'h00400000;
//            oData_t <= 32'h00000000;
//            PC_EXC <= 32'h00000000;
        end
        else if(wena) begin
            PC_EXC = oData_t;
            oData_t = iData;
        end
    end
    
    assign oData = oData_t;   //��ʱ���Զ�ȡ����
//    assign pc_pre = PC_EXC;
endmodule

//module NPC(                  //PC�Ĵ�����ͬ��д�루ʱ�������أ����첽��ȡ
//    input clk,
//    input rst,              //��λ�źţ��ߵ�ƽ��Ч
//    input wena,
//    input [31:0] iData,     //32λ�������ݣ���һ��ִ��ָ���ַ��
//    output [31:0] oData,     //32λ������ݣ�����ִ��ָ���ַ��
//    output [31:0] PC_EXC
//    );
//    reg [31:0] oData_t,PC_EXC;
    
//    always @ (posedge clk or posedge rst) begin //ʱ��������д�룬��λ�ź���������Ч
//        if(rst) begin
//            oData_t <= 32'h00400000;
//            PC_EXC <= 32'h00400000;
////            oData_t <= 32'h00000000;
////            PC_EXC <= 32'h00000000;
//        end
//        else if(wena) begin
//            PC_EXC <= oData_t;
//            oData_t <= iData;
//        end
//    end
    
//    assign oData = oData_t;   //��ʱ���Զ�ȡ����
//endmodule
