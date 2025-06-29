`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 20:11:10
// Design Name: 
// Module Name: Synchronous_D_FF_tb
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


module Synchronous_D_FF_tb;
    reg CLK;
    reg D;
    reg RST_n;
    wire Q1;
    wire Q2;
    Synchronous_D_FF uut(.CLK(CLK),.D(D),.RST_n(RST_n),.Q1(Q1),.Q2(Q2));
    
    parameter clk_cnt = 8, clk_period = 40;
    initial begin  
        CLK = 0;  
        repeat(clk_cnt)  
            #(clk_period/2) CLK = ~CLK;  
    end  
    initial begin
        D = 0;
        #(clk_period) D = 1;
        #(clk_period) D = 0;
        #(clk_period) D = 1;
    end
    initial begin
        RST_n = 1;
        #(clk_period*2) RST_n = 0;
    end
    
endmodule
