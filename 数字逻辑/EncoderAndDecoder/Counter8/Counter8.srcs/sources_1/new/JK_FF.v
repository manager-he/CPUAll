`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/19 16:59:37
// Design Name: 
// Module Name: JK_FF
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


module JK_FF(
    input CLK,
    input J,
    input K,
    input RST_n,
    output reg Q
    );
    
    always@(posedge CLK or negedge RST_n)     
        begin
            if(RST_n==1'b0)
                Q<=1'b0;
          else 
            begin
                case({J,K})
                2'b00: Q <= Q;      
                2'b01: Q<= 1'b0;    
                2'b10: Q <= 1'b1;    
                2'b11: Q <= ~Q;      
            endcase
            end
        end
endmodule
