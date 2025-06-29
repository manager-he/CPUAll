`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 21:15:31
// Design Name: 
// Module Name: DataCompare8
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

module DataCompare1(
    input a,
    input b,
    output larger,
    output smaller,
    output equal
    );
    assign larger = a & !b;
    assign smaller = !a & b;
    assign equal = a & b | !a & !b;
endmodule


module DataCompare4(
    input [3:0] iData_a,
    input [3:0] iData_b,
    input [2:0] iData,
    output reg [2:0] oData
    );
    
    wire [3:0] larger;
    wire [3:0] smaller;
    wire [3:0] equal;
    DataCompare1 u3(.a(iData_a[3]),.b(iData_b[3]),
        .larger(larger[3]),.smaller(smaller[3]),.equal(equal[3]));   
    DataCompare1 u2(.a(iData_a[2]),.b(iData_b[2]),
        .larger(larger[2]),.smaller(smaller[2]),.equal(equal[2]));
    DataCompare1 u1(.a(iData_a[1]),.b(iData_b[1]),
        .larger(larger[1]),.smaller(smaller[1]),.equal(equal[1]));
    DataCompare1 u0(.a(iData_a[0]),.b(iData_b[0]),
        .larger(larger[0]),.smaller(smaller[0]),.equal(equal[0]));

    integer i;
    integer j;
    always @ (*)       
        begin:loop
        oData[2] = iData[2];
        oData[1] = iData[1];
        oData[0] = iData[0];
        for(i=3;i>=0;i=i-1)
        begin
            if(!equal[i])  //当高位不相等
            begin
                oData[2] = larger[i];
                oData[1] = smaller[i];
                oData[0] = equal[i];
                disable loop;  //退出循环
            end               
        end // of one for
end //of begin
endmodule


module DataCompare8(
    input [7:0] iData_a,
    input [7:0] iData_b,
    output reg [2:0] oData    
    );
    
    wire [2:0] oData_high;
    wire [2:0] oData_low;    
    
    DataCompare4 u1(.iData_a(iData_a[7:4]),.iData_b(iData_b[7:4]),
        .iData(3'b001),.oData(oData_high));
    DataCompare4 u2(.iData_a(iData_a[3:0]),.iData_b(iData_b[3:0]),
        .iData(oData_high),.oData(oData_low));
        
    always @(*)
    begin
    if(oData_high[0])
        oData = oData_low;
    else
        oData = oData_high;
    end
    
endmodule
