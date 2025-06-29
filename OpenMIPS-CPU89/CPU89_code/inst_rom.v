`include "defines.v"

module inst_rom(input wire ce,
                input wire[`InstAddrBus] addr,
                output reg[`InstBus] inst);
	
	reg[`InstBus]  inst_mem[0:`InstMemNum-1];	

	// initial begin
	// 	$display("Loading memory from inst_rom.data...");
	// 	$readmemh("E:\\DigitCircuit\\computer_componont\\OpenMIPS\\CPU89_code\\inst_rom.data", inst_mem); // ???? \\ ??
	// end
	
	// always @ (*) begin
	// 	if (ce == `ChipDisable) begin
	// 		inst <= `ZeroWord;
	// 		end else begin
	// 		inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
	// 	end
	// end

	wire [`InstBus] rom_o;
	irom irom (
		.a(addr[`InstMemNumLog2+1:2]),
		.spo(rom_o)
	);

	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
			end 
		else begin
			inst <= rom_o;
		end
	end
	
endmodule
