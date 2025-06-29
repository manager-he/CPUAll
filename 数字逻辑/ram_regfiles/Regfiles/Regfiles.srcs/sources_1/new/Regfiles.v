`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 18:03:37
// Design Name: 
// Module Name: Regfiles
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


module Regfiles(
    input clk,
    input rst,
    input we,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,
    output [31:0] rdata1,
    output [31:0] rdata2
    );
    /*
    reg [31:0] regfiles [31:0];
    integer i = 0;
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            for(;i<32;i=i+1) regfiles[i] <= 32'b0;
        end
        else begin
            if(we) //write
                regfiles[waddr] <= wdata;
            else begin
                rdata1 <= regfiles[raddr1];
                rdata2 <= regfiles[raddr2];
            end
        end
    end*/
    wire [31:0] coding;
    wire [31:0] ram [31:0];
    
    decoder32 d(.iData(waddr),.iEna({0,1}),.oData(coding));
    pcreg p0(.clk(clk),.rst(rst),.ena(coding[0] & we),.data_in(wdata),.data_out(ram[0]));
    pcreg p1(.clk(clk),.rst(rst),.ena(coding[1] & we),.data_in(wdata),.data_out(ram[1]));
    pcreg p2(.clk(clk),.rst(rst),.ena(coding[2] & we),.data_in(wdata),.data_out(ram[2]));
    pcreg p3(.clk(clk),.rst(rst),.ena(coding[3] & we),.data_in(wdata),.data_out(ram[3]));
    pcreg p4(.clk(clk),.rst(rst),.ena(coding[4] & we),.data_in(wdata),.data_out(ram[4]));
    pcreg p5(.clk(clk),.rst(rst),.ena(coding[5] & we),.data_in(wdata),.data_out(ram[5]));
    pcreg p6(.clk(clk),.rst(rst),.ena(coding[6] & we),.data_in(wdata),.data_out(ram[6]));
    pcreg p7(.clk(clk),.rst(rst),.ena(coding[7] & we),.data_in(wdata),.data_out(ram[7]));
    pcreg p8(.clk(clk),.rst(rst),.ena(coding[8] & we),.data_in(wdata),.data_out(ram[8]));
    pcreg p9(.clk(clk),.rst(rst),.ena(coding[9] & we),.data_in(wdata),.data_out(ram[9]));
    pcreg p10(.clk(clk),.rst(rst),.ena(coding[10] & we),.data_in(wdata),.data_out(ram[10]));
    pcreg p11(.clk(clk),.rst(rst),.ena(coding[11] & we),.data_in(wdata),.data_out(ram[11]));
    pcreg p12(.clk(clk),.rst(rst),.ena(coding[12] & we),.data_in(wdata),.data_out(ram[12]));
    pcreg p13(.clk(clk),.rst(rst),.ena(coding[13] & we),.data_in(wdata),.data_out(ram[13]));
    pcreg p14(.clk(clk),.rst(rst),.ena(coding[14] & we),.data_in(wdata),.data_out(ram[14]));
    pcreg p15(.clk(clk),.rst(rst),.ena(coding[15] & we),.data_in(wdata),.data_out(ram[15]));
    pcreg p16(.clk(clk),.rst(rst),.ena(coding[16] & we),.data_in(wdata),.data_out(ram[16]));
    pcreg p17(.clk(clk),.rst(rst),.ena(coding[17] & we),.data_in(wdata),.data_out(ram[17]));
    pcreg p18(.clk(clk),.rst(rst),.ena(coding[18] & we),.data_in(wdata),.data_out(ram[18]));
    pcreg p19(.clk(clk),.rst(rst),.ena(coding[19] & we),.data_in(wdata),.data_out(ram[19]));
    pcreg p20(.clk(clk),.rst(rst),.ena(coding[20] & we),.data_in(wdata),.data_out(ram[20]));
    pcreg p21(.clk(clk),.rst(rst),.ena(coding[21] & we),.data_in(wdata),.data_out(ram[21]));
    pcreg p22(.clk(clk),.rst(rst),.ena(coding[22] & we),.data_in(wdata),.data_out(ram[22]));
    pcreg p23(.clk(clk),.rst(rst),.ena(coding[23] & we),.data_in(wdata),.data_out(ram[23]));
    pcreg p24(.clk(clk),.rst(rst),.ena(coding[24] & we),.data_in(wdata),.data_out(ram[24]));
    pcreg p25(.clk(clk),.rst(rst),.ena(coding[25] & we),.data_in(wdata),.data_out(ram[25]));
    pcreg p26(.clk(clk),.rst(rst),.ena(coding[26] & we),.data_in(wdata),.data_out(ram[26]));
    pcreg p27(.clk(clk),.rst(rst),.ena(coding[27] & we),.data_in(wdata),.data_out(ram[27]));
    pcreg p28(.clk(clk),.rst(rst),.ena(coding[28] & we),.data_in(wdata),.data_out(ram[28]));
    pcreg p29(.clk(clk),.rst(rst),.ena(coding[29] & we),.data_in(wdata),.data_out(ram[29]));
    pcreg p30(.clk(clk),.rst(rst),.ena(coding[30] & we),.data_in(wdata),.data_out(ram[30]));
    pcreg p31(.clk(clk),.rst(rst),.ena(coding[31] & we),.data_in(wdata),.data_out(ram[31]));
    
    assign rdata1 = !we? ram[raddr1] : rdata1 ;
    assign rdata2 = !we? ram[raddr2] : rdata1 ;
    /*
    always @(*) begin
        if(!we) begin //read
            rdata1 = ram[raddr1];
            rdata2 = ram[raddr2];
        end
    end*/
    
endmodule
