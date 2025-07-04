`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 21:48:03
// Design Name: 
// Module Name: alu_tb
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


module ALU_tb();
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] aluc;
    wire [31:0] r;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    
    alu ALU(.a(a), .b(b), .aluc(aluc), .r(r), .zero(zero), .carry(carry), .negative(negative), .overflow(overflow));
    
    
        //ADDU
        /*initial
            begin
                //ADDU
                aluc = 4'b0000;
                a = 15;   b = 16;
                #40
                a = 5;     b = 7;               
               
            end*/
        
       /*
        initial
        begin
            //ADD
            aluc = 4'b0010;
            a = -5;  b = 15;            
            #40
            a = 10;  b = 15;            
            #40
            a = -15; b = -17;            
            #40 
            a = 32'b0;  b = 32'b0;            
        end*/
        
        /*
        initial
            begin
                //SUBU
                aluc = 4'b0001;  a = 20;  b = 15;
                #40
                a = 100;  b = 99;
                #40
                a = 5;  b = 10;                
            end
        */
        /*
        initial
        begin
            //SUB
            aluc = 4'b0011;a = 20; b = 10;
            
            #40 
            a = -5; b = -8;
            
            #40
            a = -7;b = -5;
        
        end
        */
        
       /*
            initial
            begin
                //AND OR XOR NOR 
                a = 32'b10001000100010001000100010001110;
                b = 32'b01001000110010011000100010001110;
                
                aluc = 4'b0100;
                #40 aluc = 4'b0101;
                #40 aluc = 4'b0110;
                #40 aluc = 4'b0111;
    
            end
    */        
        /*
            initial
            begin
                //LUI
                aluc = 4'b1001;
                a = 32'b1;
                b = 32'b1;
                
                aluc = 4'b1000;
                a = 32'b1;
                b = 32'b1;
                            
            
            end
          */  
            
            /* initial
            begin
                //SLT, SLTU
                aluc = 4'b1011;
                a = 32'hffffffff;
                b = 32'h80000000;
                
                #40 
                aluc = 4'b1110;
                a = 32'h00000008;
                b = 32'hffffffff;
                
                #40 
                a = 5;
                b = 10;
            end */
       initial
       begin           //SRA SLL/SLR SRL
           b = 32'b000000111000000011111111000000011;
           a = 32'b101;
           //aluc = 4'b1110;
           #40 aluc = 4'b1111;            
           #40 aluc = 4'b1101;     
           
       end        
endmodule

