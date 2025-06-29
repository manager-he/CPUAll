module ADD (
    input [31:0] A, B,
    output [31:0] F
);
    assign F = A + B;
endmodule

module NPC (
    input [31:0] pc,
    output [31:0] next_pc
);
    assign next_pc = pc + 4;
endmodule