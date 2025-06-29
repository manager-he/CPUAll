`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 20:50:06
// Design Name: 
// Module Name: JK_FF
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


module JK_FF(
    input CLK,
    input J,
    input K,
    input RST_n,
    output reg Q1,
    output reg Q2
    );
    always @(posedge CLK or negedge RST_n)
    begin
        if(RST_n==0)
        begin
            Q1 <= 0;
            Q2 <= 1;
        end
        else
        begin
            Q1 <= J&!Q1 | !K&Q1;
            Q2 <= !(J&!Q1 | !K&Q1);
        end
    end
endmodule
