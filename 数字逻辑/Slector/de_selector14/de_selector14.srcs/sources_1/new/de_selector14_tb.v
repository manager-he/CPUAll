`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 20:48:29
// Design Name: 
// Module Name: de_selector14_tb
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


module de_selector14_tb;
    reg iC,iS1,iS0;
    wire oZ0,oZ1,oZ2,oZ3;
    de_selector14 uut(
        .iC(iC),.iS1(iS1),.iS0(iS0),
        .oZ0(oZ0),.oZ1(oZ1),.oZ2(oZ2),.oZ3(oZ3)
    );
    
    initial
    begin
        iS1 = 0; iS0 = 0;
        #40 iS1 = 1; iS0 = 0;
        #40 iS1 = 0; iS0 = 1;
        #40 iS1 = 1; iS0 = 1;
    end
    
    initial
    begin
        iC = 0;
        #20 iC = 1;
        #20 iC = 0;
        #20 iC = 1;
        #20 iC = 0;
        #20 iC = 1;
        #20 iC = 0;
        #20 iC = 1;
        #20 iC = 0;
    end
    
endmodule
