module changeSong (
    input RESET,
    input MP3_SCLK,
    input MP3_LASTSONG,         //歌曲调整
    input MP3_NEXTSONG,
    output reg [31:0]SongNow=0  //初始时歌曲为第0首
);

    localparam songNum=3;               //歌曲总数
    localparam changeSongCd=1000000;     //改变歌曲的冷却时间,此处为1s

    integer cd=changeSongCd;

    always@(posedge MP3_SCLK)   //为避免与mp3模块发生冲突,此处在上升沿修改歌曲信息
    begin
        if(RESET)
        begin
            cd<=changeSongCd;   //重置后改变有效
            SongNow<=0;         //重置后改变为第0首
        end
        else if(MP3_LASTSONG||MP3_NEXTSONG)
        begin
            if(cd>=changeSongCd)
            begin
                if(MP3_LASTSONG)
                    SongNow<=(SongNow==0)?songNum-1:SongNow-1;
                else
                    SongNow<=(SongNow==songNum-1)?0:SongNow+1;
                cd<=0;  //重新开始cd
            end
            else
                cd<=cd+1;
        end
        else
            cd<=changeSongCd;   //如果没有按下改变歌曲键,则下次改变有效
    end


endmodule