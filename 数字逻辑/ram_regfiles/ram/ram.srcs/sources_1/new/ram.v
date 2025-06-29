`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 18:00:19
// Design Name: 
// Module Name: ram
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


module ram(
    input clk,
    input ena,
    input wena,
    input [4:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out = 32'b0
    );
    reg [31:0] ram[31:0];
    always @(posedge clk or negedge ena) begin
        if(!ena) data_out <= 32'bz;
        else begin
            if(wena) //write
                ram[addr] <= data_in;
            else //read
                data_out <= ram[addr];
        end
    end
endmodule
