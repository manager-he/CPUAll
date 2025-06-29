`timescale 1ns/1ns

module oled_tb();
    reg CLK_100MHz;
    wire OLED_CLK;
    wire OLED_DIN;
    wire OLED_CS;
    wire OLED_D_C;
    wire OLED_RES;

    // wire [31:0]countt;

    initial
        CLK_100MHz=1;
    always
        #1 CLK_100MHz=~CLK_100MHz;

    DigitalSystem
    DigitalSystem_init(
        .CLK_100MHz(CLK_100MHz),
        .OLED_DIN(OLED_DIN),
        .OLED_CLK(OLED_CLK),
        .OLED_CS(OLED_CS),
        .OLED_D_C(OLED_D_C),
        .OLED_RES(OLED_RES)

        // ,.countt(countt)
    );

endmodule