`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 20:19:20
// Design Name: 
// Module Name: Counter8_tb
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


module Counter8_tb(

    );
    reg CLK;
    reg rst_n;
    wire [2:0] oQ;
    wire [6:0] oDisplay;
    
    Counter8 uut1(.CLK(CLK),.rst_n(rst_n),.oQ(oQ),.oDisplay(oDisplay));
    
    always #5 CLK = ~CLK;
    initial begin
        CLK = 0; rst_n = 0;
        #10 rst_n = 1;
    end   
endmodule
