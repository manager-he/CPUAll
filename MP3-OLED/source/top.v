module top (
    input CLK_100MHz,
    input RESET,        //复位信号
    input SUSPEND,      //暂停按钮

    //mp3输入端口
    input MP3_VOL_UP,       //音量调整
    input MP3_VOL_DOWN,
    input MP3_LASTSONG,     //歌曲调整
    input MP3_NEXTSONG,
    input MP3_DREQ,

    //mp3输出端口
    output MP3_SCLK,
    output MP3_MOSI,
    output MP3_xCS,
    output MP3_xDCS,
    output MP3_xRSET,

    //小屏输出端口
    output OLED_CLK,
    output OLED_DIN,
    output OLED_CS,
    output OLED_D_C,
    output OLED_RES,

    //调试端口
    output IS_SUSPENDING,       //正处在暂停状�?. 1为暂�?, 0为播�?
    output IS_SONG0,            //是否为第0首歌
    output IS_SONG1,            //是否为第1首歌
    output IS_SONG2,             //是否为第2首歌

    output [6:0] seg
);

    //播放歌曲设置
    //由于内存限制，本处共设置三首歌曲
    wire [31:0]songNow;            //当前播放的歌�?, 取�?�从0~songNum-1
    wire [31:0]memAddr;              //歌曲的读指针, 每次播放新歌曲时�?0
    wire [31:0]memory0,memory1,memory2; //存放每首歌曲数据的寄存器
    wire [31:0]music_size=          //当前歌曲的长�?, 注意�?要与songNum�?�?对应
                songNow==0?13164: //50338:   //花西�?
                songNow==1?29702:   //火红的萨日朗
                songNow==2?22021:   //55782:   //亲爱的旅�?
                0;
    wire [31:0]memory=              //当前正在读取的歌�?
                songNow==0?memory0: //花西�?
                songNow==1?memory1: //火红的萨日朗
                songNow==2?memory2: //亲爱的旅�?
                0;
    assign IS_SONG0=songNow==0?1'b1:0;
    assign IS_SONG1=songNow==1?1'b1:0;
    assign IS_SONG2=songNow==2?1'b1:0;

    //歌曲音量设置
    wire [7:0]volume;

    DigitShow DigitShow(.reset(RESET),.num(songNow[3:0]),.seg(seg));
    
    //ip核调�?. 这里的每个blk均和songNum�?�?对应
    blk_mem_gen_0 blk_mem_gen_0 (
      .clka(CLK_100MHz),    // input wire clka
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(memAddr[15:0]),  // input wire [15 : 0] addra
      .dina(0),    // input wire [31 : 0] dina
      .douta(memory0)  // output wire [31 : 0] douta
    );
    blk_mem_gen_1 blk_mem_gen_1 (
      .clka(CLK_100MHz),    // input wire clka
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(memAddr[15:0]),  // input wire [? : 0] addra
      .dina(0),    // input wire [31 : 0] dina
      .douta(memory1)  // output wire [31 : 0] douta
    );
    blk_mem_gen_3 blk_mem_gen_3 (
      .clka(CLK_100MHz),    // input wire clka
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(memAddr[15:0]),  // input wire [16 : 0] addra
      .dina(0),    // input wire [31 : 0] dina
      .douta(memory2)  // output wire [31 : 0] douta
    );

    //mp3分频, 100即可
    Divider #(100)
    Divider_mp3(
        .I_CLK(CLK_100MHz),    //输入时钟信号，上升沿有效
        .rst(1'b0),      //同步复位信号，高电平有效
        .O_CLK(MP3_SCLK)
    );

    //oled的时钟分频必须足够大，否则无法完成屏幕操�?
    Divider #(10000)
    Divider_oled(
        .I_CLK(CLK_100MHz),    //输入时钟信号，上升沿有效
        .rst(1'b0),            //同步复位信号，高电平有效
        .O_CLK(OLED_CLK)
    );

    mp3 mp3(
        .RESET(RESET),
        .MP3_SCLK(MP3_SCLK),            //mp3的工作时�?    
        .MP3_DREQ(MP3_DREQ),

        .SongNow(songNow),              //当前的歌�?
        .Memory(memory),                //当前歌曲的内�?
        .MusicSize(music_size),         //当前歌曲大小
        .IS_SUSPENDING(IS_SUSPENDING),  //是否暂停
        .VOLUME(volume),                //音量大小

        .MemAddr(memAddr),              //歌曲地址
        .MP3_MOSI(MP3_MOSI),
        .MP3_xCS(MP3_xCS),
        .MP3_xDCS(MP3_xDCS),
        .MP3_xRSET(MP3_xRSET)
    );

    oled oled(
        .RESET(RESET),
        .OLED_CLK(OLED_CLK),             //oled工作时钟
        .IS_SUSPENDING(IS_SUSPENDING),   //是否处在暂停模式
        .SongNow(songNow),               //当前的歌�?
        .OLED_RES(OLED_RES),
        .OLED_DIN(OLED_DIN),
        .OLED_CS(OLED_CS),
        .OLED_D_C(OLED_D_C)
    );

    MusicControl MusicControl(
        .RESET(RESET),
        .MP3_SCLK(MP3_SCLK),
        .SUSPEND(SUSPEND),
        .IS_SUSPENDING(IS_SUSPENDING),
        .MP3_LASTSONG(MP3_LASTSONG),
        .MP3_NEXTSONG(MP3_NEXTSONG),
        .SongNow(songNow),
        .MP3_VOL_UP(MP3_VOL_UP),       //音量调整
        .MP3_VOL_DOWN(MP3_VOL_DOWN),
        .VOLUME(volume)
    );
    
    /*
    checkSuspend checkSuspend(
        .RESET(RESET),
        .MP3_SCLK(MP3_SCLK),
        .SUSPEND(SUSPEND),
        .IS_SUSPENDING(IS_SUSPENDING)
    );

    changeSong changeSong(
        .RESET(RESET),
        .MP3_SCLK(MP3_SCLK),
        .MP3_LASTSONG(MP3_LASTSONG),
        .MP3_NEXTSONG(MP3_NEXTSONG),
        .SongNow(songNow)
    );

    adjustVol adjustVol(
        .RESET(RESET),
        .MP3_SCLK(MP3_SCLK),
        .MP3_VOL_UP(MP3_VOL_UP),       //音量调整
        .MP3_VOL_DOWN(MP3_VOL_DOWN),
        .VOLUME(volume)
    );*/

endmodule