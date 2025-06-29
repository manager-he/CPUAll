`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 21:00:43
// Design Name: 
// Module Name: JK_FF_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module JK_FF_tb;
    reg CLK;
    reg J;
    reg K;
    reg RST_n;
    wire Q1;
    wire Q2;
    JK_FF uut(.CLK(CLK),.J(J),.K(K),.RST_n(RST_n),.Q1(Q1),.Q2(Q2));
    
    parameter clk_cnt = 16, clk_period = 40;
    initial begin  
        CLK = 0;  
        repeat(clk_cnt)  
            #(clk_period/2) CLK = ~CLK;  
    end  
    initial begin
        J = 0;K = 0;
        #(clk_period) J = 0; K = 1;
        #(clk_period) J = 1; K = 0;
        #(clk_period) J = 1; K = 1;
        
        #(clk_period) J = 0; K = 0;
        #(clk_period) J = 0; K = 1;
        #(clk_period) J = 1; K = 0;
        #(clk_period) J = 1; K = 1;
    end
    initial begin
        RST_n = 1;
        #(clk_period*4) RST_n = 0;
    end 
endmodule
