//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
//Date        : Fri Nov 21 13:16:39 2025
//Host        : luca-pc running 64-bit Ubuntu 24.04.3 LTS
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (M_AXIS_ACLK_0,
    M_AXIS_ARESETN_0,
    instr_word_0,
    ready_enb_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.M_AXIS_ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.M_AXIS_ACLK_0, ASSOCIATED_RESET M_AXIS_ARESETN_0, CLK_DOMAIN design_1_M_AXIS_ACLK_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input M_AXIS_ACLK_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.M_AXIS_ARESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.M_AXIS_ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input M_AXIS_ARESETN_0;
  output [63:0]instr_word_0;
  input ready_enb_0;

  wire M_AXIS_ACLK_0;
  wire M_AXIS_ARESETN_0;
  wire [63:0]blk_mem_gen_0_douta;
  wire [63:0]instr_word_0;
  wire myaxistream_v1_0_0_instr_valid;
  wire ready_enb_0;
  wire [63:0]stream_tx_0_S_AXIS_TDATA;
  wire stream_tx_0_S_AXIS_TREADY;
  wire stream_tx_0_S_AXIS_TVALID;
  wire [12:0]stream_tx_0_addr;
  wire stream_tx_0_enb_rd;

  design_1_blk_mem_gen_0_1 blk_mem_gen_0
       (.addra(stream_tx_0_addr),
        .clka(M_AXIS_ACLK_0),
        .douta(blk_mem_gen_0_douta),
        .ena(stream_tx_0_enb_rd));
  design_1_myaxistream_v1_0_0_0 myaxistream_v1_0_0
       (.instr_valid(myaxistream_v1_0_0_instr_valid),
        .instr_word(instr_word_0),
        .ready_enb(ready_enb_0),
        .s_axis_aclk(M_AXIS_ACLK_0),
        .s_axis_aresetn(M_AXIS_ARESETN_0),
        .s_axis_tdata(stream_tx_0_S_AXIS_TDATA),
        .s_axis_tready(stream_tx_0_S_AXIS_TREADY),
        .s_axis_tvalid(stream_tx_0_S_AXIS_TVALID));
  design_1_stream_tx_0_0 stream_tx_0
       (.M_AXIS_ACLK(M_AXIS_ACLK_0),
        .M_AXIS_ARESETN(M_AXIS_ARESETN_0),
        .M_AXIS_TDATA(stream_tx_0_S_AXIS_TDATA),
        .M_AXIS_TREADY(stream_tx_0_S_AXIS_TREADY),
        .M_AXIS_TVALID(stream_tx_0_S_AXIS_TVALID),
        .addr(stream_tx_0_addr),
        .data(blk_mem_gen_0_douta),
        .enb_rd(stream_tx_0_enb_rd),
        .valid_rx(myaxistream_v1_0_0_instr_valid));
endmodule
