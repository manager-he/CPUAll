// `include "head.vh"

module ALU (
    input [31:0] A, B,
    input [3:0] ALUC,
    output [31:0] F,
    output Z, C, N, O
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
            default: $display("Invalid Control Signal");
        endcase
    end

    assign F = res[31:0];
    assign Z = (res[31:0] == 0) ? 1 : 0;
    assign C = res[32];
    assign N = res[31];
    assign O = res[32];

endmodule