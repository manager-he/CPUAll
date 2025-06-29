`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 13:22:42
// Design Name: 
// Module Name: decoder32
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


module decoder32(
    input [4:0] iData,
    input [1:0] iEna,
    output reg [31:0] oData
    );
    always @(*) begin
        if(iEna == 2'b01)
            oData = ~(1<<iData);
    end
endmodule
