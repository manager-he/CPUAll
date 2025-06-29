`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 19:15:43
// Design Name: 
// Module Name: Divider
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


module Divider(
    input I_CLK,
    input rst,
    output reg O_CLK = 0
    );    
   
    reg [3:0] cnt = 0;   
    parameter N=20;
      
  //assign O_CLK = clk_out;
   always @ (posedge I_CLK)begin
    if(rst == 1'b1)
    begin
        cnt <= 0;
        O_CLK<= 0;
    end
    else  if(cnt == N/2-1)  
    begin 
        O_CLK<=~O_CLK; 
        cnt<=0; 
    end
    else
        cnt <= cnt + 1'b1;
    end

    
    
endmodule
