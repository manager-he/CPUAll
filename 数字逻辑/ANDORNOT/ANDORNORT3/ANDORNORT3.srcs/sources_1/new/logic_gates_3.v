`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/19 23:14:16
// Design Name: 
// Module Name: logic_gates_3
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


module logic_gates_3(iA,iB,oAnd,oOr,oNot);
    input iA;
    input iB;
    output reg oAnd,oOr,oNot;
    always @ (*)
    begin 
	oAnd = iA & iB;
	oOr = iA | iB;
	oNot = ~iA;
    end
endmodule
