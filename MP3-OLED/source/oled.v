module oled(
    input RESET,
    input OLED_CLK,             //oled工作时钟
    input IS_SUSPENDING,        //是否处在暂停模式

    input [31:0]SongNow,    //当前的歌�?

    output reg OLED_RES,
    output reg OLED_DIN,
    output reg OLED_CS,
    output reg OLED_D_C
);
`include "OLED_CMD.vh"

    //小屏状�?�机设置
    localparam  reset               =9'b100_000_000,//重置
                initialisePre       =9'b010_000_000,//初始化预�?
                initialise          =9'b001_000_000,//初始�?
                clearScreen         =9'b000_100_000,//清空窗口
                drawSong            =9'b000_010_000,//画song这几个字�?
                checkState          =9'b000_001_000,//�?查状�?
                changeDisplayModePre=9'b000_000_100,//画暂�?/播放状�?�准�?
                changeSongNamePre   =9'b000_000_010,//画歌曲名的准备阶�?
                sendCommand         =9'b000_000_001;//发�?�绘图指�?
    reg [8:0]state=reset;//初始化为重置状�??

    //各类状�?�信息设�?
    reg [31:0]lastSong=32'hff_ff_ff_ff; //记录上一首歌.初始化置�?-1
    reg lastSuspend=1'b1;   //记录上次的暂停状�?

    //各类图形命令以及设置
    localparam  colMax=8'h5f,
                rowMax=8'h3f;   //�?大行列地�?�?
    
    reg [967:0]command;    //指令寄存�?, 在状态中会用�?

    // localparam drawHelloCommand='h;

    //计数�?
    integer count;

    always@(negedge OLED_CLK)   //数据在上升沿被采样，�?以在下降沿写�?
    begin
        case (state)
        reset: 
            begin
                OLED_RES<=0;    //重置
                lastSong<=32'hff_ff_ff_ff;
                lastSuspend<=~IS_SUSPENDING;
                //状�?�机转换
                state<=initialisePre;
            end
        initialisePre:
            begin
                OLED_RES<=1;    //重置解除
                OLED_CS<=1;
                OLED_D_C<=1;
                count<=303;
                command<={  //长度�?304
                    664'h0,
                    scrollDeactiveCommand,  //首先禁用滚动
                    296'hae_a0_74_a1_00_a2_00_a4_a8_3f_ad_8e_b0_0b_b1_31_b3_f0_8a_64_8b_78_8c_64_bb_3a_be_3e_87_06_81_91_82_50_83_7d_af
                };
                //状�?�机转换
                state<=initialise;
            end
        initialise:
            begin
                if(count>=0)
                begin
                    OLED_CS<=0;
                    OLED_D_C<=0;
                    OLED_DIN<=command[count];
                    count<=count-1;
                end
                else
                begin
                    OLED_CS<=1;
                    count<=39;
                    //状�?�机转换
                    state<=clearScreen;
                end
            end
        clearScreen:
            begin
                if(count>=0)
                begin
                    OLED_CS<=0;
                    OLED_D_C<=0;
                    OLED_DIN<=clearFullScreenCommand[count];
                    count<=count-1;
                end
                else
                begin
                    OLED_CS<=1;
                    //状�?�机转换
                    if(!RESET)  //如果重置信号始终有效, 则保持黑�?
                    begin
                        count<=599 + 88*7;
                        command<={ //长度�?88+512=600
                            //清屏完成�?,�?要打印上�?�?/下一首键,打印框框
                            368'h0,
                            drawBlockCommand,
                            drawBattery,
                            //长度64*8=512, 画上�?首和下一首的设置
                            8'h21,//上一�?
                            8'd12,//�?
                            8'd10,
                            8'd12,
                            8'd24,
                            lastNextColor,
                            8'h21,//�?
                            8'd24,
                            8'd10,
                            8'd12,
                            8'd17,
                            lastNextColor,
                            8'h21,//�?
                            8'd24,
                            8'd24,
                            8'd12,
                            8'd17,
                            lastNextColor,
                            8'h21,//�?
                            8'd24,
                            8'd10,
                            8'd24,
                            8'd24,
                            lastNextColor,

                            8'h21,//下一�?
                            8'd74,//�?
                            8'd10,
                            8'd74,
                            8'd24,
                            lastNextColor,
                            8'h21,//�?
                            8'd74,
                            8'd10,
                            8'd86,
                            8'd17,
                            lastNextColor,
                            8'h21,//�?
                            8'd74,
                            8'd24,
                            8'd86,
                            8'd17,
                            lastNextColor,
                            8'h21,//�?
                            8'd86,
                            8'd10,
                            8'd86,
                            8'd24,
                            lastNextColor
                        };
                        state<=sendCommand;
                    end
                    else
                        ;
                end
            end
        checkState: //�?查状�?
            begin
                //本处的检查状态设置不同于MP3.其状态在对应的状态中保持
                if(RESET)  //歌曲改变
                    state<=reset;
                else if(lastSong!=SongNow)
                    state<=changeSongNamePre;
                else if(lastSuspend!=IS_SUSPENDING) //暂停状�?�改�?
                    state<=changeDisplayModePre;
                else
                    ;
            end
        changeSongNamePre:
            begin
                lastSong<=SongNow;
                lastSuspend<=~IS_SUSPENDING;    //暂停状�?�取�?,使得滚动可以被判�?
                count<=1143; //967 + 88*2;
                command <= drawSongCommand;
                
                
                //状�?�机改变
                state<=drawSong;
            end
        drawSong:
            begin
                if(count>=0)
                begin
                    OLED_CS<=0;
                    OLED_D_C<=0;
                    OLED_DIN<=command[count];
                    count<=count-1;
                end
                else
                begin
                    OLED_CS<=1;
                    case (SongNow)
                    0:  begin
                            count<=87;
                            command<={
                                880'h0,
                                draw0Command
                            };
                        end
                    1:  begin
                            count<=63;
                            command<={
                                904'h0,
                                draw1Command
                            };
                        end
                    2:  begin
                            count<=319;
                            command<={
                                648'h0,
                                draw2Command
                            };
                        end
                    default: ;
                    endcase
                    //状�?�机转换
                    state<=sendCommand;
                end                
            end        
        changeDisplayModePre:
            begin
                lastSuspend<=IS_SUSPENDING;
                if(IS_SUSPENDING)   //画播�?
                begin
                    count<=239;
                    command<={
                        728'h0,
                        scrollDeactiveCommand,   //禁用滚动
                        clearDisplayCommand,
                        drawPlayingCommand
                    };
                end
                else
                begin
                    count<=223;
                    command<={
                        744'h0,
                        clearDisplayCommand,
                        drawSuspendingCommand,
                        scrollSettingCommand,
                        scrollActiveCommand    //启用滚动
                    };
                end
                //状�?�机转换
                state<=sendCommand;
            end
        sendCommand:
            begin
                if(count>=0)
                begin
                    OLED_CS<=0;
                    OLED_D_C<=0;
                    OLED_DIN<=command[count];
                    count<=count-1;
                end
                else
                begin
                    OLED_CS<=1;
                    //状�?�机转换
                    state<=checkState;
                end                
            end
        default: ;
        endcase
    end

endmodule