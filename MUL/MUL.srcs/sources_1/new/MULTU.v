`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/03 08:30:13
// Design Name: 
// Module Name: MULTU
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


module MULTU(
	input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    output [63:0] z
);
    reg [31:0] A;		// 存储（高位）-- 33位
    reg [31:0] C;		// 存储乘数（低位）
    reg [32:0] part;	// 存储部分积
    reg [63:0] temp;	
    integer cnt = 0;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            A = 0;
            C = 0;
            temp = 0;
            cnt = 0;
        end
        else begin            
            if(1) begin // cnt == 0
                C = b;
                A = 0;                      
                temp = 0;
            end
            repeat(32) begin
                if(C[0])  part = A + a;
                else part = A;
                
                C = {part[0], C[31:1]};  
                A = part[32:1];
                // cnt = cnt + 1;                        
            end  
            temp = {A, C};   
        end
	    // cnt = 0;
        // temp = {A, C};        
    end
    assign z = temp;
    
endmodule