`timescale 1ns / 1ps

module DIV_tb();
    reg [31:0] dividend;  //������
    reg [31:0] divisor;   //����
    reg start;            //������������
    reg clock;            //ʱ���ź�
    reg reset;            //��λ�źţ��ߵ�ƽ��Ч
    wire [31:0] q;        //��
    wire [31:0] r;        //����
    wire busy;            //������æ��־λ
    
    DIV DIV(.dividend(dividend),.divisor(divisor),.start(start),.clock(clock),.reset(reset),.q(q),.r(r),.busy(busy));
    
    //ģ��ʱ��CLK
    parameter CLK_CYCLE=2; //ʱ�ӱ仯����
    initial clock=0;
    always #(CLK_CYCLE/2) clock=!clock;
    
    //reset
    initial begin
        reset = 1;
        #5 reset = 0;
    end
    
    //start
    initial begin
        #5 start = 1;
        repeat(10000) begin
            #1 start = 0;
            #(CLK_CYCLE*31+1) start = 1; 
        end
    end
    
    //dividend
    initial begin
        #5 dividend = 32'h00000000;
        #(CLK_CYCLE*32*4) dividend = 32'hffffffff;
        #(CLK_CYCLE*32*4) dividend = 32'haaaaaaaa;
        #(CLK_CYCLE*32*4) dividend = 32'h55555555;
        #(CLK_CYCLE*32*4) dividend = 32'h7fffffff;
    end
    
    //divisor
    initial begin
        #5 divisor = 32'hffffffff;
        #(CLK_CYCLE*32) divisor = 32'haaaaaaaa;
        #(CLK_CYCLE*32) divisor = 32'h55555555;
        #(CLK_CYCLE*32) divisor = 32'h7fffffff;
        
        #(CLK_CYCLE*32) divisor = 32'hffffffff;
        #(CLK_CYCLE*32) divisor = 32'haaaaaaaa;
        #(CLK_CYCLE*32) divisor = 32'h55555555;
        #(CLK_CYCLE*32) divisor = 32'h7fffffff;
        
        #(CLK_CYCLE*32) divisor = 32'hffffffff;
        #(CLK_CYCLE*32) divisor = 32'haaaaaaaa;
        #(CLK_CYCLE*32) divisor = 32'h55555555;
        #(CLK_CYCLE*32) divisor = 32'h7fffffff;
        
        #(CLK_CYCLE*32) divisor = 32'hffffffff;
        #(CLK_CYCLE*32) divisor = 32'haaaaaaaa;
        #(CLK_CYCLE*32) divisor = 32'h55555555;
        #(CLK_CYCLE*32) divisor = 32'h7fffffff;
    end
    
endmodule
