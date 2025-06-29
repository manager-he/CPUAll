`timescale 1ns / 1ps
module Divider (
    input clk, rst,
    output clk_output
);
    
reg clk_out;
assign clk_output = clk_out;

reg [31:0] cnt = 0;
parameter portion = 32'd10000000;

always @(posedge clk) 
begin 
    if(rst) begin
      cnt <= 0;
      clk_out <= 0;  
    end
    else if(cnt == portion)  begin 
        clk_out <= ~clk_out; 
        cnt <= 0; 
    end 
    else cnt <= cnt + 1; 
end
endmodule