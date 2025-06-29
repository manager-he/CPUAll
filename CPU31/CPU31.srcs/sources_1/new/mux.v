module MUX32 (
    input en,
    input [31:0] a, b,
    output [31:0] out
);
    assign out = (en == 0) ? a : b;
endmodule

module MUX5 (
    input en,
    input [4:0] a, b,
    output [4:0] out
);
    assign out = (en == 0) ? a : b;
endmodule