module top_tb ;
    reg CLK_100MHz;
    reg RESET;        //复位信号
    reg SUSPEND;      //暂停按钮
    //mp3输入端口
    reg MP3_VOL_UP;       //音量调整
    reg MP3_VOL_DOWN;
    reg MP3_LASTSONG;     //歌曲调整
    reg MP3_NEXTSONG;
    reg MP3_DREQ;
    //mp3输出端口
    wire MP3_SCLK;
    wire MP3_MOSI;
    wire MP3_xCS;
    wire MP3_xDCS;
    wire MP3_xRSET;
    //小屏输出端口
    wire OLED_CLK;
    wire OLED_DIN;
    wire OLED_CS;
    wire OLED_D_C;
    wire OLED_RES;
    //调试端口
    wire IS_SUSPENDING;       //正处在暂停状态. 1为暂停; 0为播放
    wire IS_SONG0;            //是否为第0首歌
    wire IS_SONG1;            //是否为第1首歌
    wire IS_SONG2;            //是否为第2首歌

    initial
    begin
        CLK_100MHz=0;
        RESET=1;
        SUSPEND=0;
        MP3_VOL_UP=0;
        MP3_VOL_DOWN=0;
        MP3_LASTSONG=0;
        MP3_NEXTSONG=0;
        MP3_DREQ=1;

        #30 RESET=0;
    end
    always
        #2 CLK_100MHz=~CLK_100MHz;

    top top(
        .CLK_100MHz(CLK_100MHz),
        .RESET(RESET),        //复位信号
        .SUSPEND(SUSPEND),      //暂停按钮
        //mp3输入端口
        .MP3_VOL_UP(MP3_VOL_UP),       //音量调整
        .MP3_VOL_DOWN(MP3_VOL_DOWN),
        .MP3_LASTSONG(MP3_LASTSONG),     //歌曲调整
        .MP3_NEXTSONG(MP3_NEXTSONG),
        .MP3_DREQ(MP3_DREQ),
        //mp3输出端口
        .MP3_SCLK(MP3_SCLK),
        .MP3_MOSI(MP3_MOSI),
        .MP3_xCS(MP3_xCS),
        .MP3_xDCS(MP3_xDCS),
        .MP3_xRSET(MP3_xRSET),
        //小屏输出端口
        .OLED_CLK(OLED_CLK),
        .OLED_DIN(OLED_DIN),
        .OLED_CS(OLED_CS),
        .OLED_D_C(OLED_D_C),
        .OLED_RES(OLED_RES),
        //调试端口
        .IS_SUSPENDING(IS_SUSPENDING),       //正处在暂停状态. 1为暂停, 0为播放
        .IS_SONG0(IS_SONG0),            //是否为第0首歌
        .IS_SONG1(IS_SONG1),            //是否为第1首歌
        .IS_SONG2(IS_SONG2)             //是否为第2首歌
    );
endmodule