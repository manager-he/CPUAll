`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/03 16:41:23
// Design Name: 
// Module Name: MULT
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


module MULT(
	input clk,
    input reset,
    input signed [31:0] a,
    input signed [31:0] b,
    output signed [63:0] z
);
    
    reg signed [32:0] A;		// 部分和（高位） 符号位参与运算，所以不考虑溢出
    reg signed [32:0] X;		// 被乘数，拓展符号位
    reg [32:0] C;		// 存储乘数（低位）-- 最后一位补充位
    reg [32:0] part;	// 存储部分积
    reg [63:0] temp;	
    integer cnt = 0;
    
    /*
    reg [31:0] A;        // 存储（高位）-- 33位
    reg [31:0] C;        // 存储乘数（低位）
    reg [32:0] part;    // 存储部分积
    reg [63:0] temp;    
    reg [31:0] abs_a;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            A = 0;
            C = 0;
            temp = 0;
        end
        else begin                   
            C = b[31]? ~b+1 : b;
            abs_a = a[31]? ~a+1 : a;
            A = 0;                      
            temp = 0;
            repeat(32) begin
                if(C[0])  part = A + abs_a;
                else part = A;
                
                C = {part[0], C[31:1]};  
                A = part[32:1];
                // cnt = cnt + 1;                        
            end  
            temp = {A, C}; 
            temp = a[31] ^ b[31]? ~temp+1 : temp;
        end
        // cnt = 0;
        // temp = {A, C};        
    end
    assign z = temp;*/

    // 方法二
    // Booth
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            A = 0;
            X = 0;
            C = 0;
            temp = 0;
            cnt = 0;
        end
        else begin
	    repeat(32) begin
            if(cnt == 0) begin
                A = 0;
                C = {b,1'b0};
                X = {a[31],a};                
            end
            if(C[1:0]==2'b10) A = A + (~X + 1'b1);	
            else if(C[1:0]==2'b01) A = A + X;
            C = {A[0], C[32:1]};
            A = A >>> 1;
            cnt = cnt + 1;            
	    end
        end
        if(cnt == 32) temp = {A[31:0], C[32:1]};
	    cnt = 0;
        
    end
    assign z = temp;
    
endmodule
