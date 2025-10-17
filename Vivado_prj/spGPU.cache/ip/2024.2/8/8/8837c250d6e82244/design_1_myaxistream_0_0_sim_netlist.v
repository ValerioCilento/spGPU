// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Oct 15 18:33:59 2025
// Host        : Luca running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_myaxistream_0_0_sim_netlist.v
// Design      : design_1_myaxistream_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_myaxistream_0_0,myaxistream_v1_0,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "myaxistream_v1_0,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (ready_enb,
    data_1_o,
    data_2_o,
    s_axis_aclk,
    s_axis_aresetn,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tvalid);
  input ready_enb;
  output [31:0]data_1_o;
  output [31:0]data_2_o;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 S_AXIS_CLK CLK" *) (* x_interface_mode = "slave S_AXIS_CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_CLK, ASSOCIATED_BUSIF S_AXIS, ASSOCIATED_RESET s_axis_aresetn, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axis_aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 S_AXIS_RST RST" *) (* x_interface_mode = "slave S_AXIS_RST" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axis_aresetn;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *) (* x_interface_mode = "slave S_AXIS" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output s_axis_tready;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *) input [63:0]s_axis_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *) input s_axis_tvalid;

  wire ready_enb;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [63:0]s_axis_tdata;
  wire s_axis_tready;
  wire s_axis_tvalid;

  assign data_1_o[31:0] = s_axis_tdata[31:0];
  assign data_2_o[31:0] = s_axis_tdata[63:32];
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0 U0
       (.ready_enb(ready_enb),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tready(s_axis_tready),
        .s_axis_tvalid(s_axis_tvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0
   (s_axis_tready,
    s_axis_tvalid,
    s_axis_aresetn,
    ready_enb,
    s_axis_aclk);
  output s_axis_tready;
  input s_axis_tvalid;
  input s_axis_aresetn;
  input ready_enb;
  input s_axis_aclk;

  wire ready_enb;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire s_axis_tready;
  wire s_axis_tvalid;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0_S_AXIS myaxistream_v1_0_S_AXIS_inst
       (.ready_enb(ready_enb),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tready(s_axis_tready),
        .s_axis_tvalid(s_axis_tvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0_S_AXIS
   (s_axis_tready,
    s_axis_tvalid,
    s_axis_aresetn,
    ready_enb,
    s_axis_aclk);
  output s_axis_tready;
  input s_axis_tvalid;
  input s_axis_aresetn;
  input ready_enb;
  input s_axis_aclk;

  wire \FSM_sequential_state_t[0]_i_1_n_0 ;
  wire \FSM_sequential_state_t[1]_i_1_n_0 ;
  wire ready_enb;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire s_axis_tready;
  wire s_axis_tvalid;
  wire [1:0]state_t;
  wire tready_i_1_n_0;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h15100000)) 
    \FSM_sequential_state_t[0]_i_1 
       (.I0(state_t[1]),
        .I1(s_axis_tvalid),
        .I2(state_t[0]),
        .I3(ready_enb),
        .I4(s_axis_aresetn),
        .O(\FSM_sequential_state_t[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0800)) 
    \FSM_sequential_state_t[1]_i_1 
       (.I0(s_axis_tvalid),
        .I1(state_t[0]),
        .I2(state_t[1]),
        .I3(s_axis_aresetn),
        .O(\FSM_sequential_state_t[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "wait_s:00,tx1_s:01,tx2_s:10" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_t_reg[0] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_state_t[0]_i_1_n_0 ),
        .Q(state_t[0]),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "wait_s:00,tx1_s:01,tx2_s:10" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_t_reg[1] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_state_t[1]_i_1_n_0 ),
        .Q(state_t[1]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h40)) 
    tready_i_1
       (.I0(state_t[1]),
        .I1(state_t[0]),
        .I2(s_axis_aresetn),
        .O(tready_i_1_n_0));
  FDRE tready_reg
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(tready_i_1_n_0),
        .Q(s_axis_tready),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
