-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Thu Oct 16 16:37:55 2025
-- Host        : Luca running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/lucaf/Desktop/spGPU/spGPU.gen/sources_1/bd/design_1/ip/design_1_RegDebug_0_0/design_1_RegDebug_0_0_sim_netlist.vhdl
-- Design      : design_1_RegDebug_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_RegDebug_0_0_RegDebug is
  port (
    debug_x : out STD_LOGIC_VECTOR ( 7 downto 0 );
    debug_y : out STD_LOGIC_VECTOR ( 7 downto 0 );
    debug_color : out STD_LOGIC_VECTOR ( 23 downto 0 );
    x : in STD_LOGIC_VECTOR ( 7 downto 0 );
    clk : in STD_LOGIC;
    y : in STD_LOGIC_VECTOR ( 7 downto 0 );
    color : in STD_LOGIC_VECTOR ( 23 downto 0 );
    rst : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_RegDebug_0_0_RegDebug : entity is "RegDebug";
end design_1_RegDebug_0_0_RegDebug;

architecture STRUCTURE of design_1_RegDebug_0_0_RegDebug is
  signal \debug_color[23]_i_1_n_0\ : STD_LOGIC;
  signal \debug_color[23]_i_2_n_0\ : STD_LOGIC;
  signal \debug_color[23]_i_3_n_0\ : STD_LOGIC;
  signal \debug_color[23]_i_4_n_0\ : STD_LOGIC;
  signal \debug_color[23]_i_5_n_0\ : STD_LOGIC;
  signal \debug_x[7]_i_2_n_0\ : STD_LOGIC;
  signal \debug_x[7]_i_3_n_0\ : STD_LOGIC;
  signal \debug_y[7]_i_1_n_0\ : STD_LOGIC;
  signal \debug_y[7]_i_2_n_0\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
begin
\debug_color[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBFF"
    )
        port map (
      I0 => \debug_color[23]_i_2_n_0\,
      I1 => \debug_color[23]_i_3_n_0\,
      I2 => \debug_color[23]_i_4_n_0\,
      I3 => \debug_color[23]_i_5_n_0\,
      O => \debug_color[23]_i_1_n_0\
    );
\debug_color[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => color(2),
      I1 => color(0),
      I2 => color(1),
      I3 => color(5),
      I4 => color(3),
      I5 => color(4),
      O => \debug_color[23]_i_2_n_0\
    );
\debug_color[23]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => color(11),
      I1 => color(9),
      I2 => color(10),
      I3 => color(6),
      I4 => color(7),
      I5 => color(8),
      O => \debug_color[23]_i_3_n_0\
    );
\debug_color[23]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => color(14),
      I1 => color(12),
      I2 => color(13),
      I3 => color(17),
      I4 => color(15),
      I5 => color(16),
      O => \debug_color[23]_i_4_n_0\
    );
\debug_color[23]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => color(22),
      I1 => color(21),
      I2 => color(23),
      I3 => color(18),
      I4 => color(19),
      I5 => color(20),
      O => \debug_color[23]_i_5_n_0\
    );
\debug_color_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(0),
      Q => debug_color(0)
    );
\debug_color_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(10),
      Q => debug_color(10)
    );
\debug_color_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(11),
      Q => debug_color(11)
    );
\debug_color_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(12),
      Q => debug_color(12)
    );
\debug_color_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(13),
      Q => debug_color(13)
    );
\debug_color_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(14),
      Q => debug_color(14)
    );
\debug_color_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(15),
      Q => debug_color(15)
    );
\debug_color_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(16),
      Q => debug_color(16)
    );
\debug_color_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(17),
      Q => debug_color(17)
    );
\debug_color_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(18),
      Q => debug_color(18)
    );
\debug_color_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(19),
      Q => debug_color(19)
    );
\debug_color_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(1),
      Q => debug_color(1)
    );
\debug_color_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(20),
      Q => debug_color(20)
    );
\debug_color_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(21),
      Q => debug_color(21)
    );
\debug_color_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(22),
      Q => debug_color(22)
    );
\debug_color_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(23),
      Q => debug_color(23)
    );
\debug_color_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(2),
      Q => debug_color(2)
    );
\debug_color_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(3),
      Q => debug_color(3)
    );
\debug_color_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(4),
      Q => debug_color(4)
    );
\debug_color_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(5),
      Q => debug_color(5)
    );
