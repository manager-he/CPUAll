`timescale 1ns / 1ps
module DMEM (
    input clk, rst, en, we,
    input [31:0] addr, wdata,
    input DM_bit, DM_halfw, DM_word, 
    input DM_signed,
    output [31:0] rdata
);
parameter MEMNUM = 200;
reg [7:0] mem [MEMNUM:0];

wire [7:0] data8;
assign data8 = mem[addr];
wire [15:0] data16;
assign data16 = {mem[addr+1], mem[addr]};
wire [31:0] data32;
assign data32 = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

wire [31:0] data_bit, data_halfw;
assign data_bit = DM_signed? {{24{data8[7]}}, data8} : {24'b0, data8};
assign data_halfw = DM_signed? {{16{data16[15]}}, data16} : {16'b0, data16};
// data_word = data32

assign rdata = !en || we? 32'bz : 
                DM_bit ? data_bit : DM_halfw ? data_halfw : data32;

// init memory
integer i;
always @(posedge rst or posedge clk) begin
    if(rst) begin
        for (i = 0; i <= MEMNUM; i = i + 1) begin
            mem[i] = 0;
        end
    end
    else if(en && we) begin // ?????¨°
            if(DM_bit || DM_halfw || DM_word) mem[addr] = wdata[7:0];
            if(DM_halfw || DM_word) mem[addr+1] = wdata[15:8];
            if(DM_word) begin 
                mem[addr+2] = wdata[23:16];
                mem[addr+3] = wdata[31:24]; end
        end    
end

    
endmodule