`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 19:28:14
// Design Name: 
// Module Name: Divider_tb
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


module Divider_tb(

    );
    reg I_CLK;
    reg rst;
    wire O_CLK;
    
    Divider uut(.I_CLK(I_CLK),.rst(rst),.O_CLK(O_CLK));
    
    always #2 I_CLK = ~I_CLK;
    initial begin
        I_CLK = 0;
        rst = 1;
        #10 rst = 0;
    end   
    
endmodule
