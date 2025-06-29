module mp3 (
    input RESET,
    input MP3_SCLK,         //mp3的工作时钟    
    input MP3_DREQ,

    input [31:0]SongNow,    //当前的歌曲
    input [31:0]Memory,     //当前歌曲的内容
    input [31:0]MusicSize,  //当前歌曲大小
    input IS_SUSPENDING,    //是否暂停
    input [7:0]VOLUME,      //音量大小
    
    output reg [31:0]MemAddr,       //歌曲地址
    output reg MP3_MOSI,
    output reg MP3_xCS,
    output reg MP3_xDCS,
    output reg MP3_xRSET
);

    //状态机, 以及其相应设置
    localparam  hardReset       =7'b1000000,    //硬件复位
                initialisePre   =7'b0100000,    //初始化准备阶段
                initialise      =7'b0010000,    //初始化
                displayMusic    =7'b0001000,    //播放音乐
                checkState      =7'b0000100,    //检查当前状态
                adjustVolPre    =7'b0000010,    //调整音量的准备阶段
                adjustVol       =7'b0000001;    //调整音量
    reg [6:0]state=hardReset;       //标识当前状态, 初始化为硬件复位

    //播放歌曲设置
    reg [31:0]lastSong=32'hff_ff_ff_ff; //记录上一首歌.初始化置为-1

    //模式寄存器设置. 这里使用reg, 方便后续的修改.
    reg[31:0]modeSetting=32'h02_00_08_04;
    reg[31:0]bassSetting=32'h02_02_00_55;
    reg[31:0]volSetting=32'h02_0b_00_00;
    reg[31:0]clockSetting=32'h02_03_98_00;
    reg[127:0]initialSetting;

    //计数器
    integer count=0;                 //简单计数器
    integer commandCount=0;          //简单计数器, 初始化时使用

    //具体实现
    always@(negedge MP3_SCLK)   //数据在上升沿被采样，所以在下降沿写入
    begin
        case (state)
        hardReset:        //硬件复位
            begin
                MP3_xRSET<=0;
                MP3_xDCS<=1;
                MP3_xCS<=1;
                //状态机转换
                state<=initialisePre;
            end
        initialisePre:    //硬件复位完毕
            begin
                //下一阶段的准备操作
                MP3_xRSET<=1;
                count<=31;
                commandCount<=0;
                initialSetting<={modeSetting,bassSetting,volSetting,clockSetting};
                //状态机转换
                state<=initialise;
            end
        initialise:       //初始化
            begin
                //配置寄存器. 此过程不受外界信号干扰.
                if(MP3_DREQ)
                begin
                    if(commandCount<4)  //初始化的4条指令未发完
                    begin
                        if(count>=0)
                        begin
                            MP3_xCS<=0;
                            MP3_MOSI<=initialSetting[count];
                            count<=count-1;
                        end
                        else    // 特别注意，指令每读32bit必须要置一次xcs高
                        begin
                            MP3_xCS<=1;
                            count<=31;
                            commandCount<=commandCount+1;
                            initialSetting<=(initialSetting>>32);
                        end
                    end
                    else        //初始化完成
                    begin
                        MP3_xCS<=1;
                        count<=31;      //这里是为播放歌曲而准备的
                        MemAddr<=0;
                        lastSong<=SongNow;  //上一首歌曲切换为当前歌曲
                        //状态机转换
                        state<=checkState; //转到检查播放状态
                    end
                end
                else    //mp3_dreq为低时, 滞空该周期
                    ;
            end
        checkState:       //检查当前状态
            begin
                //状态机转换
                if(RESET)
                    state<=hardReset;
                else if(lastSong!=SongNow)     //歌曲切换
                    state<=initialisePre;      //直接进入初始化预备状态,即可完成歌曲切换
                else if((volSetting[7:0]!=VOLUME)&&MP3_DREQ) //按下了音量键
                    state<=adjustVolPre;        //进入调整音量预备状态
                else if(!IS_SUSPENDING&&MP3_DREQ)   //不处在暂停状态,并且可以发送数据
                    state<=displayMusic;        //进入播放状态
                else    //否则,该周期滞空
                    ;
            end
        displayMusic:     //播放音乐
            begin
                //发送音频数据
                if(MemAddr>=MusicSize)     //循环播放本首歌曲
                    state<=initialisePre;
                else   //文件未读完
                begin
                    if(count>=0)
                    begin
                        MP3_xDCS<=0;
                        MP3_MOSI<=Memory[count];
                        count<=count-1;
                    end
                    else
                    begin
                        MP3_xDCS<=1;
                        count<=31;
                        MemAddr<=MemAddr+1;
                        //状态机转换
                        state<=checkState;
                    end
                end
            end
        adjustVolPre:     //调整音量的准备阶段
            begin
                count<=31;
                volSetting<={16'h02_0b,VOLUME,VOLUME};      //改变音乐寄存器的内容
                //状态机转换
                state<=adjustVol;
            end
        adjustVol:        //调整音量
            begin
                if(count>=0)
                begin
                    MP3_xCS<=0;
                    MP3_MOSI<=volSetting[count];
                    count<=count-1;
                end
                else    // 特别注意，指令每读32bit必须要置一次xcs高
                begin
                    MP3_xCS<=1;
                    count<=31;
                    //状态机转换
                    state<=checkState;
                end
            end
        default: ;
        endcase
    end

endmodule