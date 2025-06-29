`include "defines.v"

module openmips_min_sopc(input	wire clk,
                         input wire rst,
                         output wire[`RegBus] result_o);    // ???????

// Á¬½ÓÖ¸Áî´æ´¢Æ÷
wire[`InstAddrBus] inst_addr;
wire[`InstBus] inst;
wire rom_ce;
wire mem_we_i;
wire[`RegBus] mem_addr_i;
wire[`RegBus] mem_data_i;
wire[`RegBus] mem_data_o;
wire[3:0] mem_sel_i;
wire mem_ce_i;
wire[5:0] int;
wire timer_int;

// ????????????
wire[15:0] count_show;
wire[15:0] res_show;
// wire[`RegBus] result_o;
assign res_show = result_o[15:0];
assign count_show = result_o[31:16];

// assign int = {5'b00000, timer_int, gpio_int, uart_int};
assign int    = {5'b00000, timer_int};

openmips openmips0(
.clk(clk),
.rst(rst),

.rom_addr_o(inst_addr),
.rom_data_i(inst),
.rom_ce_o(rom_ce),

.int_i(int),

.ram_we_o(mem_we_i),
.ram_addr_o(mem_addr_i),
.ram_sel_o(mem_sel_i),
.ram_data_o(mem_data_i),
.ram_data_i(mem_data_o),
.ram_ce_o(mem_ce_i),

.timer_int_o(timer_int)

);

// ?????????ROM?RAM
wire[`RegBus] relative_inst_addr = inst_addr - `TextBegin;
wire[`RegBus] relative_mem_addr = mem_addr_i - `DataBegin;

inst_rom inst_rom0(
.ce(rom_ce),
.addr(relative_inst_addr),
.inst(inst)
);
// inst_rom_for_cpu89 inst_rom_for_cpu89_inst(relative_inst_addr[`InstMemNumLog2+1:2], inst);   // ????????

data_ram data_ram0(
.clk(clk),
.ce(mem_ce_i),
.we(mem_we_i),
.addr(relative_mem_addr),
.sel(mem_sel_i),
.data_i(mem_data_i),
.data_o(mem_data_o),
.result(result_o)	
);

endmodule
