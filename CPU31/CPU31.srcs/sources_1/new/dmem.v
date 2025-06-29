`timescale 1ns / 1ps
module DMEM (
    input clk, rst, en, we,
    input [31:0] addr, wdata,
    output [31:0] rdata
);
parameter MEMNUM = 31;
reg [31:0] mem [MEMNUM:0];

assign rdata = en && !we ? mem[addr] : 32'bz;

// init memory
integer i;
always @(posedge rst or posedge clk) begin
    if(rst) begin
        for (i = 0; i <= MEMNUM; i = i + 1) begin
            mem[i] = 0;
        end
    end
    else if(en && we) mem[addr] = wdata;
end

// always @(posedge rst) begin
//     for (i = 0; i <= MEMNUM; i = i + 1) begin
//         mem[i] = 0;
//     end
// end

// always @(negedge clk) begin
//     if(en && we && !rst) mem[addr] = wdata;
// end
    
endmodule