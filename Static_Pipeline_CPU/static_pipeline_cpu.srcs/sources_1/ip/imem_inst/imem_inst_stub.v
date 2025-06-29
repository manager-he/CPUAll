// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Wed Oct 30 10:51:09 2024
// Host        : ManagerHe running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/DigitCircuit/computer_componont/CPU/static_pipeline_cpu/static_pipeline_cpu.srcs/sources_1/ip/imem_inst/imem_inst_stub.v
// Design      : imem_inst
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.1" *)
module imem_inst(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],spo[15:0]" */;
  input [7:0]a;
  output [15:0]spo;
endmodule
