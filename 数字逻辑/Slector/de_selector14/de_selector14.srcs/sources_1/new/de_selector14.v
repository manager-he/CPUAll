`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 20:43:57
// Design Name: 
// Module Name: de_selector14
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


module de_selector14(
    input iC,
    input iS1,
    input iS0,
    output reg oZ0,
    output reg oZ1,
    output reg oZ2,
    output reg oZ3
    );
    always @ ( * )
    begin
        oZ0 = iC |  iS1 |  iS0;
        oZ1 = iC |  iS1 | !iS0;
        oZ2 = iC | !iS1 |  iS0;
        oZ3 = iC | !iS1 | !iS0;
    end
endmodule
