`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 20:06:49
// Design Name: 
// Module Name: Counter8
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


module Counter8(
    input CLK,
    input rst_n,
    output [2:0] oQ,
    output [6:0] oDisplay
    );
    wire [3:0] iData;
    
    JK_FF uut1(.CLK(CLK),.J(1),.K(1),.RST_n(rst_n),.Q(oQ[0]));
    JK_FF uut2(.CLK(CLK),.J(oQ[0]),.K(oQ[0]),.RST_n(rst_n),.Q(oQ[1]));
    JK_FF uut3(.CLK(CLK),.J(oQ[0]&oQ[1]),.K(oQ[0]&oQ[1]),.RST_n(rst_n),.Q(oQ[2]));
    
    assign iData[3] = 0;
    assign iData[2] = oQ[2];
    assign iData[1] = oQ[1];
    assign iData[0] = oQ[0];
    display7 uut(.iData(iData),.oData(oDisplay));   
    
    
    /*
    reg [2:0] oQ1;
    assign oQ = oQ1;
    wire [3:0] iData;
    
    always @(posedge CLK or negedge rst_n) begin
        if(rst_n == 0) 
            oQ1 <= 3'b000;
        else begin
            if(oQ1 == 3'b111) 
                oQ1 <= 0;
            else
                oQ1 <= oQ1 + 1;
        end
    end
    assign iData[3] = 0;
    assign iData[2] = oQ[2];
    assign iData[1] = oQ[1];
    assign iData[0] = oQ[0];
    display7 uut(.iData(iData),.oData(oDisplay));
    */
endmodule
