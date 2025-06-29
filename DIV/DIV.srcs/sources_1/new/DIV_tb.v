`timescale 1ns / 1ps

module DIV_tb;
    reg [31:0]dividend;
    reg [31:0]divisor;
    reg start;
    reg clock;
    reg reset;
    wire [31:0]q;
    wire [31:0]r;
    wire busy;
    
    DIV uut(dividend, divisor, start, clock, reset, q, r, busy);
    
    parameter clk_cnt = 500, clk_period = 2;
    initial begin  
        clock = 0;  
        repeat(clk_cnt)  
            #(clk_period/2) clock = ~clock;  
    end
    
    parameter cal = clk_period * 32;
    initial begin 
        reset = 1; start = 0;
        #5 reset = 0;
   end
        
    initial begin    
        #5 start = 1; dividend = 0; divisor = 32'hffffffff;
        #5 start = 0;
        #cal start = 1; dividend = 32'h00000007; divisor = 32'h00000002;
        #5 start = 0;
        #cal start = 1; dividend = 32'h00000007; divisor = 32'hfffffffe;
        #5 start = 0;
        #cal start = 1; dividend = 32'h7fffffff; divisor = 32'h55555555;
        #5 start = 0;
        #cal start = 1; dividend = 32'h7fffffff; divisor = 32'h7fffffff;
        #5 start = 0;
        #cal;
    end

endmodule
