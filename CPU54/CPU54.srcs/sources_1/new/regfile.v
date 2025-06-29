`timescale 1ns / 1ps

module regfile(         //寄存器堆
    input clk,
    input rst,          //复位信号，高电平有效
    input wena,          //写入信号，高电平有效
    input [4:0] Rsc,    //5位，Rs寄存器的地址
    input [4:0] Rtc,    //5位，Rt寄存器的地址
    input [4:0] Rdc,    //5位，Rd寄存器的地址
    input [31:0] Rd,    //32位，Rd寄存器的输入数据
    output [31:0] Rs,   //32位，Rs寄存器的输出数据
    output [31:0] Rt    //32位，Rt寄存器的输出数据
    );
    reg [31:0] array_reg [31:0];    //定义寄存器堆
    
    always @ (posedge clk or posedge rst) begin
        if(rst) begin    //只有启用寄存器堆后才能清空
            array_reg[0] <= 32'b0;
            array_reg[1] <= 32'b0;
            array_reg[2] <= 32'b0;
            array_reg[3] <= 32'b0;
            array_reg[4] <= 32'b0;
            array_reg[5] <= 32'b0;
            array_reg[6] <= 32'b0;
            array_reg[7] <= 32'b0;
            array_reg[8] <= 32'b0;
            array_reg[9] <= 32'b0;
            array_reg[10] <= 32'b0;
            array_reg[11] <= 32'b0;
            array_reg[12] <= 32'b0;
            array_reg[13] <= 32'b0;
            array_reg[14] <= 32'b0;
            array_reg[15] <= 32'b0;
            array_reg[16] <= 32'b0;
            array_reg[17] <= 32'b0;
            array_reg[18] <= 32'b0;
            array_reg[19] <= 32'b0;
            array_reg[20] <= 32'b0;
            array_reg[21] <= 32'b0;
            array_reg[22] <= 32'b0;
            array_reg[23] <= 32'b0;
            array_reg[24] <= 32'b0;
            array_reg[25] <= 32'b0;
            array_reg[26] <= 32'b0;
            array_reg[27] <= 32'b0;
            array_reg[28] <= 32'b0;
            array_reg[29] <= 32'b0;
            array_reg[30] <= 32'b0;
            array_reg[31] <= 32'b0;
        end
        else if(wena && (Rdc != 5'b0))  //启用寄存器堆且写数据
        //0号寄存器常0，不允许修改，不在写入范围之内
            array_reg[Rdc] <= Rd;
    end
    
    assign Rs = array_reg[Rsc];
    assign Rt = array_reg[Rtc]; 
endmodule
