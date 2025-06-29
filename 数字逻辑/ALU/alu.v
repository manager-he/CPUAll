`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 20:30:41
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a, //32 λ���룬������ 1
    input [31:0] b, //32 λ���룬������ 2
    input [3:0] aluc, //4 λ���룬���� alu �Ĳ���
    output reg [31:0] r, //32 λ������� a��b ���� aluc ָ���Ĳ�������
    output reg zero, //0 ��־λ
    output reg carry, // ��λ��־λ
    output reg negative, // ������־λ
    output reg overflow // �����־λ
    );
    wire signed [31:0] a1;
    wire signed [31:0]b1;
    assign a1=a;
    assign b1=b;
    
    wire [31:0] r_addu;
    assign r_addu = a+b;//�޷��żӷ�
    wire signed [31:0] r_add;
    assign r_add= a1+b1;//�з��żӷ�
    wire [31:0] r_subu;
    assign r_subu = a-b;//�޷��ż���
    wire signed [31:0] r_sub;
    assign r_sub=a1-b1;//�з��ż���
    
    wire [31:0] r_and;
    assign r_and = a&b;
    
    wire [31:0] r_or;
    assign r_or =a|b;
    
    wire [31:0] r_xor;
    assign r_xor =a^b;
    
    wire [31:0] r_nor;
    assign r_nor=~(a|b);
    
    wire[31:0] r_lui;//��λ��������
    assign r_lui={b[15:0],16'b0};
    
    wire[31:0] r_slt;
    assign r_slt=(a1<b1)?1:0;
    
    wire[31:0]r_sltu;
    assign r_sltu=(a<b)?1:0;
    
    wire[31:0]r_sra;//��������
    reg [31:0] r_sra_t;
    assign r_sra=b1 >>>a;
    
    wire[31:0]r_slr;//�߼�����
    reg [31:0] r_slr_t;
    assign r_slr=b<<a;
    
    wire[31:0]r_srl;//�߼�����
    reg [31:0] r_srl_t;
    assign r_srl=b>>a;
    
    reg [32:0] an,bn,cn;   //�޷�����
        always @ (*)
          begin
          an={1'b0,a[31:0]};
          bn={1'b0,b[31:0]};
           
           if (aluc == 4'b0000)
           begin  
            r = r_addu;
           if(r_addu == 0)
           zero = 1'b1;
           else
           zero = 1'b0;
           cn = an + bn;
           carry = cn[32];
           negative <= r_addu[31];//ʹ���з������ж����λ������N�Ƿ�Ϊ1��0
           overflow <= 1'bz;
           end
           else if(aluc==4'b0001)
           begin
                    r<=r_subu;
                    if(r_subu==0)
                        zero<=1'b1;
                    else
                        zero<=1'b0;
                        cn = an - bn;
                        carry = cn[32];
                        negative = r_subu[31];
                    overflow<=1'b0;
                    
           end
           else  if (aluc == 4'b0010)
          begin   //�з���+
                    r = r_add;
                  if(r_add == 0)
                  zero = 1'b1;
                  else
                  zero = 1'b0;
                  carry = 1'b0;
                  negative <= r_add[31];
   
                    if( a1[31]== 1 && b1[31]==1 && r_add[31] == 0)
                       overflow <= 1'b1;
                    else if ( a1[31]== 0 && b1[31]==0 && r_add[31] == 1)
                       overflow <= 1'b1;
                    else
                       overflow <= 1'b0;
          end
           else  if (aluc == 4'b0011)
                   begin   //�з���-
                            if(r_sub == 0)
                            zero = 1'b1;
                            else
                            zero = 1'b0;
                             carry <= 1'b0;
                             negative <= r_sub[31];
                            if( a1[31]== 0 && b1[31]==1 && r_sub[31] == 1)
                            overflow = 1'b1;
                            else if ( a1[31]== 1 && b1[31]==0 && r_sub[31] == 0)
                            overflow = 1'b1;
                            else
                            overflow = 1'b0;
 
                   end
                   else if (aluc ==  4'b0100)
                      begin  //and
                              r <= r_and;
                             if(r_and == 0)
                              zero = 1'b1;
                              else
                              zero = 1'b0;

                              carry <= 1'b0;
                              negative <= r_and[31];
                              overflow <= 1'b0;
                      end 
                else if (aluc ==  4'b0101)
                     begin  //or
                             r <= r_or;
                             if(r_or == 0)
                                zero <= 1'b1;
                             else
                                zero <= 1'b0;
                             carry <= 1'b0;
                             negative <= r_or[31];
                             overflow <= 1'b0;
                     end  
                else if (aluc ==   4'b0110)
                            begin  //xor
                                    r <= r_xor;
                                    if(r_xor == 0)
                                      zero <= 1'b1;
                                    else
                                      zero <= 1'b0;
                                    carry <= 1'b0;
                                    negative <= r_xor[31];
                                    overflow <= 1'b0;
                            end  
                  else if (aluc ==  4'b0111)
                               begin  //nor
                                       r <= r_nor;
                                       if(r_nor == 0)
                                         zero <= 1'b1;
                                       else
                                         zero <= 1'b0;
                                       carry <= 1'b0;
                                       negative <= r_nor[31];
                                       overflow <= 1'b0;
                               end  
                    else if (aluc ==  4'b1000||aluc==4'b1001)
                              begin  //lui
                                      r = {b[15:0],16'b0};
                                      if(r == 0)
                                        zero <= 1'b1;
                                      else
                                        zero <= 1'b0;
                                      carry <= 1'b0;
                                      negative <= r[31];
                                      overflow <= 1'b0;
                              end   
                     else if (aluc ==   4'b1011)
                      begin  //slt
                              r <= r_slt;
                              if(a==b)
                                zero <= 1'b1;
                              else
                                zero <= 1'b0;
                              carry <= 1'b0;
                              overflow <= r_slt[31];
                              if (a1-b1<0)
                                negative <= 1'b1;
                              else
                                negative <= 1'b0;
                      end  
                         else if (aluc ==   4'b1010)
                            begin  //sltu
                                    r <= r_sltu;
                                                if(a == b)
                                                zero = 1'b1;
                                                else
                                                zero = 1'b0;
                                                
                                                if(r)
                                                carry = 1'b1;
                                                else
                                                carry = 1'b0;
                                    overflow <= 1'b0;
                                    negative <= r_sltu[31];
                                    
                            end           
                           else if (aluc ==   4'b1100)
                            begin  //sra
                                    r <= r_sra;
                                    if(r_sra)
                                        zero = 1'b0;                                    
                                    else
                                        zero = 1'b1;
                                    

                                    // ���з�����չ
                                    r_sra_t = b1 >>> (a - 1);                
                                    carry <= r_sra_t[0];
                                    negative <= r_sra[31];
                                    overflow <= 1'b0;
                            end  
                            else if (aluc ==   4'b1110 || aluc==4'b1111)
                             begin  //sll/slr
                                     r <= r_slr;
                                        if(r_slr == 0)
                                        zero = 1'b1;
                                        else
                                        zero = 1'b0;    
                                     r_slr_t=b<<(a-1);   
                                     overflow <= 1'bz;     
                                     negative <= r_slr[31];               
                                     carry <= r_slr_t[31];  
                             end    
                            else if (aluc ==    4'b1101)
                              begin  //srl
                                      r <= r_srl;
                                      if(r_srl)
                                        zero <= 1'b0;                                        
                                      else
                                        zero <= 1'b1;
                                      
                                      r_srl_t = b>>(a-1); 
                                      carry <= r_srl_t[0];
                                      overflow <= 1'bz;
                                      negative <= r_srl[31];
                                      
                              end                                
    end
    
endmodule
