-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Thu Oct 16 16:37:55 2025
-- Host        : Luca running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/lucaf/Desktop/spGPU/spGPU.gen/sources_1/bd/design_1/ip/design_1_merge_0_0/design_1_merge_0_0_sim_netlist.vhdl
-- Design      : design_1_merge_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_merge_0_0 is
  port (
    low_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    upper_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    data64 : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_merge_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_merge_0_0 : entity is "design_1_merge_0_0,merge,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_1_merge_0_0 : entity is "yes";
  attribute ip_definition_source : string;
  attribute ip_definition_source of design_1_merge_0_0 : entity is "module_ref";
  attribute x_core_info : string;
  attribute x_core_info of design_1_merge_0_0 : entity is "merge,Vivado 2024.2";
end design_1_merge_0_0;

architecture STRUCTURE of design_1_merge_0_0 is
  signal \^low_data\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^upper_data\ : STD_LOGIC_VECTOR ( 31 downto 0 );
begin
  \^low_data\(31 downto 0) <= low_data(31 downto 0);
  \^upper_data\(31 downto 0) <= upper_data(31 downto 0);
  data64(63 downto 32) <= \^upper_data\(31 downto 0);
  data64(31 downto 0) <= \^low_data\(31 downto 0);
end STRUCTURE;
