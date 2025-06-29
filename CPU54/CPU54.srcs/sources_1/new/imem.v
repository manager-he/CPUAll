`timescale 1ns / 1ps
module IMEM (
    input rst,
    input [31:0] pc,
    output [31:0] inst
);

iram iram (
  .a(pc),
  .spo(inst)
);
    
endmodule