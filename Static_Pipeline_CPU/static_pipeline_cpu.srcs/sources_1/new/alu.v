`timescale 1ns / 1ps
module ALU (
    input [15:0] A, B,
    input [1:0] ALUC,
    output [15:0] F,
    output Z, N, C, O
);

parameter ADD   = 2'b00;
parameter SUB   = 2'b01;
parameter SRL   = 2'b10;

wire signed [15:0] S_A, S_B;
assign S_A = A;
assign S_B = B;

reg [16:0] res;

always @(*) begin
        case (ALUC)
            ADD:    res = S_A + S_B;
            SUB:    res = S_A - S_B;
            SRL:    res = A >> B;            
            default: $display("Invalid Control Signal");
        endcase
    end

    assign F = res[15:0];
    assign Z = (res[15:0] == 0) ? 1 : 0;
    assign N = res[15];
    assign C = res[16];
    assign O = res[16];

endmodule