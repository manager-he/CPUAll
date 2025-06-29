`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/23 19:51:26
// Design Name: 
// Module Name: barrelshifter32
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


module barrelshifter32(
    input [31:0] a,
    input [4:0] b,
    input [1:0] aluc,
    output reg [31:0] c
    );
    reg [31:0] temp;
    always @ (a or b or aluc) begin
    if (aluc[0]) c = (a << b);
    else  if (aluc[1]) c = (a >> b);
    else if (!a[31]) c = (a >> b);
    else c = (a >> b) |(~(32'b11111111111111111111111111111111 >> b));
    end    
endmodule
