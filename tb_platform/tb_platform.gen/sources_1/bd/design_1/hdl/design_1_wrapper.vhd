--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
--Date        : Fri Nov 21 13:26:10 2025
--Host        : luca-pc running 64-bit Ubuntu 24.04.3 LTS
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    M_AXIS_ACLK_0 : in STD_LOGIC;
    M_AXIS_ARESETN_0 : in STD_LOGIC;
    instr_word_0 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    ready_enb_0 : in STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    M_AXIS_ACLK_0 : in STD_LOGIC;
    M_AXIS_ARESETN_0 : in STD_LOGIC;
    instr_word_0 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    ready_enb_0 : in STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      M_AXIS_ACLK_0 => M_AXIS_ACLK_0,
      M_AXIS_ARESETN_0 => M_AXIS_ARESETN_0,
      instr_word_0(63 downto 0) => instr_word_0(63 downto 0),
      ready_enb_0 => ready_enb_0
    );
end STRUCTURE;
