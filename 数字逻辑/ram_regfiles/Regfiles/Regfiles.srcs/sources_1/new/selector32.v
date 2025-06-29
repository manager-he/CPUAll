`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 13:25:45
// Design Name: 
// Module Name: selector32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module selector32(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input [31:0] iC4,
    input [31:0] iC5,
    input [31:0] iC6,
    input [31:0] iC7,
    input [31:0] iC8,
    input [31:0] iC9,
    input [31:0] iC10,
    input [31:0] iC11,
    input [31:0] iC12,
    input [31:0] iC13,
    input [31:0] iC14,
    input [31:0] iC15,
    input [31:0] iC16,
    input [31:0] iC17,
    input [31:0] iC18,
    input [31:0] iC19,
    input [31:0] iC20,
    input [31:0] iC21,
    input [31:0] iC22,
    input [31:0] iC23,
    input [31:0] iC24,
    input [31:0] iC25,
    input [31:0] iC26,
    input [31:0] iC27,
    input [31:0] iC28,
    input [31:0] iC29,
    input [31:0] iC30,
    input [31:0] iC31,
    input [31:0] iC32,    
    input [4:0] iS,
    input ena,
    output reg [32:0] oZ
    );
    always @(*) begin
        if(~ena)
            oZ = 32'bz;
        else begin
            if (iS == 0) oZ = iC0;
            else if (iS == 1) oZ = iC1;
            else if (iS == 2) oZ = iC2;
            else if (iS == 3) oZ = iC3;
            else if (iS == 4) oZ = iC4;
            else if (iS == 5) oZ = iC5;
            else if (iS == 6) oZ = iC6;
            else if (iS == 7) oZ = iC7;
            else if (iS == 8) oZ = iC8;
            else if (iS == 9) oZ = iC9;
            else if (iS == 10) oZ = iC10;
            else if (iS == 11) oZ = iC11;
            else if (iS == 12) oZ = iC12;
            else if (iS == 13) oZ = iC13;
            else if (iS == 14) oZ = iC14;
            else if (iS == 15) oZ = iC15;
            else if (iS == 16) oZ = iC16;
            else if (iS == 17) oZ = iC17;
            else if (iS == 18) oZ = iC18;
            else if (iS == 19) oZ = iC19;
            else if (iS == 20) oZ = iC20;
            else if (iS == 21) oZ = iC21;
            else if (iS == 22) oZ = iC22;
            else if (iS == 23) oZ = iC23;
            else if (iS == 24) oZ = iC24;
            else if (iS == 25) oZ = iC25;
            else if (iS == 26) oZ = iC26;
            else if (iS == 27) oZ = iC27;
            else if (iS == 28) oZ = iC28;
            else if (iS == 29) oZ = iC29;
            else if (iS == 30) oZ = iC30;
            else if (iS == 31) oZ = iC31;
        end
    end
endmodule
