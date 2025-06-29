`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:45:04 03/18/2014
// Design Name:   decoder
// Module Name:   C:/Users/Wong/Desktop/tb/tb2/decoder/decoder_tb.v
// Project Name:  decoder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module _246tb_ex7_tb;

	// Inputs
	reg clk_in;
	reg reset;

	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	sccomp_dataflow uut (
		.clk_in(clk_in), 
		.reset(reset), 
		.inst(inst),
		.pc(pc)
	);

	integer file_output, file_output2;
    integer cnt = 0;
	//integer flag;
	reg [31:0] pc_pre;
	reg [31:0] inst_pre;
	//reg [31:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31;
	
	// INIT
    initial begin
        // $readmemh("E:/DigitCircuit/computer_componont/CPU/Data/test.txt", _246tb_ex7_tb.uut.imem_.inst_mem);
        file_output = $fopen("E:/DigitCircuit/computer_componont/CPU/Data/result.txt");
		file_output2 = $fopen("E:/DigitCircuit/computer_componont/CPU/Data/result2.txt");
    end
	
initial begin
		// file_output = $fopen("_246tb_ex7_result.txt");	// !!

		// Initialize Inputs
		clk_in = 0;
		reset = 1;
        //pcÂàùÂ?ãÂ¢„?32'h00400000
        //instÂàùÂ?ãÂ¢„?32'h08100004
		pc_pre = 32'h44436040; 
		inst_pre = 32'h88807704;
		

		// Wait 200 ns for global reset to finish
		#225;
        reset = 0;		
		
		
	end
   
	always begin		
	#50;	
	clk_in = ~clk_in;
	if(clk_in == 1'b1 && reset == 0) begin	
			if(pc_pre != pc)
			begin
			$fdisplay(file_output, "pc: %h", pc);	
			$fdisplay(file_output, "instr: %h", inst);
			$fdisplay(file_output, "regfile0: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[0]);
			$fdisplay(file_output, "regfile1: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[1]);
			$fdisplay(file_output, "regfile2: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[2]);
			$fdisplay(file_output, "regfile3: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[3]);
			$fdisplay(file_output, "regfile4: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[4]);
			$fdisplay(file_output, "regfile5: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[5]);
			$fdisplay(file_output, "regfile6: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[6]);
			$fdisplay(file_output, "regfile7: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[7]);
			$fdisplay(file_output, "regfile8: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[8]);
			$fdisplay(file_output, "regfile9: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[9]);
			$fdisplay(file_output, "regfile10: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[10]);
			$fdisplay(file_output, "regfile11: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[11]);
			$fdisplay(file_output, "regfile12: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[12]);
			$fdisplay(file_output, "regfile13: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[13]);
			$fdisplay(file_output, "regfile14: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[14]);
			$fdisplay(file_output, "regfile15: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[15]);
			$fdisplay(file_output, "regfile16: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[16]);
			$fdisplay(file_output, "regfile17: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[17]);
			$fdisplay(file_output, "regfile18: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[18]);
			$fdisplay(file_output, "regfile19: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[19]);
			$fdisplay(file_output, "regfile20: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[20]);
			$fdisplay(file_output, "regfile21: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[21]);
			$fdisplay(file_output, "regfile22: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[22]);
			$fdisplay(file_output, "regfile23: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[23]);
			$fdisplay(file_output, "regfile24: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[24]);
			$fdisplay(file_output, "regfile25: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[25]);
			$fdisplay(file_output, "regfile26: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[26]);
			$fdisplay(file_output, "regfile27: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[27]);
			$fdisplay(file_output, "regfile28: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[28]);
			$fdisplay(file_output, "regfile29: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[29]);
			$fdisplay(file_output, "regfile30: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[30]);
			$fdisplay(file_output, "regfile31: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[31]);
			pc_pre = pc;
			inst_pre = inst;
		end
		
	end
	
	end

	always @(posedge clk_in) begin
		cnt = cnt + 1;
		if(cnt == 20000) begin	//  || inst_pre === 32'hxxxxxxxx
			// $fclose(file_output);
			$fclose(file_output2);
		end
		$fdisplay(file_output2, "------------------------------------");	
		$fdisplay(file_output2, "pc: %h", pc);	
		$fdisplay(file_output2, "instr: %h", inst);
		$fdisplay(file_output2, "T1: %h", _246tb_ex7_tb.uut.sccpu.CU.T1);
		$fdisplay(file_output2, "T2: %h", _246tb_ex7_tb.uut.sccpu.CU.T2);
		$fdisplay(file_output2, "T3: %h", _246tb_ex7_tb.uut.sccpu.CU.T3);
		$fdisplay(file_output2, "T4: %h", _246tb_ex7_tb.uut.sccpu.CU.T4);
		$fdisplay(file_output2, "T5: %h", _246tb_ex7_tb.uut.sccpu.CU.T5);
		// $fdisplay(file_output2, "t0: %h", _246tb_ex7_tb.uut.sccpu.CU.t0);
		// $fdisplay(file_output2, "t1: %h", _246tb_ex7_tb.uut.sccpu.CU.t1);
		// $fdisplay(file_output2, "t2: %h", _246tb_ex7_tb.uut.sccpu.CU.t2);

		$fdisplay(file_output2, "regfile0: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[0]);
		$fdisplay(file_output2, "regfile1: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[1]);
		$fdisplay(file_output2, "regfile2: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[2]);
		$fdisplay(file_output2, "regfile3: %h", _246tb_ex7_tb.uut.sccpu.cpu_ref.array_reg[3]);
		$fdisplay(file_output2, "nextPC: %h", _246tb_ex7_tb.uut.sccpu.next);
		$fdisplay(file_output2, "CP0_exc_addr: %h", _246tb_ex7_tb.uut.sccpu.CP0_exc_addr);

		$fdisplay(file_output2, "Z_out: %h", _246tb_ex7_tb.uut.sccpu.Z_out);
		// $fdisplay(file_output2, "MuxPC: %h", _246tb_ex7_tb.uut.sccpu.MuxPC);
		// $fdisplay(file_output2, "PCin: %h", _246tb_ex7_tb.uut.sccpu.PCin);
		// $fdisplay(file_output2, "alu_a: %h", _246tb_ex7_tb.uut.sccpu.alu_a);
		// $fdisplay(file_output2, "alu_b: %h", _246tb_ex7_tb.uut.sccpu.alu_b);
		// $fdisplay(file_output2, "alu_zero: %h", _246tb_ex7_tb.uut.sccpu.alu_zero);
		// $fdisplay(file_output2, "alu_f: %h", _246tb_ex7_tb.uut.sccpu.alu_f);
		// $fdisplay(file_output2, "ALUC: %b", _246tb_ex7_tb.uut.sccpu.ALUC);
		// $fdisplay(file_output2, "MuxB: %b", _246tb_ex7_tb.uut.sccpu.MuxB);
		// $fdisplay(file_output2, "imm: %b", _246tb_ex7_tb.uut.sccpu.imm);
		// RegFile
		// $fdisplay(file_output2, "RF_W: %b", _246tb_ex7_tb.uut.sccpu.RF_W);
		// $fdisplay(file_output2, "MuxRF_waddr: %b", _246tb_ex7_tb.uut.sccpu.MuxRF_waddr);
		$fdisplay(file_output2, "waddr: %h", _246tb_ex7_tb.uut.sccpu.waddr);
		$fdisplay(file_output2, "wdata: %h", _246tb_ex7_tb.uut.sccpu.wdata);
		// DMEM
		// $fdisplay(file_output2, "dm_addr: %h", _246tb_ex7_tb.uut.dm_addr);
		// $fdisplay(file_output2, "dm_wdata: %h", _246tb_ex7_tb.uut.dm_wdata);
		// $fdisplay(file_output2, "DM_W: %h", _246tb_ex7_tb.uut.DM_W);
		// $fdisplay(file_output2, "DM_EN: %h", _246tb_ex7_tb.uut.DM_EN);
		// MUL & DIV
		$fdisplay(file_output2, "CU-mul_busy: %h", _246tb_ex7_tb.uut.sccpu.CU.mul_busy);
		$fdisplay(file_output2, "CU-DType: %h", _246tb_ex7_tb.uut.sccpu.CU.DType);
		// $fdisplay(file_output2, "divu_busy: %h", _246tb_ex7_tb.uut.sccpu.MUL_DIV.divu_busy);
		// $fdisplay(file_output2, "DIVUcount: %h", _246tb_ex7_tb.uut.sccpu.hi_out);
		// HI LO
		$fdisplay(file_output2, "LO: %h", _246tb_ex7_tb.uut.sccpu.lo_out);
		$fdisplay(file_output2, "HI: %h", _246tb_ex7_tb.uut.sccpu.hi_out);



	end
endmodule

