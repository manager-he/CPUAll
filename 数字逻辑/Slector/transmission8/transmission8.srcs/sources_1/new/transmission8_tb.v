`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 21:55:03
// Design Name: 
// Module Name: transmission8_tb
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


module transmission8_tb;
    reg [7:0] iData;
    reg A,B,C;
    wire [7:0] oData;
    transmission8 uut(
        .iData(iData),
        .A(A),.B(B),.C(C),
        .oData(oData)
    );
    initial
    begin
        A = 0;B = 0;C = 0;
        #40 A = 0;B = 0;C = 1;
        #40 A = 0;B = 1;C = 0;
        #40 A = 0;B = 1;C = 1;
        #40 A = 1;B = 0;C = 0;
        #40 A = 1;B = 0;C = 1;
        #40 A = 1;B = 1;C = 0;
        #40 A = 1;B = 1;C = 1;
        
        #40 A = 0;B = 0;C = 0;
        #40 A = 0;B = 0;C = 1;
        #40 A = 0;B = 1;C = 0;
        #40 A = 0;B = 1;C = 1;
        #40 A = 1;B = 0;C = 0;
        #40 A = 1;B = 0;C = 1;
        #40 A = 1;B = 1;C = 0;
        #40 A = 1;B = 1;C = 1;
    end
    
    initial
    begin
        iData = 8'b00000000;
        #320 iData = 8'b11111111;
    end
endmodule
