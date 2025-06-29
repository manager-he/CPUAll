`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 18:05:32
// Design Name: 
// Module Name: ram2
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


module ram2(
    input clk,
    input ena,
    input wena,
    input [4:0] addr,
    inout [31:0] data
    );
    reg [31:0] temp;
    reg [31:0] ram[31:0];
    always @(posedge clk or negedge ena) begin
        if(!ena) temp <= 32'bz;
        else begin
            if(wena) //write
                ram[addr] <= temp;
            else //read
                temp <= ram[addr];
        end
    end
    assign data = temp;
endmodule
