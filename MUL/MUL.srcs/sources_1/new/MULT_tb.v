`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/03 09:31:31
// Design Name: 
// Module Name: MULTU_tb
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


module MULT_tb;
	reg clk;
    reg reset;
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] z;
    
    MULT uut(clk,reset,a,b,z);
    
    parameter clk_cnt = 500, clk_period = 2;
    initial begin  
        clk = 0;  
        repeat(clk_cnt)  
            #(clk_period/2) clk = ~clk;  
    end  
    parameter once = 70;
    
    initial begin
        reset = 1;
        # 5 reset = 0; a = 0; b = 0;
        # once reset = 1;
        # 5 reset = 0; a = 0; b = 32'hffffffff;
        # once reset = 1;
        # 5 reset = 0; a = 32'hffffffff; b = 32'hffffffff;
        # once reset = 1;
        # 5 reset = 0; a = 32'h80000000; b = 32'haaaaaaaa;
        # once reset = 1;
        # 5 reset = 0; a = 32'hfffffffa; b = 32'hfffffff0;
        # once reset = 1;
        # 5 reset = 0; a = 32'hfffffff0; b = 32'hfffffffa;        
    end
    
endmodule
