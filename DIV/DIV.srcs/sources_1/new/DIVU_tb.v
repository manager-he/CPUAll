`timescale 1ns / 1ps

module DIV_tb();
    reg [31:0] dividend;  //被除数
    reg [31:0] divisor;   //除数
    reg start;            //启动除法运算
    reg clock;            //时钟信号
    reg reset;            //复位信号，高电平有效
    wire [31:0] q;        //商
    wire [31:0] r;        //余数
    wire busy;            //除法器忙标志位
    
    DIV DIV(.dividend(dividend),.divisor(divisor),.start(start),.clock(clock),.reset(reset),.q(q),.r(r),.busy(busy));
    
    //模拟时钟CLK
    parameter CLK_CYCLE=2; //时钟变化周期
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
