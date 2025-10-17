// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct 16 17:05:34 2025
// Host        : Luca running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/lucaf/Desktop/spGPU/spGPU.gen/sources_1/bd/design_1/ip/design_1_spCORE_0_0/design_1_spCORE_0_0_stub.v
// Design      : design_1_spCORE_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "design_1_spCORE_0_0,spCORE,{}" *) (* core_generation_info = "design_1_spCORE_0_0,spCORE,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=spCORE,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,INSTR_LENGTH=64,N_opcode=4,N_color=24,N_pixel=8,N_Accelerators=6}" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* ip_definition_source = "module_ref" *) (* x_core_info = "spCORE,Vivado 2024.2" *) 
module design_1_spCORE_0_0(clk, rst, instr_valid, instr_word, core_halt, 
  instr_req, pixel_valid_o, pixel_x_o, FINISH_DEBUG, pixel_y_o, pixel_color_o)
/* synthesis syn_black_box black_box_pad_pin="rst,instr_valid,instr_word[63:0],core_halt,instr_req,pixel_valid_o,pixel_x_o[7:0],FINISH_DEBUG,pixel_y_o[7:0],pixel_color_o[23:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) (* x_interface_mode = "slave clk" *) (* x_interface_parameter = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input clk /* synthesis syn_isclock = 1 */;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 rst RST" *) (* x_interface_mode = "slave rst" *) (* x_interface_parameter = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst;
  input instr_valid;
  input [63:0]instr_word;
  input core_halt;
  output instr_req;
  output pixel_valid_o;
  output [7:0]pixel_x_o;
  output FINISH_DEBUG;
  output [7:0]pixel_y_o;
  output [23:0]pixel_color_o;
endmodule
