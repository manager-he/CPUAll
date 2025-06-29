`timescale 1ns / 1ps
module RegFile (
    input clk, rst, we,
    input [4:0] raddr1, raddr2, waddr,
    input [31:0] wdata,
    output [31:0] rdata1, rdata2
);
    reg [31:0] array_reg [31:0];

    integer i;

    always @(posedge rst or posedge clk) begin
        if(rst) begin
            for (i = 0; i<=31; i=i+1) begin
                array_reg[i] = 32'h00000000;
            end
        end
        else begin
            if(we) begin
                array_reg[waddr] = wdata;
                array_reg[0] = 0;
            end
        end
    end

    // // init
    // always @(posedge rst) begin
    //     array_reg[0] = 0;
    //     if (rst) begin
    //         for (i = 1; i<=31; i=i+1) begin
    //             array_reg[i] = 32'h00000000;
    //         end
    //     end
    // end

    // // write
    // always @(negedge clk) begin
    //     if (we && !rst) begin
    //         array_reg[waddr] = wdata;
    //         array_reg[0] = 0;
    //     end
    // end

    // read
    assign rdata1 = array_reg[raddr1];
    assign rdata2 = array_reg[raddr2];

endmodule