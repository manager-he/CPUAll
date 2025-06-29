`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 21:52:33
// Design Name: 
// Module Name: pcreg_tb
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


module pcreg_tb;
    reg clk;
    reg rst;
    reg ena;
    reg [31:0] data_in;
    wire [31:0] data_out;
    pcreg uut(.clk(clk),.rst(rst),.ena(ena),.data_in(data_in),.data_out(data_out));
    parameter clk_cnt = 8, clk_period = 40;
        initial begin  
            clk = 0;  
            repeat(clk_cnt)  
            #(clk_period/2) clk = ~clk;  
        end  
        initial begin
            data_in = 1'b0;
            #(clk_period) data_in = 32'h12345678;
            #(clk_period) data_in = 32'h66654321;
            #(clk_period) data_in = 32'h88888888;
        end
        initial begin
            rst = 0;
            repeat(clk_cnt * 3 / 2)
            #(clk_period / 3) rst = ~rst;
        end
        initial begin
        ena = 1;
        # (clk_period * clk_cnt / 4) ena = 0;
        end
endmodule
