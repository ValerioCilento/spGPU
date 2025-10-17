// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct 16 16:37:55 2025
// Host        : Luca running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/lucaf/Desktop/spGPU/spGPU.gen/sources_1/bd/design_1/ip/design_1_merge_0_0/design_1_merge_0_0_stub.v
// Design      : design_1_merge_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "design_1_merge_0_0,merge,{}" *) (* core_generation_info = "design_1_merge_0_0,merge,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=merge,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED}" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* ip_definition_source = "module_ref" *) (* x_core_info = "merge,Vivado 2024.2" *) 
module design_1_merge_0_0(low_data, upper_data, data64)
/* synthesis syn_black_box black_box_pad_pin="low_data[31:0],upper_data[31:0],data64[63:0]" */;
  input [31:0]low_data;
  input [31:0]upper_data;
  output [63:0]data64;
endmodule
