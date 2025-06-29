`timescale 1ns / 1ps
// 用在IR,Z,HI,LO上
module REG(
	input clk, rst, wena,
	input [31:0] data_in,
	output [31:0] data_out
);
	reg [31:0] _reg;
	always @(posedge clk or posedge rst)
	begin
		if(rst) _reg <= 32'h0;
		else if(wena) _reg <= data_in;
	end
	assign data_out = _reg;
endmodule
// PCreg初始化的值有要求
module PC (
    input clk, rst, wena,
    input [31:0] next_pc,
    output [31:0] current_pc
);
    reg [31:0] RegPC, PC_EXE;

    always @(posedge rst or posedge clk) begin
        if(rst) begin 
			RegPC <= 32'h00400000;
			PC_EXE <= 32'h00400000;
		end
        else if(wena) begin 
			PC_EXE = RegPC;
			RegPC = next_pc;
		end
    end
    assign current_pc = RegPC;
endmodule

module PRINT (
    input clk, rst,
    input [31:0] next_pc, ir_out,
    output [31:0] pc_finished, inst_finished
);
    reg [31:0] PC_FINISHED, PC_EXE, INST_EXE, INST_FINISHED;

    always @(posedge rst or posedge clk) begin
        if(rst) begin 
			PC_FINISHED <= 32'h00400000;
			PC_EXE <= 32'h00400000;
			INST_EXE <= 32'h08100004;
			INST_FINISHED <= 32'h08100004;
		end
        else begin 
			PC_FINISHED = PC_EXE;
			PC_EXE = next_pc;
			// INST_FINISHED = ir_out;
			INST_FINISHED = INST_EXE;
			INST_EXE = ir_out;
		end
    end
    assign pc_finished = PC_EXE;	// - 32'h00400000;
	assign inst_finished = INST_EXE;
endmodule