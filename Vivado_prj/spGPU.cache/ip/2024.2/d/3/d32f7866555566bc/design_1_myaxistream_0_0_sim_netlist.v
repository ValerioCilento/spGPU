// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Oct 15 19:43:55 2025
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

  wire [31:0]data_1_o;
  wire [31:0]data_2_o;
  wire ready_enb;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [63:0]s_axis_tdata;
  wire s_axis_tready;
  wire s_axis_tvalid;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0 U0
       (.data_1_o(data_1_o),
        .data_2_o(data_2_o),
        .ready_enb(ready_enb),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tready(s_axis_tready),
        .s_axis_tvalid(s_axis_tvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0
   (data_1_o,
    data_2_o,
    s_axis_tready,
    s_axis_aclk,
    ready_enb,
    s_axis_tvalid,
    s_axis_tdata,
    s_axis_aresetn);
  output [31:0]data_1_o;
  output [31:0]data_2_o;
  output s_axis_tready;
  input s_axis_aclk;
  input ready_enb;
  input s_axis_tvalid;
  input [63:0]s_axis_tdata;
  input s_axis_aresetn;

  wire [31:0]data_1_o;
  wire [31:0]data_2_o;
  wire ready_enb;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [63:0]s_axis_tdata;
  wire s_axis_tready;
  wire s_axis_tvalid;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0_S_AXIS myaxistream_v1_0_S_AXIS_inst
       (.data_1_o(data_1_o),
        .data_2_o(data_2_o),
        .ready_enb(ready_enb),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tready(s_axis_tready),
        .s_axis_tvalid(s_axis_tvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_myaxistream_v1_0_S_AXIS
   (data_1_o,
    data_2_o,
    s_axis_tready,
    s_axis_aclk,
    ready_enb,
    s_axis_tvalid,
    s_axis_tdata,
    s_axis_aresetn);
  output [31:0]data_1_o;
  output [31:0]data_2_o;
  output s_axis_tready;
  input s_axis_aclk;
  input ready_enb;
  input s_axis_tvalid;
  input [63:0]s_axis_tdata;
  input s_axis_aresetn;

  wire \FSM_onehot_state_t[0]_i_1_n_0 ;
  wire \FSM_onehot_state_t[1]_i_1_n_0 ;
  wire \FSM_onehot_state_t[2]_i_1_n_0 ;
  wire \FSM_onehot_state_t_reg_n_0_[0] ;
  wire \FSM_onehot_state_t_reg_n_0_[2] ;
  wire [31:0]data_1_o;
  wire \data_1_o[31]_i_1_n_0 ;
  wire [31:0]data_2_o;
  wire ready_enb;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [63:0]s_axis_tdata;
  wire s_axis_tready;
  wire s_axis_tvalid;
  wire tready;

  LUT3 #(
    .INIT(8'hBA)) 
    \FSM_onehot_state_t[0]_i_1 
       (.I0(\FSM_onehot_state_t_reg_n_0_[2] ),
        .I1(ready_enb),
        .I2(\FSM_onehot_state_t_reg_n_0_[0] ),
        .O(\FSM_onehot_state_t[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_state_t[1]_i_1 
       (.I0(ready_enb),
        .I1(\FSM_onehot_state_t_reg_n_0_[0] ),
        .I2(s_axis_tvalid),
        .I3(tready),
        .O(\FSM_onehot_state_t[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_state_t[2]_i_1 
       (.I0(tready),
        .I1(s_axis_tvalid),
        .O(\FSM_onehot_state_t[2]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "wait_s:001,tx1_s:010,tx2_s:100" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_t_reg[0] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state_t[0]_i_1_n_0 ),
        .Q(\FSM_onehot_state_t_reg_n_0_[0] ),
        .S(\data_1_o[31]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "wait_s:001,tx1_s:010,tx2_s:100" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_t_reg[1] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state_t[1]_i_1_n_0 ),
        .Q(tready),
        .R(\data_1_o[31]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "wait_s:001,tx1_s:010,tx2_s:100" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_t_reg[2] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state_t[2]_i_1_n_0 ),
        .Q(\FSM_onehot_state_t_reg_n_0_[2] ),
        .R(\data_1_o[31]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \data_1_o[31]_i_1 
       (.I0(s_axis_aresetn),
        .O(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[0] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[0]),
        .Q(data_1_o[0]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[10] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[10]),
        .Q(data_1_o[10]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[11] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[11]),
        .Q(data_1_o[11]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[12] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[12]),
        .Q(data_1_o[12]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[13] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[13]),
        .Q(data_1_o[13]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[14] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[14]),
        .Q(data_1_o[14]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[15] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[15]),
        .Q(data_1_o[15]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[16] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[16]),
        .Q(data_1_o[16]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[17] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[17]),
        .Q(data_1_o[17]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[18] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[18]),
        .Q(data_1_o[18]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[19] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[19]),
        .Q(data_1_o[19]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[1] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[1]),
        .Q(data_1_o[1]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[20] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[20]),
        .Q(data_1_o[20]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[21] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[21]),
        .Q(data_1_o[21]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[22] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[22]),
        .Q(data_1_o[22]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[23] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[23]),
        .Q(data_1_o[23]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[24] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[24]),
        .Q(data_1_o[24]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[25] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[25]),
        .Q(data_1_o[25]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[26] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[26]),
        .Q(data_1_o[26]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[27] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[27]),
        .Q(data_1_o[27]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[28] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[28]),
        .Q(data_1_o[28]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[29] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[29]),
        .Q(data_1_o[29]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[2] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[2]),
        .Q(data_1_o[2]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[30] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[30]),
        .Q(data_1_o[30]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[31] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[31]),
        .Q(data_1_o[31]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[3] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[3]),
        .Q(data_1_o[3]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[4] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[4]),
        .Q(data_1_o[4]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[5] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[5]),
        .Q(data_1_o[5]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[6] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[6]),
        .Q(data_1_o[6]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[7] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[7]),
        .Q(data_1_o[7]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[8] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[8]),
        .Q(data_1_o[8]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_1_o_reg[9] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[9]),
        .Q(data_1_o[9]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[0] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[32]),
        .Q(data_2_o[0]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[10] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[42]),
        .Q(data_2_o[10]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[11] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[43]),
        .Q(data_2_o[11]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[12] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[44]),
        .Q(data_2_o[12]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[13] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[45]),
        .Q(data_2_o[13]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[14] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[46]),
        .Q(data_2_o[14]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[15] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[47]),
        .Q(data_2_o[15]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[16] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[48]),
        .Q(data_2_o[16]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[17] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[49]),
        .Q(data_2_o[17]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[18] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[50]),
        .Q(data_2_o[18]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[19] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[51]),
        .Q(data_2_o[19]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[1] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[33]),
        .Q(data_2_o[1]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[20] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[52]),
        .Q(data_2_o[20]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[21] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[53]),
        .Q(data_2_o[21]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[22] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[54]),
        .Q(data_2_o[22]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[23] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[55]),
        .Q(data_2_o[23]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[24] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[56]),
        .Q(data_2_o[24]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[25] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[57]),
        .Q(data_2_o[25]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[26] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[58]),
        .Q(data_2_o[26]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[27] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[59]),
        .Q(data_2_o[27]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[28] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[60]),
        .Q(data_2_o[28]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[29] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[61]),
        .Q(data_2_o[29]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[2] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[34]),
        .Q(data_2_o[2]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[30] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[62]),
        .Q(data_2_o[30]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[31] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[63]),
        .Q(data_2_o[31]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[3] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[35]),
        .Q(data_2_o[3]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[4] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[36]),
        .Q(data_2_o[4]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[5] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[37]),
        .Q(data_2_o[5]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[6] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[38]),
        .Q(data_2_o[6]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[7] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[39]),
        .Q(data_2_o[7]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[8] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[40]),
        .Q(data_2_o[8]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE \data_2_o_reg[9] 
       (.C(s_axis_aclk),
        .CE(\FSM_onehot_state_t_reg_n_0_[2] ),
        .D(s_axis_tdata[41]),
        .Q(data_2_o[9]),
        .R(\data_1_o[31]_i_1_n_0 ));
  FDRE tready_reg
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(tready),
        .Q(s_axis_tready),
        .R(\data_1_o[31]_i_1_n_0 ));
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
