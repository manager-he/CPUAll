// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Sun May 19 16:17:21 2024
// Host        : ManagerHe running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/DigitCircuit/computer_componont/CPU/CPU31/CPU31.srcs/sources_1/ip/iram_ip/iram_ip_stub.v
// Design      : iram_ip
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.1" *)
module iram_ip(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[10:0],spo[31:0]" */;
  input [10:0]a;
  output [31:0]spo;
endmodule
