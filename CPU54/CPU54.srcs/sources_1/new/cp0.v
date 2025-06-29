`timescale 1ns / 1ps
module CP0(
	input clk,
	input rst,
	input mfc0, //CPU instruction is Mfc0
	input mtc0, //CPU instruction is Mtc0
	input [31:0] pc,
	input [4:0] Rd, //Specifies CP0 register
	input [31:0] wdata, //wdata from GP register to replace CP0 register
	input exception, 
	input eret, //instruction is ERET(Exception Return)
	input [4:0] cause,

	output [31:0] rdata, //wdata from CP0 register for GP register
	output [31:0] status,
    output reg timer_int, // ????¡Á¡Â??¡ã???
	output [31:0] exc_addr //address for PC output [31:0]exc_addr // address for PC at the beginning of an exception
);
    reg [31:0] CP0_reg [0:31];
    reg [31:0] next_pc;
    assign status = CP0_reg[12];

    parameter EXC_syscall=5'b01000,EXC_break=5'b01001,EXC_teq=5'b01101;
    parameter EXC_PC=32'h00400004;  // ?????
    always @(posedge clk or posedge rst)
    begin
        if(rst) begin
            CP0_reg[12]<=32'h00000701;
            CP0_reg[13]<=32'h0;
            CP0_reg[14]<=32'h0;
            next_pc<=32'h0;
        end
        else begin
            if(mtc0) CP0_reg[Rd] <= wdata;
            else if(exception) begin  //SYSCALL,BREAK,TEQ
                case(cause)
                    EXC_syscall: begin
                        if(CP0_reg[12][0]&~CP0_reg[12][8]) begin
                            next_pc<=EXC_PC;
                            CP0_reg[12]<=CP0_reg[12]<<5;
                            CP0_reg[14]<=pc;
                            CP0_reg[13][6:2]<=cause;
                        end
                        else next_pc<=pc; 
                    end
                    EXC_break: begin
                        if(CP0_reg[12][0]&~CP0_reg[12][9]) begin
                            next_pc<=EXC_PC;
                            CP0_reg[12]<=CP0_reg[12]<<5;
                            CP0_reg[14]<=pc;
                            CP0_reg[13][6:2]<=cause;
                        end
                        else next_pc<=pc; 
                    end
                    EXC_teq: begin
                        if(CP0_reg[12][0]&~CP0_reg[12][10]) begin
                            next_pc<=EXC_PC;
                            CP0_reg[12]<=CP0_reg[12]<<5;
                            CP0_reg[14]<=pc;
                            CP0_reg[13][6:2]<=cause;
                        end
                        else next_pc<=pc; 
                    end
                    default:;
                endcase
            end
            else if(eret) begin
                CP0_reg[12] <= (CP0_reg[12] >> 5);
                next_pc <= CP0_reg[14];
            end
        end
    end
    assign exc_addr = next_pc;    // EXC_PC
    assign rdata = mfc0 ? CP0_reg[Rd] : 32'hzzzzzzzz;
endmodule