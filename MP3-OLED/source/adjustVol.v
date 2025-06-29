module adjustVol (
    input RESET,
    input MP3_SCLK,

    input MP3_VOL_UP,           //音量调整
    input MP3_VOL_DOWN,

    output reg[7:0]VOLUME=0     //输出当前音量
);

    localparam adjustVolCd=500000;     //改变音量的冷却时间,此处为0.5s
    localparam adjustStep=8'h8;        //每次改变音量的步长,注意必须为2的次幂

    integer cd=adjustVolCd;

    always@(posedge MP3_SCLK)   //为避免与mp3模块发生冲突,此处在上升沿修改音量
    begin
        if(RESET)
        begin
            cd<=adjustVolCd;   //重置后改变有效
            VOLUME<=8'h0;         //重置后改变为最大音量
        end
        else if(MP3_VOL_UP||MP3_VOL_DOWN)
        begin
            if(cd>=adjustVolCd)
            begin
                if(MP3_VOL_UP)
                    VOLUME<=(VOLUME==8'h0)?8'h0:VOLUME-adjustStep;
                else
                    VOLUME<=(VOLUME==8'hff)?8'hff:VOLUME+adjustStep;
                cd<=0;  //重新开始cd
            end
            else
                cd<=cd+1;
        end
        else
            cd<=adjustVolCd;   //如果没有按下音量键,则下次改变有效
    end

endmodule