module mp3_tb ;
    reg CLK_100MHz;
    reg MP3_VOL_UP;
    reg MP3_VOL_DOWN;

    reg MP3_MISO;
    // output CLK_1MHz;

    wire MP3_SCLK;
    wire MP3_MOSI;
    wire MP3_xCS;
    wire MP3_xDCS;
    wire MP3_xRSET;

    // wire step1;
    // wire step2;
    // wire step3;
    // wire [31:0]cmdCount;
    // wire [11:0]pointerA;
    // wire [31:0]countA;
    // wire [31:0]memA;
    // wire [15:0]vol;

    initial
    begin
        CLK_100MHz=0;
        MP3_VOL_UP=0;
        MP3_VOL_DOWN=0;
    end
    always
        #2 CLK_100MHz=~CLK_100MHz;

    initial
    begin
        MP3_VOL_UP=1;
        #30 MP3_VOL_UP=0;
        MP3_VOL_DOWN=1;
        #20 MP3_VOL_DOWN=0;
    end

    mp3 mp3(
        .CLK_100MHz(CLK_100MHz),
        .MP3_VOL_UP(MP3_VOL_UP),
        .MP3_VOL_DOWN(MP3_VOL_DOWN),
        .MP3_DREQ(1'b1),
        .MP3_MISO(MP3_MISO),
        .MP3_SCLK(MP3_SCLK),
        .MP3_MOSI(MP3_MOSI),
        .MP3_xCS(MP3_xCS),
        .MP3_xDCS(MP3_xDCS),
        .MP3_xRSET(MP3_xRSET)
        
        
        // ,
        // .step1(step1),
        // .step2(step2),
        // .step3(step3),
        // .cmdCount(cmdCount),
        // .pointerA(pointerA),
        // .countA(countA),
        // .memA(memA)
        // .vol(vol)
    );
endmodule