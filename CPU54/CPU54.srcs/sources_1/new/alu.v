// `include "head.vh"
`timescale 1ns / 1ps
module ALU (
    input [31:0] A, B,
    input [3:0] ALUC,
    output [31:0] F,
    output Z, N, C, O
);
    parameter ADD   = 4'b0000;
    parameter ADDU  = 4'b1000;
    parameter SUB   = 4'b0100;
    parameter SUBU  = 4'b1100;
    parameter AND   = 4'b0010;
    parameter OR    = 4'b1010;
    parameter XOR   = 4'b0110;
    parameter NOR   = 4'b1110;

    parameter SLT   = 4'b0001;
    parameter SLTU  = 4'b1001;

    parameter SLL   = 4'b0101;
    parameter SRL   = 4'b1101;
    parameter SRA   = 4'b0011;
    
    parameter LUI   = 4'b1011;
    parameter CLZ   = 4'b1111;

    wire signed [31:0] S_A, S_B;
    assign S_A = A;
    assign S_B = B;

    reg [32:0] res;

    always @(*) begin
        case (ALUC)
            ADD:    res = S_A + S_B;
            ADDU:   res = A + B;
            SUB:    res = S_A - S_B;
            SUBU:   res = A - B;
            AND:    res = A & B;
            OR:     res = A | B;
            XOR:    res = A ^ B;
            NOR:    res = ~(A | B);
            SLT:    res = (S_A < S_B) ? 1 : 0;
            SLTU:   res = (A < B) ? 1 : 0;
            SLL:    res = B << A;
            SRL:    res = B >> A;
            SRA:    res = S_B >>> S_A;
            LUI:    res = {B[15:0], 16'h0000};
            CLZ:    res = A[31]==1?0:A[30]==1?1:A[29]==1?2:A[28]==1?3:A[27]==1?4:
                        A[26]==1?5:A[25]==1?6:A[24]==1?7:A[23]==1?8:A[22]==1?9:
                        A[21]==1?10:A[20]==1?11:A[19]==1?12:A[18]==1?13:A[17]==1?14:
                        A[16]==1?15:A[15]==1?16:A[14]==1?17:A[13]==1?18:A[12]==1?19:
                        A[11]==1?20:A[10]==1?21:A[9]==1?22:A[8]==1?23:A[7]==1?24:
                        A[6]==1?25:A[5]==1?26:A[4]==1?27:A[3]==1?28:A[2]==1?29:
                        A[1]==1?30:A[0]==1?31:32;
            default: $display("Invalid Control Signal");
        endcase
    end

    assign F = res[31:0];
    assign Z = (res[31:0] == 0) ? 1 : 0;
    assign N = res[31];
    assign C = res[32];
    assign O = res[32];

endmodule