-- (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:spCORE:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_spCORE_0_0 IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    instr_valid : IN STD_LOGIC;
    instr_word : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    core_halt : IN STD_LOGIC;
    instr_req : OUT STD_LOGIC;
    pixel_valid_o : OUT STD_LOGIC;
    pixel_x_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    FINISH_DEBUG : OUT STD_LOGIC;
    pixel_y_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    pixel_color_o : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
END design_1_spCORE_0_0;

ARCHITECTURE design_1_spCORE_0_0_arch OF design_1_spCORE_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_spCORE_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT spCORE IS
    GENERIC (
      INSTR_LENGTH : INTEGER;
      N_opcode : INTEGER;
      N_color : INTEGER;
      N_pixel : INTEGER;
      N_Accelerators : INTEGER
    );
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      instr_valid : IN STD_LOGIC;
      instr_word : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      core_halt : IN STD_LOGIC;
      instr_req : OUT STD_LOGIC;
      pixel_valid_o : OUT STD_LOGIC;
      pixel_x_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      FINISH_DEBUG : OUT STD_LOGIC;
      pixel_y_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      pixel_color_o : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
    );
  END COMPONENT spCORE;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_MODE : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF clk: SIGNAL IS "xilinx.com:signal:clock:1.0 clk CLK";
  ATTRIBUTE X_INTERFACE_MODE OF clk: SIGNAL IS "slave clk";
  ATTRIBUTE X_INTERFACE_PARAMETER OF clk: SIGNAL IS "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF rst: SIGNAL IS "xilinx.com:signal:reset:1.0 rst RST";
  ATTRIBUTE X_INTERFACE_MODE OF rst: SIGNAL IS "slave rst";
  ATTRIBUTE X_INTERFACE_PARAMETER OF rst: SIGNAL IS "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0";
BEGIN
  U0 : spCORE
    GENERIC MAP (
      INSTR_LENGTH => 64,
      N_opcode => 4,
      N_color => 24,
      N_pixel => 8,
      N_Accelerators => 6
    )
    PORT MAP (
      clk => clk,
      rst => rst,
      instr_valid => instr_valid,
      instr_word => instr_word,
      core_halt => core_halt,
      instr_req => instr_req,
      pixel_valid_o => pixel_valid_o,
      pixel_x_o => pixel_x_o,
      FINISH_DEBUG => FINISH_DEBUG,
      pixel_y_o => pixel_y_o,
      pixel_color_o => pixel_color_o
    );
END design_1_spCORE_0_0_arch;
