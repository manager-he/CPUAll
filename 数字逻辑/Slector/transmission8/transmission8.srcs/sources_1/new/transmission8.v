`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 21:30:45
// Design Name: 
// Module Name: transmission8
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


module transmission8(
    input [7:0] iData,
    input A,
    input B,
    input C,
    output reg [7:0] oData
    );
    reg Y;
    always @ (*)
    begin
        Y = iData[0] & !A & !B & !C | iData[1] & !A & !B &  C
           |iData[2] & !A &  B & !C | iData[3] & !A &  B &  C
           |iData[4] &  A & !B & !C | iData[5] &  A & !B &  C
           |iData[6] &  A &  B & !C | iData[7] &  A &  B &  C;
        oData[0] = Y |  A |  B |  C;
        oData[1] = Y |  A |  B | !C;
        oData[2] = Y |  A | !B |  C;
        oData[3] = Y |  A | !B | !C;
        oData[4] = Y | !A |  B |  C;
        oData[5] = Y | !A |  B | !C;
        oData[6] = Y | !A | !B |  C;
        oData[7] = Y | !A | !B | !C;        
    end
    
endmodule
