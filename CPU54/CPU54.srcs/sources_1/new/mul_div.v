`timescale 1ns / 1ps

module MUL_DIV(
	input clk, reset, MD_wena,
    input Mul, Signed,
    input [31:0] X, Y,
    output [31:0] Z1, Z2,
    output busy
);
    reg _Mul, _Signed;
    always @(posedge MD_wena) begin
        _Mul = Mul;
        _Signed = Signed;
    end
    // MULT & MULTU
    wire [63:0] mult_res, multu_res;
    MULT    _mult   (.clk(clk), .reset(reset), .wena(MD_wena), .a(X), .b(Y), .z(mult_res));
    MULTU   _multu  (.clk(clk), .reset(reset), .wena(MD_wena), .a(X), .b(Y), .z(multu_res));

    // DIV & DIVU
    wire [31:0] div_q, div_r, divu_q, divu_r;
    wire div_busy, divu_busy;
    DIV     _div    (.clock(clk), .reset(reset), .start(MD_wena), .dividend(X), .divisor(Y), .q(div_q), .r(div_r), .busy(div_busy));
    DIVU   _divu    (.clock(clk), .reset(reset), .start(MD_wena), .dividend(X), .divisor(Y), .q(divu_q), .r(divu_r), .busy(divu_busy));

    // sort by signed
    wire [31:0] Z1_mul, Z1_div, Z2_mul, Z2_div;
    assign Z1_mul = _Signed? mult_res[63:32] : multu_res[63:32];
    assign Z2_mul = _Signed? mult_res[31:0] : multu_res[31:0];
    assign Z1_div = _Signed? div_r : divu_r;
    assign Z2_div = _Signed? div_q : divu_q;
    // sort by mul or div
    assign Z1 = _Mul? Z1_mul : Z1_div;
    assign Z2 = _Mul? Z2_mul : Z2_div;

    assign busy = div_busy | divu_busy;
endmodule

module MULT(
	input clk, reset, wena,
    input [31:0] a, b,
    output [63:0] z
);
    
    reg signed [32:0] A;		// 部分和（高位） 符号位参与运算，所以不考虑溢出
    reg signed [32:0] X;		// 被乘数，拓展符号位
    reg [32:0] C;		// 存储乘数（低位）-- 最后一位补充位
    reg [32:0] part;	// 存储部分积
    reg [63:0] temp;	
    integer cnt = 0; 

    // 方法二
    // Booth
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            A = 0;
            X = 0;
            C = 0;
            temp = 0;
            cnt = 0;
        end
        else if(wena) begin
            repeat(32) begin
                if(cnt == 0) begin
                    A = 0;
                    C = {b,1'b0};
                    X = {a[31],a};                
                end
                if(C[1:0]==2'b10) A = A + (~X + 1'b1);	
                else if(C[1:0]==2'b01) A = A + X;
                C = {A[0], C[32:1]};
                A = A >>> 1;
                cnt = cnt + 1;            
            end
            if(cnt == 32) temp = {A[31:0], C[32:1]};
            cnt = 0;
        end
        
    end
    assign z = temp;
    
endmodule


module MULTU(
	input clk, reset, wena, 
    input [31:0] a, b,
    output [63:0] z
);
    reg [31:0] A;		// 存储（高位）-- 33位
    reg [31:0] C;		// 存储乘数（低位）
    reg [32:0] part;	// 存储部分积
    reg [63:0] temp;	
    integer cnt = 0;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            A = 0;
            C = 0;
            temp = 0;
            cnt = 0;
        end
        else if(wena) begin            
            if(1) begin // cnt == 0
                C = b;
                A = 0;                      
                temp = 0;
            end
            repeat(32) begin
                if(C[0])  part = A + a;
                else part = A;
                
                C = {part[0], C[31:1]};  
                A = part[32:1];
                // cnt = cnt + 1;                        
            end  
            temp = {A, C};   
        end
	    // cnt = 0;
        // temp = {A, C};        
    end
    assign z = temp;
    
endmodule

module DIV(
    input [31:0] dividend, divisor,
    input start, clock, reset,
    output [31:0]q, r,
    output reg busy
);
    wire sign1 = dividend[31]; // 被除数和余数的符号
    wire sign2 = divisor[31]; // 除数的符号
    
    integer count;
    reg [31:0] reg_q;    // 被除数，左移后变成商
    reg [31:0] reg_r;    // 余数
    reg [31:0] reg_b;    // 除数
    reg r_sign;         // 0 表示符号相同，减去除数
    
    always @(posedge clock or posedge reset) begin
        if (reset) begin //重置
            count = 0;
            busy = 0;
        end else begin
            if(start & !busy) begin
                reg_q = sign1? ~dividend+1 : dividend;
                reg_b = sign2? ~divisor+1 : divisor;
                // 特判被除数小于除数的情况
                if(reg_q < reg_b) begin
                    reg_q = 0; reg_r = dividend;
                    busy = 0;
                end else begin
                    reg_r = 0;
                    r_sign = 0;
                    count = 0;
                    busy = 1;
                end
            end    
            else if(busy) begin
                reg_r = {reg_r[31:0], reg_q[30]};
                reg_q = {reg_q[31], reg_q[29:0], 1'b0};
                if(r_sign==0) reg_r = reg_r + (~reg_b + 1);
                else reg_r = reg_r + reg_b;
                if(reg_r[31]==0) reg_q[0] = 1;
                if(reg_r[31]==1) r_sign = 1;
                else r_sign = 0;
                count = count + 1;
            end
            if(count == 31) begin
                if(r_sign==1) reg_r = reg_r + reg_b;    // 恢复余数
                if(sign1 ^ sign2) reg_q = ~reg_q + 1;
                if(sign1) reg_r = ~reg_r + 1;
                count = 0;
                busy = 0;
            end
        end
    end
    
    assign r = reg_r;
    assign q = reg_q;
endmodule      
    
module DIVU(
    input [31:0] dividend, divisor,
    input start, clock, reset,
    output [31:0]q, r,
    output reg busy
);

    integer count;
    reg [31:0] reg_q;    // 被除数，左移后变成商
    reg [31:0] reg_r;    // 余数
    reg [31:0] reg_b;    // 除数
    reg r_sign;
    
    wire [32:0] sub_add = r_sign?({reg_r,reg_q[31]} + {1'b0,reg_b}):({reg_r,reg_q[31]} - {1'b0,reg_b}); //加、减法器
    // 实现左移然后加或者减除数的功能

    always @ (posedge clock or posedge reset)begin
        if (reset == 1) begin //重置
            count <= 0;
            busy <= 0;
        end 
        else begin
            if (start & !busy) begin //开始除法运算，初始化
                reg_r <= 0;
                r_sign <= 0;
                reg_q <= dividend;
                reg_b <= divisor;
                count <= 0;
                busy <= 1'b1;
            end else if (busy) begin //循环操作
                reg_r <= sub_add[31:0]; //部分余数
                r_sign <= sub_add[32]; //如果为负，下次相加
                reg_q <= {reg_q[30:0],~sub_add[32]};  // 左移，低位上商
                count <= count + 1; //计数器加一
                if (count == 31) busy <= 0; //结束除法运算
            end
        end
    end
    // 输出
    assign r = r_sign? reg_r + reg_b : reg_r;
    assign q = reg_q;
endmodule

