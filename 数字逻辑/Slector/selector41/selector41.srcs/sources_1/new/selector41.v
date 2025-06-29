`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 19:35:13
// Design Name: 
// Module Name: selector41
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


module selector41(
    input [3:0] iC0,
    input [3:0] iC1,
    input [3:0] iC2,
    input [3:0] iC3,
    input iS1,
    input iS0,
    output reg [3:0] oZ
    );
    
    integer i;
    always @(*)
    begin
        for(i=0;i<4;i=i+1)
        begin
            oZ[i] =  iC0[i] & !iS1 & !iS0
                   | iC1[i] & !iS1 &  iS0
                   | iC2[i] &  iS1 & !iS0
                   | iC3[i] &  iS1 &  iS0;
        end
    end
    
endmodule
