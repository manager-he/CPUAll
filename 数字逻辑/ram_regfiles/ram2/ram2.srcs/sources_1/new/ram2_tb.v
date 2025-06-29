`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 19:08:08
// Design Name: 
// Module Name: ram2_tb
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


module ram2_tb;
    reg clk;
    reg ena;
    reg wena;
    reg [4:0] addr;
    reg [31:0] data;
    
    ram2 RAM2(.clk(clk), .ena(ena), .wena(wena),
        .addr(addr), .data(data));
        
    initial  begin
        clk = 0;
    end
    always #2 clk = ~clk;
    
    initial begin
        ena = 0; wena = 0;
        #20 ena = 1;        
        wena = 1;        //write
        #80
        wena = 0;       //100ms->read
    end
    
    initial begin        
            addr = 5'b00000; data = 32'h00000000;
        #100 addr = 5'b00001; data = 32'hAAAAAAAA;
        #10 addr = 5'b00010; data = 32'hBBBBBBBB;
        #10 addr = 5'b00100; data = 32'hCCCCCCCC;
        #10 addr = 5'b01000; data = 32'hDDDDDDDD;
        #10 addr = 5'b10000; data = 32'hEEEEEEEE;
    end
    
    initial begin
        #10 addr = 5'b00000;
        #10 addr = 5'b00001;
        #10 addr = 5'b00010;
        #10 addr = 5'b00100;
        #10 addr = 5'b01000;
        #10 addr = 5'b10000;
    end
    
endmodule
