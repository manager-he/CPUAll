`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 18:41:15
// Design Name: 
// Module Name: FA
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


module FA(
    input iA,
    input iB,
    input iC,
    output oS,
    output oC
    );
    wire r1,r2,r3;
    xor (oS,iA,iB,iC);
    and (r1,iA,iB);
    and (r2,iB,iC);
    and (r3,iA,iC);
    or (oC,r1,r2,r3);
endmodule
