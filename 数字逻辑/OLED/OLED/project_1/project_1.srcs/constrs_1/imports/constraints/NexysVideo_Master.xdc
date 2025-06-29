
# Clock Signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# LEDs
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {led[7]}]


## Buttons
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports btnC]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports btnD]
#set_property -dict { PACKAGE_PIN C22 IOSTANDARD LVCMOS12 } [get_ports { btnl }]; #IO_L20P_T3_16 Sch=btnl
#set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS12 } [get_ports { btnr }]; #IO_L6P_T0_16 Sch=btnr
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports btnU]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports rstn]

# OLED Display
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports oled_dc]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports oled_res]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports oled_sclk]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports oled_sdin]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports oled_vbat]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports oled_vdd]

### Pmod header JA (if a PmodOLED is to be used)
#set_property -dict { PACKAGE_PIN AB22  IOSTANDARD LVCMOS33 } [get_ports { oled_cs   }]; #IO_L10N_T1_D15_14 Sch=ja[1]#assign oled_cs = 0;
#set_property -dict { PACKAGE_PIN AB21  IOSTANDARD LVCMOS33 } [get_ports { oled_sdin }]; #IO_L10P_T1_D14_14 Sch=ja[2]
##set_property -dict { PACKAGE_PIN AB20  IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=ja[3]
#set_property -dict { PACKAGE_PIN AB18  IOSTANDARD LVCMOS33 } [get_ports { oled_sclk }]; #IO_L17N_T2_A13_D29_14 Sch=ja[4]
#set_property -dict { PACKAGE_PIN Y21   IOSTANDARD LVCMOS33 } [get_ports { oled_dc   }]; #IO_L9P_T1_DQS_14 Sch=ja[7]
#set_property -dict { PACKAGE_PIN AA21  IOSTANDARD LVCMOS33 } [get_ports { oled_res  }]; #IO_L8N_T1_D12_14 Sch=ja[8]
#set_property -dict { PACKAGE_PIN AA20  IOSTANDARD LVCMOS33 } [get_ports { oled_vbat }]; #IO_L8P_T1_D11_14 Sch=ja[9]
#set_property -dict { PACKAGE_PIN AA18  IOSTANDARD LVCMOS33 } [get_ports { oled_vdd  }]; #IO_L17P_T2_A14_D30_14 Sch=ja[10]


