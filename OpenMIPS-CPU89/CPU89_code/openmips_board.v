`timescale 1ns / 1ps

module openmips_board(
    input clk_in,       // 输入时钟
    input reset,        // 复位信号
    output [7:0] o_seg, 
    output [7:0] o_sel
    );
    
    wire clk_seg, clk_cpu;
    wire [31:0] result;   

    divider#(4) div_seg (clk_in, reset, clk_seg);
    divider#(100000) div_cpu (clk_in, reset, clk_cpu);

    seg7x16 seg7 (clk_seg, reset, result, o_seg, o_sel);

    openmips_min_sopc openmips_min_sopc_board(clk_cpu, reset, result);
    
endmodule


module divider#(parameter num = 2)(
    input I_CLK,
    input rst,
    output reg O_CLK
    );
    integer i = 0;
    always @ (posedge I_CLK or posedge rst) begin
        if(rst == 1) begin
            O_CLK <= 0; i <= 0; end
        else begin
            if(i == num - 1) begin
                O_CLK <= ~O_CLK; i <= 0; end
            else begin
                i <= i + 1; end
        end
    end
endmodule