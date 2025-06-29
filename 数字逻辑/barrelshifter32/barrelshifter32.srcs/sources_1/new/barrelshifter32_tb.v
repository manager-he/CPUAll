`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/23 20:28:22
// Design Name: 
// Module Name: barrelshifter32_tb
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


module barrelshifter32_tb;
    reg [31:0] a;
    reg [4:0] b;
    reg [1:0] aluc;
    wire [31:0] c;
    
    barrelshifter32 uut(.a(a),.b(b),.aluc(aluc),.c(c));
    
    initial
    begin
    a=32'b00000000000000000000000000000111;
    #160 a=32'b00000000000000000000000000000011;
    end
    
    initial
    begin
    aluc = 2'b00;
    #40 aluc = 2'b01;
    #40 aluc = 2'b10;
    #40 aluc = 2'b11;
    
    #40 aluc = 2'b00;
    #40 aluc = 2'b01;
    #40 aluc = 2'b10;
    #40 aluc = 2'b11;
    end
    
    initial
    begin
    b = 1;   #20 b = 2;
    #20 b = 1; #20 b = 2;  
    #20 b = 1; #20 b = 2;  
    #20 b = 1; #20 b = 2;  
    #20 b = 1; #20 b = 2;  
    #20 b = 1; #20 b = 2;  
    #20 b = 1; #20 b = 2;  
    #20 b = 1; #20 b = 2;  
    
    
    end
endmodule
