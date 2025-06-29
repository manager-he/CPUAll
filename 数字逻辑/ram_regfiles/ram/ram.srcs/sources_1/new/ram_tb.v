`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 18:12:23
// Design Name: 
// Module Name: ram_tb
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


module ram_tb;
    reg clk;
    reg ena;
    reg wena;
    reg [4:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    
    ram RAM(.clk(clk), .ena(ena), .wena(wena),
            .addr(addr), .data_in(data_in), .data_out(data_out));
            
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
            addr = 5'b00000; data_in = 32'h00000000;
        #30 addr = 5'b00001; data_in = 32'hAAAAAAAA;
        #10 addr = 5'b00010; data_in = 32'hBBBBBBBB;
        #10 addr = 5'b00100; data_in = 32'hCCCCCCCC;
        #10 addr = 5'b01000; data_in = 32'hDDDDDDDD;
        #10 addr = 5'b10000; data_in = 32'hEEEEEEEE;
    end
    
    initial begin
        #100 addr = 5'b00000;
        #100 addr = 5'b00001;
        #100 addr = 5'b00010;
        #100 addr = 5'b00100;
        #100 addr = 5'b01000;
        #100 addr = 5'b10000;
    end
endmodule