\debug_color_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(6),
      Q => debug_color(6)
    );
\debug_color_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(7),
      Q => debug_color(7)
    );
\debug_color_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(8),
      Q => debug_color(8)
    );
\debug_color_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_color[23]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => color(9),
      Q => debug_color(9)
    );
\debug_x[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFEFFFF"
    )
        port map (
      I0 => x(0),
      I1 => x(1),
      I2 => x(2),
      I3 => x(3),
      I4 => \debug_x[7]_i_3_n_0\,
      O => p_0_in
    );
\debug_x[7]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst,
      O => \debug_x[7]_i_2_n_0\
    );
\debug_x[7]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => x(6),
      I1 => x(7),
      I2 => x(5),
      I3 => x(4),
      O => \debug_x[7]_i_3_n_0\
    );
\debug_x_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(0),
      Q => debug_x(0)
    );
\debug_x_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(1),
      Q => debug_x(1)
    );
\debug_x_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(2),
      Q => debug_x(2)
    );
\debug_x_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(3),
      Q => debug_x(3)
    );
\debug_x_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(4),
      Q => debug_x(4)
    );
\debug_x_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(5),
      Q => debug_x(5)
    );
\debug_x_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(6),
      Q => debug_x(6)
    );
\debug_x_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => p_0_in,
      CLR => \debug_x[7]_i_2_n_0\,
      D => x(7),
      Q => debug_x(7)
    );
\debug_y[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFEFFFF"
    )
        port map (
      I0 => y(0),
      I1 => y(1),
      I2 => y(2),
      I3 => y(3),
      I4 => \debug_y[7]_i_2_n_0\,
      O => \debug_y[7]_i_1_n_0\
    );
\debug_y[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => y(6),
      I1 => y(7),
      I2 => y(5),
      I3 => y(4),
      O => \debug_y[7]_i_2_n_0\
    );
\debug_y_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(0),
      Q => debug_y(0)
    );
\debug_y_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(1),
      Q => debug_y(1)
    );
\debug_y_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(2),
      Q => debug_y(2)
    );
\debug_y_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(3),
      Q => debug_y(3)
    );
\debug_y_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(4),
      Q => debug_y(4)
    );
\debug_y_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(5),
      Q => debug_y(5)
    );
\debug_y_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(6),
      Q => debug_y(6)
    );
\debug_y_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \debug_y[7]_i_1_n_0\,
      CLR => \debug_x[7]_i_2_n_0\,
      D => y(7),
      Q => debug_y(7)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_RegDebug_0_0 is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    x : in STD_LOGIC_VECTOR ( 7 downto 0 );
    y : in STD_LOGIC_VECTOR ( 7 downto 0 );
    color : in STD_LOGIC_VECTOR ( 23 downto 0 );
    debug_x : out STD_LOGIC_VECTOR ( 7 downto 0 );
    debug_y : out STD_LOGIC_VECTOR ( 7 downto 0 );
    debug_color : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_RegDebug_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_RegDebug_0_0 : entity is "design_1_RegDebug_0_0,RegDebug,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_1_RegDebug_0_0 : entity is "yes";
  attribute ip_definition_source : string;
  attribute ip_definition_source of design_1_RegDebug_0_0 : entity is "module_ref";
  attribute x_core_info : string;
  attribute x_core_info of design_1_RegDebug_0_0 : entity is "RegDebug,Vivado 2024.2";
end design_1_RegDebug_0_0;

architecture STRUCTURE of design_1_RegDebug_0_0 is
  attribute x_interface_info : string;
  attribute x_interface_info of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute x_interface_mode : string;
  attribute x_interface_mode of clk : signal is "slave clk";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of clk : signal is "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute x_interface_info of rst : signal is "xilinx.com:signal:reset:1.0 rst RST";
  attribute x_interface_mode of rst : signal is "slave rst";
  attribute x_interface_parameter of rst : signal is "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
U0: entity work.design_1_RegDebug_0_0_RegDebug
     port map (
      clk => clk,
      color(23 downto 0) => color(23 downto 0),
      debug_color(23 downto 0) => debug_color(23 downto 0),
      debug_x(7 downto 0) => debug_x(7 downto 0),
      debug_y(7 downto 0) => debug_y(7 downto 0),
      rst => rst,
      x(7 downto 0) => x(7 downto 0),
      y(7 downto 0) => y(7 downto 0)
    );
end STRUCTURE;
