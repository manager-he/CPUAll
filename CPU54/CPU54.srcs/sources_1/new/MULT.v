`timescale 1ns / 1ps

module MULT(
	input clk,
	input reset,
	input ena,
    input Signed,
    input [31:0] a, b,
    output [63:0] Z64
);
    reg _Signed;
    wire [63:0] omult, omultu;
    always @(posedge ena) _Signed = Signed;

    MULTU multu (.clk(clk), .reset(reset), .ena(ena), .a(a), .b(b), .z(omultu));
    MULTS mults (.clk(clk), .reset(reset), .ena(ena), .a(a), .b(b), .z(omult));

    // 区分有无符号运算
    wire [31:0] Z1_mul, Z1_div, Z2_mul, Z2_div;
    assign Z64 = _Signed? omult : omultu;
endmodule

module MULTU(
    input clk,      //乘法器时钟信号
    input reset,    //复位信号，高电平有效
    input ena,
    input [31:0] a, //输入数a(被乘数)
    input [31:0] b, //输入数b（乘数)
    output [63:0] z //乘积输出z
    );
    //申请寄存器
    reg [63:0] a_temp;
    reg [31:0] b_temp;
    reg [63:0] temp;
    reg [63:0] z_temp;
    reg [4:0] cnt;
    
    always @(posedge clk or posedge reset)
    begin
        //reset
        if(reset)
        begin
            a_temp=0;
            b_temp=0;
            temp=0;
            z_temp=0;
            cnt=0;
        end
        
        else if(ena)
        begin
            if(cnt==0) begin
                a_temp={32'h00000000,a};
                b_temp=b;
                temp=0;
            end
            repeat(32) begin
                if(b_temp[0])
                begin
                    temp=temp+a_temp;  //乘数最末位是1，中间值累加a_temp
                end
                a_temp=a_temp<<1;  //a左移1位
                b_temp=b_temp>>1;  //b右移1位
                
                if(cnt==31)
                begin
                    z_temp=temp;
                    cnt=0; //循环结束，乘法结束
                end
                else
                begin
                    cnt=cnt+1; //计数器
                end
            end
        end
    end
    
    assign z=z_temp;
endmodule

module MULTS(
    input clk,  //乘法器时钟信号 
    input reset,    //复位信号，高电平有效 
    input ena,
    input [31:0] a, //输入数a(被乘数) 
    input [31:0] b, //输入数b（乘数） 
    output [63:0] z //乘积输出z 
    );
    //申请寄存器
    reg [63:0] a_temp;
    reg [31:0] b_temp;
    reg [63:0] temp;
    reg sign;
    reg [63:0] z_temp;
    reg [4:0] cnt;
    
    always @(posedge clk or posedge reset) begin
        //reset
        if(reset)
        begin
            a_temp=0;
            b_temp=0;
            temp=0;
            z_temp=0;
            cnt=0;
            sign=0;
        end
        
        else if(ena)
        begin
            if(cnt==0) begin
                a_temp=!a[31]?{32'h00000000,a}:{32'h00000000,~a+1};
                b_temp=!b[31]>0?b:~b+1;
                if(!a||!b) sign=0;
                else sign=a[31]^b[31];
                temp=0;
            end
            repeat(32) begin
            if(b_temp[0])
            begin
                temp=temp+a_temp;  //乘数最末位是1，中间值累加a_temp
            end
            a_temp=a_temp<<1;  //a左移1位
            b_temp=b_temp>>1;  //b右移1位
            
            if(cnt==31)
            begin
                if(sign) z_temp=~temp+1;
                else z_temp=temp;
                cnt=0; //循环结束，乘法结束
            end
            else
            begin
                cnt=cnt+1; //计数器
            end
            end
        end
    end
    
    assign z=z_temp;
endmodule        