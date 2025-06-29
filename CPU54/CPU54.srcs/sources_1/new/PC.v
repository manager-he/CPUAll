`timescale 1ns / 1ps

module PC(                  //PC寄存器，同步写入（时钟上升沿），异步读取
    input clk,
    input rst,              //复位信号，高电平有效
    input wena,
    input [31:0] iData,     //32位输入数据（下一次执行指令地址）
    output [31:0] oData     //32位输出数据（本次执行指令地址）
//    output [31:0] pc_pre
    );
    reg [31:0] oData_t,PC_EXC;
    
    always @ (posedge clk or posedge rst) begin //时钟上升沿写入，复位信号上升沿有效
        if(rst) begin
            oData_t = 32'h00400000;
            PC_EXC = 32'h00400000;
//            oData_t <= 32'h00000000;
//            PC_EXC <= 32'h00000000;
        end
        else if(wena) begin
            PC_EXC = oData_t;
            oData_t = iData;
        end
    end
    
    assign oData = oData_t;   //随时可以读取数据
//    assign pc_pre = PC_EXC;
endmodule

//module NPC(                  //PC寄存器，同步写入（时钟上升沿），异步读取
//    input clk,
//    input rst,              //复位信号，高电平有效
//    input wena,
//    input [31:0] iData,     //32位输入数据（下一次执行指令地址）
//    output [31:0] oData,     //32位输出数据（本次执行指令地址）
//    output [31:0] PC_EXC
//    );
//    reg [31:0] oData_t,PC_EXC;
    
//    always @ (posedge clk or posedge rst) begin //时钟上升沿写入，复位信号上升沿有效
//        if(rst) begin
//            oData_t <= 32'h00400000;
//            PC_EXC <= 32'h00400000;
////            oData_t <= 32'h00000000;
////            PC_EXC <= 32'h00000000;
//        end
//        else if(wena) begin
//            PC_EXC <= oData_t;
//            oData_t <= iData;
//        end
//    end
    
//    assign oData = oData_t;   //随时可以读取数据
//endmodule
