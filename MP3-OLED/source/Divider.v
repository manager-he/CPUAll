module Divider(
    input I_CLK,    //输入时钟信号，上升沿有效
    input rst,      //同步复位信号，高电平有效
    output reg O_CLK=0    //输出时钟
);
    parameter defaultMultiple=2;   //默认分频倍数

    integer counter=0;
    always@(posedge I_CLK)
    begin
        if(rst==1)
        begin
            counter<=0;
            O_CLK<=0;
        end
        else
        begin
            if(counter==defaultMultiple/2-1)
            begin
                counter<=0;
                O_CLK<=~O_CLK;
            end
            else
                counter<=counter+1;
        end
    end
endmodule