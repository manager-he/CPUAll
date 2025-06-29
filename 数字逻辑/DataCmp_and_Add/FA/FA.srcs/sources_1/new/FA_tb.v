`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 22:33:42
// Design Name: 
// Module Name: FA_tb
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


module FA_tb;
    reg iA,iB,iC;
    wire oS,oC;
    FA uut(.iA(iA),.iB(iB),.iC(iC),
        .oS(oS),.oC(oC));
    initial
    begin
        iA = 0;iB = 0;iC = 0; //euqal
        #40 iA = 0;iB = 1; iC = 0; //smaller
        #40 iA = 1; iB = 0; iC = 0; // larger
        #40 iA = 1; iB = 1; iC = 0; //equal
        #40 iA = 1; iB = 1; iC = 1; //larger
    end
endmodule
