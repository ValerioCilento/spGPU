// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct 16 16:37:55 2025
// Host        : Luca running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/lucaf/Desktop/spGPU/spGPU.gen/sources_1/bd/design_1/ip/design_1_RegDebug_0_0/design_1_RegDebug_0_0_sim_netlist.v
// Design      : design_1_RegDebug_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_RegDebug_0_0,RegDebug,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* ip_definition_source = "module_ref" *) 
(* x_core_info = "RegDebug,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module design_1_RegDebug_0_0
   (clk,
    rst,
    x,
    y,
    color,
    debug_x,
    debug_y,
    debug_color);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) (* x_interface_mode = "slave clk" *) (* x_interface_parameter = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input clk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 rst RST" *) (* x_interface_mode = "slave rst" *) (* x_interface_parameter = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst;
  input [7:0]x;
  input [7:0]y;
  input [23:0]color;
  output [7:0]debug_x;
  output [7:0]debug_y;
  output [23:0]debug_color;

  wire clk;
  wire [23:0]color;
  wire [23:0]debug_color;
  wire [7:0]debug_x;
  wire [7:0]debug_y;
  wire rst;
  wire [7:0]x;
  wire [7:0]y;

  design_1_RegDebug_0_0_RegDebug U0
       (.clk(clk),
        .color(color),
        .debug_color(debug_color),
        .debug_x(debug_x),
        .debug_y(debug_y),
        .rst(rst),
        .x(x),
        .y(y));
endmodule

(* ORIG_REF_NAME = "RegDebug" *) 
module design_1_RegDebug_0_0_RegDebug
   (debug_x,
    debug_y,
    debug_color,
    x,
    clk,
    y,
    color,
    rst);
  output [7:0]debug_x;
  output [7:0]debug_y;
  output [23:0]debug_color;
  input [7:0]x;
  input clk;
  input [7:0]y;
  input [23:0]color;
  input rst;

  wire clk;
  wire [23:0]color;
  wire [23:0]debug_color;
  wire \debug_color[23]_i_1_n_0 ;
  wire \debug_color[23]_i_2_n_0 ;
  wire \debug_color[23]_i_3_n_0 ;
  wire \debug_color[23]_i_4_n_0 ;
  wire \debug_color[23]_i_5_n_0 ;
  wire [7:0]debug_x;
  wire \debug_x[7]_i_2_n_0 ;
  wire \debug_x[7]_i_3_n_0 ;
  wire [7:0]debug_y;
  wire \debug_y[7]_i_1_n_0 ;
  wire \debug_y[7]_i_2_n_0 ;
  wire p_0_in;
  wire rst;
  wire [7:0]x;
  wire [7:0]y;

  LUT4 #(
    .INIT(16'hFBFF)) 
    \debug_color[23]_i_1 
       (.I0(\debug_color[23]_i_2_n_0 ),
        .I1(\debug_color[23]_i_3_n_0 ),
        .I2(\debug_color[23]_i_4_n_0 ),
        .I3(\debug_color[23]_i_5_n_0 ),
        .O(\debug_color[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \debug_color[23]_i_2 
       (.I0(color[2]),
        .I1(color[0]),
        .I2(color[1]),
        .I3(color[5]),
        .I4(color[3]),
        .I5(color[4]),
        .O(\debug_color[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \debug_color[23]_i_3 
       (.I0(color[11]),
        .I1(color[9]),
        .I2(color[10]),
        .I3(color[6]),
        .I4(color[7]),
        .I5(color[8]),
        .O(\debug_color[23]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \debug_color[23]_i_4 
       (.I0(color[14]),
        .I1(color[12]),
        .I2(color[13]),
        .I3(color[17]),
        .I4(color[15]),
        .I5(color[16]),
        .O(\debug_color[23]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \debug_color[23]_i_5 
       (.I0(color[22]),
        .I1(color[21]),
        .I2(color[23]),
        .I3(color[18]),
        .I4(color[19]),
        .I5(color[20]),
        .O(\debug_color[23]_i_5_n_0 ));
  FDCE \debug_color_reg[0] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[0]),
        .Q(debug_color[0]));
  FDCE \debug_color_reg[10] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[10]),
        .Q(debug_color[10]));
  FDCE \debug_color_reg[11] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[11]),
        .Q(debug_color[11]));
  FDCE \debug_color_reg[12] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[12]),
        .Q(debug_color[12]));
  FDCE \debug_color_reg[13] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[13]),
        .Q(debug_color[13]));
  FDCE \debug_color_reg[14] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[14]),
        .Q(debug_color[14]));
  FDCE \debug_color_reg[15] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[15]),
        .Q(debug_color[15]));
  FDCE \debug_color_reg[16] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[16]),
        .Q(debug_color[16]));
  FDCE \debug_color_reg[17] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[17]),
        .Q(debug_color[17]));
  FDCE \debug_color_reg[18] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[18]),
        .Q(debug_color[18]));
  FDCE \debug_color_reg[19] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[19]),
        .Q(debug_color[19]));
  FDCE \debug_color_reg[1] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[1]),
        .Q(debug_color[1]));
  FDCE \debug_color_reg[20] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[20]),
        .Q(debug_color[20]));
  FDCE \debug_color_reg[21] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[21]),
        .Q(debug_color[21]));
  FDCE \debug_color_reg[22] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[22]),
        .Q(debug_color[22]));
  FDCE \debug_color_reg[23] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[23]),
        .Q(debug_color[23]));
  FDCE \debug_color_reg[2] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[2]),
        .Q(debug_color[2]));
  FDCE \debug_color_reg[3] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[3]),
        .Q(debug_color[3]));
  FDCE \debug_color_reg[4] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[4]),
        .Q(debug_color[4]));
  FDCE \debug_color_reg[5] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[5]),
        .Q(debug_color[5]));
  FDCE \debug_color_reg[6] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[6]),
        .Q(debug_color[6]));
  FDCE \debug_color_reg[7] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[7]),
        .Q(debug_color[7]));
  FDCE \debug_color_reg[8] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[8]),
        .Q(debug_color[8]));
  FDCE \debug_color_reg[9] 
       (.C(clk),
        .CE(\debug_color[23]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(color[9]),
        .Q(debug_color[9]));
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    \debug_x[7]_i_1 
       (.I0(x[0]),
        .I1(x[1]),
        .I2(x[2]),
        .I3(x[3]),
        .I4(\debug_x[7]_i_3_n_0 ),
        .O(p_0_in));
  LUT1 #(
    .INIT(2'h1)) 
    \debug_x[7]_i_2 
       (.I0(rst),
        .O(\debug_x[7]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \debug_x[7]_i_3 
       (.I0(x[6]),
        .I1(x[7]),
        .I2(x[5]),
        .I3(x[4]),
        .O(\debug_x[7]_i_3_n_0 ));
  FDCE \debug_x_reg[0] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[0]),
        .Q(debug_x[0]));
  FDCE \debug_x_reg[1] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[1]),
        .Q(debug_x[1]));
  FDCE \debug_x_reg[2] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[2]),
        .Q(debug_x[2]));
  FDCE \debug_x_reg[3] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[3]),
        .Q(debug_x[3]));
  FDCE \debug_x_reg[4] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[4]),
        .Q(debug_x[4]));
  FDCE \debug_x_reg[5] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[5]),
        .Q(debug_x[5]));
  FDCE \debug_x_reg[6] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[6]),
        .Q(debug_x[6]));
  FDCE \debug_x_reg[7] 
       (.C(clk),
        .CE(p_0_in),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(x[7]),
        .Q(debug_x[7]));
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    \debug_y[7]_i_1 
       (.I0(y[0]),
        .I1(y[1]),
        .I2(y[2]),
        .I3(y[3]),
        .I4(\debug_y[7]_i_2_n_0 ),
        .O(\debug_y[7]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \debug_y[7]_i_2 
       (.I0(y[6]),
        .I1(y[7]),
        .I2(y[5]),
        .I3(y[4]),
        .O(\debug_y[7]_i_2_n_0 ));
  FDCE \debug_y_reg[0] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[0]),
        .Q(debug_y[0]));
  FDCE \debug_y_reg[1] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[1]),
        .Q(debug_y[1]));
  FDCE \debug_y_reg[2] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[2]),
        .Q(debug_y[2]));
  FDCE \debug_y_reg[3] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[3]),
        .Q(debug_y[3]));
  FDCE \debug_y_reg[4] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[4]),
        .Q(debug_y[4]));
  FDCE \debug_y_reg[5] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[5]),
        .Q(debug_y[5]));
  FDCE \debug_y_reg[6] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[6]),
        .Q(debug_y[6]));
  FDCE \debug_y_reg[7] 
       (.C(clk),
        .CE(\debug_y[7]_i_1_n_0 ),
        .CLR(\debug_x[7]_i_2_n_0 ),
        .D(y[7]),
        .Q(debug_y[7]));
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
