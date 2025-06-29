module Ext5 (
    input [4:0] din,
    output [31:0] dout
);
    assign dout = {26'h0000000, din};
endmodule

module Ext16 (
    input [15:0] din,
    output [31:0] dout
);
    assign dout = {16'h0000, din};
endmodule

module S_Ext16 (
    input [15:0] din,
    output [31:0] dout
);
    assign dout = din[15] ? {16'hffff, din} : {16'h0000, din};
endmodule

module S_Ext18 (
    input [17:0] din,
    output [31:0] dout
);
    assign dout = din[17] ? {14'hffff, din} : {14'h0000, din};
endmodule