module checkSuspend (
    input RESET,
    input MP3_SCLK,
    input SUSPEND,      //暂停按钮

    output reg IS_SUSPENDING=0       //正处在暂停状态. 1为暂停, 0为播放
);

    reg canSuspend=1;

    always@(posedge MP3_SCLK)   //为避免与mp3模块发生冲突,此处在上升沿修改暂停
    begin
        if(RESET)
        begin
            canSuspend<=1;
            IS_SUSPENDING<=0;   //重置后,不暂停
        end
        else if(SUSPEND)     //按下暂停
        begin
            if(canSuspend)
            begin
                IS_SUSPENDING<=~IS_SUSPENDING;
                canSuspend<=0;      //不可设置暂停
            end
            else
                ;
        end
        else
            canSuspend<=1;
    end
endmodule