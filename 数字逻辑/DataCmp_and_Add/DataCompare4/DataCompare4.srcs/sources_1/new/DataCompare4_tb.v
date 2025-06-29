`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 18:30:10
// Design Name: 
// Module Name: DataCompare4_tb
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


module DataCompare4_tb;
    reg [3:0] iData_a;
    reg [3:0] iData_b;
    reg [2:0] iData;
    wire [2:0] oData;
    
   
    DataCompare4 uut(.iData_a(iData_a),.iData_b(iData_b),.iData(iData),.oData(oData));
    initial
    begin
    iData = 3'b001;
    #620 iData = 3'b100;
    end
    
    initial
    begin
    iData_a = 4'b1000; iData_b = 4'b0000;       //larger
    #100 iData_a = 4'b0000; iData_b = 4'b1000;  //smaller
    #100 iData_a = 4'b0000; iData_b = 4'b0000;  //equal
    #20
    #100 iData_a = 4'b1100; iData_b = 4'b1000;  //larger
    #100 iData_a = 4'b1100; iData_b = 4'b1110;  //samller
    #100 iData_a = 4'b0101; iData_b = 4'b0101;  //equal
    #20
    #100 iData_a = 4'b0000; iData_b = 4'b0000;  //equal+larger
    end
    
endmodule
