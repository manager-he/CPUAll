`include "defines.v"

module regfile(input	wire clk,
               input wire rst,
               input wire we,
               input wire[`RegAddrBus] waddr,
               input wire[`RegBus] wdata,
               input wire re1,
               input wire[`RegAddrBus] raddr1,
               output reg[`RegBus] rdata1,
               input wire re2,
               input wire[`RegAddrBus] raddr2,
               output reg[`RegBus] rdata2);

reg[`RegBus]  regs[0:`RegNum-1];
integer i;

// Write data to register file
always @ (posedge clk) begin
	if (rst == `RstEnable) begin
		for (i = 0; i<`RegNum; i = i+1) begin
			regs[i] <= `ZeroWord; // 是否要初始化? 不初始化更好纠错?
		end
	end
	else begin
		if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
			regs[waddr] <= wdata;
		end
	end
end

// Read data1 from register file
always @ (*) begin
	if (rst == `RstEnable) begin
		rdata1 <= `ZeroWord;
	end
	else begin
		if (re1 == `ReadEnable) begin
			if (raddr1 == `RegNumLog2'h0) rdata1 <= `ZeroWord;
			else if (raddr1 == waddr && we == `WriteEnable) rdata1 <= wdata;
			else rdata1 <= regs[raddr1];
		end
		else rdata1 <= `ZeroWord;
	end
end

// Read data2 from register file
always @ (*) begin
	if (re2 == `ReadEnable) begin
		if (raddr2 == `RegNumLog2'h0) begin rdata2 <= `ZeroWord; end
		else if (raddr2 == waddr && we == `WriteEnable) rdata2 <= wdata;
		else rdata2 <= regs[raddr2];
	end
	else rdata2 <= `ZeroWord;
end


endmodule
