`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 21:35:19
// Design Name: 
// Module Name: DataCompare8_tb
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


module DataCompare8_tb;
    reg [7:0] iData_a;
    reg [7:0] iData_b;
    reg [2:0] iData;
    wire [2:0] oData; 
   
    DataCompare8 uut(.iData_a(iData_a),.iData_b(iData_b),.iData(iData),.oData(oData));
    
    initial
    begin
    iData = 3'b001;
    #620 iData = 3'b010;
    end
    
    initial
    begin
    iData_a = 8'b10000000; iData_b = 8'b00000000;       //larger
    #100 iData_a = 8'b00100000; iData_b = 8'b01000000;  //smaller
    #100 iData_a = 8'b11110000; iData_b = 8'b11110000;  //equal
    #20
    #100 iData_a = 8'b11111000; iData_b = 8'b11110000;  //larger
    #100 iData_a = 8'b11111000; iData_b = 8'b11111100;  //samller
    #100 iData_a = 8'b11111111; iData_b = 8'b11111111;  //equal
    end
endmodule
