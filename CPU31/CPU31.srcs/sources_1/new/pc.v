`timescale 1ns / 1ps
module PC (
    input clk, rst,
    input [31:0] next_pc,
    output [31:0] current_pc
);
    reg [31:0] RegPC;

    always @(posedge rst or posedge clk) begin
        if(rst) RegPC <= 32'h00400000;
        else RegPC <= next_pc;
    end

    // init
    // always @(posedge rst) begin
    //     RegPC = 32'h00400000;
    // end

    // next
    // always @(posedge clk) begin
    //     if(!rst) RegPC = next_pc;
    // end

    assign current_pc = RegPC;
endmodule