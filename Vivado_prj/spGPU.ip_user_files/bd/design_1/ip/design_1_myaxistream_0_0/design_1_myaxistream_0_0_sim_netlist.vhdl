-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Thu Oct 16 16:37:56 2025
-- Host        : Luca running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/lucaf/Desktop/spGPU/spGPU.gen/sources_1/bd/design_1/ip/design_1_myaxistream_0_0/design_1_myaxistream_0_0_sim_netlist.vhdl
-- Design      : design_1_myaxistream_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_myaxistream_0_0_myaxistream_v1_0_S_AXIS is
  port (
    s_axis_tready : out STD_LOGIC;
    data_1_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    data_2_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    ready_enb : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_aresetn : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_myaxistream_0_0_myaxistream_v1_0_S_AXIS : entity is "myaxistream_v1_0_S_AXIS";
end design_1_myaxistream_0_0_myaxistream_v1_0_S_AXIS;

architecture STRUCTURE of design_1_myaxistream_0_0_myaxistream_v1_0_S_AXIS is
  signal \FSM_onehot_state_t[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_t[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_t[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_t_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_state_t_reg_n_0_[2]\ : STD_LOGIC;
  signal fsm_start_edge : STD_LOGIC;
  signal fsm_start_edge_i_1_n_0 : STD_LOGIC;
  signal fsm_start_prev : STD_LOGIC;
  signal tready : STD_LOGIC;
  signal tready_i_1_n_0 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_state_t[1]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_onehot_state_t[2]_i_1\ : label is "soft_lutpair0";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_t_reg[0]\ : label is "wait_s:001,tx1_s:010,tx2_s:100";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_t_reg[1]\ : label is "wait_s:001,tx1_s:010,tx2_s:100";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_t_reg[2]\ : label is "wait_s:001,tx1_s:010,tx2_s:100";
begin
\FSM_onehot_state_t[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => \FSM_onehot_state_t_reg_n_0_[2]\,
      I1 => fsm_start_edge,
      I2 => \FSM_onehot_state_t_reg_n_0_[0]\,
      O => \FSM_onehot_state_t[0]_i_1_n_0\
    );
\FSM_onehot_state_t[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => fsm_start_edge,
      I1 => \FSM_onehot_state_t_reg_n_0_[0]\,
      I2 => s_axis_tvalid,
      I3 => tready,
      O => \FSM_onehot_state_t[1]_i_1_n_0\
    );
\FSM_onehot_state_t[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => tready,
      I1 => s_axis_tvalid,
      O => \FSM_onehot_state_t[2]_i_1_n_0\
    );
\FSM_onehot_state_t_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axis_aclk,
      CE => '1',
      D => \FSM_onehot_state_t[0]_i_1_n_0\,
      Q => \FSM_onehot_state_t_reg_n_0_[0]\,
      S => tready_i_1_n_0
    );
\FSM_onehot_state_t_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axis_aclk,
      CE => '1',
      D => \FSM_onehot_state_t[1]_i_1_n_0\,
      Q => tready,
      R => tready_i_1_n_0
    );
\FSM_onehot_state_t_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axis_aclk,
      CE => '1',
      D => \FSM_onehot_state_t[2]_i_1_n_0\,
      Q => \FSM_onehot_state_t_reg_n_0_[2]\,
      R => tready_i_1_n_0
    );
\data_1_o_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(0),
      Q => data_1_o(0),
      R => tready_i_1_n_0
    );
\data_1_o_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(10),
      Q => data_1_o(10),
      R => tready_i_1_n_0
    );
\data_1_o_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(11),
      Q => data_1_o(11),
      R => tready_i_1_n_0
    );
\data_1_o_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(12),
      Q => data_1_o(12),
      R => tready_i_1_n_0
    );
\data_1_o_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(13),
      Q => data_1_o(13),
      R => tready_i_1_n_0
    );
\data_1_o_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(14),
      Q => data_1_o(14),
      R => tready_i_1_n_0
    );
\data_1_o_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(15),
      Q => data_1_o(15),
      R => tready_i_1_n_0
    );
\data_1_o_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(16),
      Q => data_1_o(16),
      R => tready_i_1_n_0
    );
\data_1_o_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(17),
      Q => data_1_o(17),
      R => tready_i_1_n_0
    );
\data_1_o_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(18),
      Q => data_1_o(18),
      R => tready_i_1_n_0
    );
\data_1_o_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(19),
      Q => data_1_o(19),
      R => tready_i_1_n_0
    );
\data_1_o_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(1),
      Q => data_1_o(1),
      R => tready_i_1_n_0
    );
\data_1_o_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(20),
      Q => data_1_o(20),
      R => tready_i_1_n_0
    );
\data_1_o_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(21),
      Q => data_1_o(21),
      R => tready_i_1_n_0
    );
\data_1_o_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(22),
      Q => data_1_o(22),
      R => tready_i_1_n_0
    );
\data_1_o_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(23),
      Q => data_1_o(23),
      R => tready_i_1_n_0
    );
\data_1_o_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(24),
      Q => data_1_o(24),
      R => tready_i_1_n_0
    );
\data_1_o_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(25),
      Q => data_1_o(25),
      R => tready_i_1_n_0
    );
\data_1_o_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(26),
      Q => data_1_o(26),
      R => tready_i_1_n_0
    );
\data_1_o_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(27),
      Q => data_1_o(27),
      R => tready_i_1_n_0
    );
\data_1_o_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(28),
      Q => data_1_o(28),
      R => tready_i_1_n_0
    );
\data_1_o_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(29),
      Q => data_1_o(29),
      R => tready_i_1_n_0
    );
\data_1_o_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(2),
      Q => data_1_o(2),
      R => tready_i_1_n_0
    );
\data_1_o_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(30),
      Q => data_1_o(30),
      R => tready_i_1_n_0
    );
\data_1_o_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(31),
      Q => data_1_o(31),
      R => tready_i_1_n_0
    );
\data_1_o_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(3),
      Q => data_1_o(3),
      R => tready_i_1_n_0
    );
\data_1_o_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(4),
      Q => data_1_o(4),
      R => tready_i_1_n_0
    );
\data_1_o_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(5),
      Q => data_1_o(5),
      R => tready_i_1_n_0
    );
\data_1_o_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(6),
      Q => data_1_o(6),
      R => tready_i_1_n_0
    );
\data_1_o_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(7),
      Q => data_1_o(7),
      R => tready_i_1_n_0
    );
\data_1_o_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(8),
      Q => data_1_o(8),
      R => tready_i_1_n_0
    );
\data_1_o_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(9),
      Q => data_1_o(9),
      R => tready_i_1_n_0
    );
\data_2_o_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(32),
      Q => data_2_o(0),
      R => tready_i_1_n_0
    );
\data_2_o_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(42),
      Q => data_2_o(10),
      R => tready_i_1_n_0
    );
\data_2_o_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(43),
      Q => data_2_o(11),
      R => tready_i_1_n_0
    );
\data_2_o_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(44),
      Q => data_2_o(12),
      R => tready_i_1_n_0
    );
\data_2_o_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(45),
      Q => data_2_o(13),
      R => tready_i_1_n_0
    );
\data_2_o_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(46),
      Q => data_2_o(14),
      R => tready_i_1_n_0
    );
\data_2_o_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(47),
      Q => data_2_o(15),
      R => tready_i_1_n_0
    );
\data_2_o_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(48),
      Q => data_2_o(16),
      R => tready_i_1_n_0
    );
\data_2_o_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(49),
      Q => data_2_o(17),
      R => tready_i_1_n_0
    );
\data_2_o_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(50),
      Q => data_2_o(18),
      R => tready_i_1_n_0
    );
\data_2_o_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(51),
      Q => data_2_o(19),
      R => tready_i_1_n_0
    );
\data_2_o_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(33),
      Q => data_2_o(1),
      R => tready_i_1_n_0
    );
\data_2_o_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(52),
      Q => data_2_o(20),
      R => tready_i_1_n_0
    );
\data_2_o_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(53),
      Q => data_2_o(21),
      R => tready_i_1_n_0
    );
\data_2_o_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(54),
      Q => data_2_o(22),
      R => tready_i_1_n_0
    );
\data_2_o_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(55),
      Q => data_2_o(23),
      R => tready_i_1_n_0
    );
\data_2_o_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(56),
      Q => data_2_o(24),
      R => tready_i_1_n_0
    );
\data_2_o_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(57),
      Q => data_2_o(25),
      R => tready_i_1_n_0
    );
\data_2_o_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(58),
      Q => data_2_o(26),
      R => tready_i_1_n_0
    );
\data_2_o_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(59),
      Q => data_2_o(27),
      R => tready_i_1_n_0
    );
\data_2_o_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(60),
      Q => data_2_o(28),
      R => tready_i_1_n_0
    );
\data_2_o_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(61),
      Q => data_2_o(29),
      R => tready_i_1_n_0
    );
\data_2_o_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(34),
      Q => data_2_o(2),
      R => tready_i_1_n_0
    );
\data_2_o_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(62),
      Q => data_2_o(30),
      R => tready_i_1_n_0
    );
\data_2_o_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(63),
      Q => data_2_o(31),
      R => tready_i_1_n_0
    );
\data_2_o_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(35),
      Q => data_2_o(3),
      R => tready_i_1_n_0
    );
\data_2_o_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(36),
      Q => data_2_o(4),
      R => tready_i_1_n_0
    );
\data_2_o_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(37),
      Q => data_2_o(5),
      R => tready_i_1_n_0
    );
\data_2_o_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(38),
      Q => data_2_o(6),
      R => tready_i_1_n_0
    );
\data_2_o_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(39),
      Q => data_2_o(7),
      R => tready_i_1_n_0
    );
\data_2_o_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(40),
      Q => data_2_o(8),
      R => tready_i_1_n_0
    );
\data_2_o_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \FSM_onehot_state_t_reg_n_0_[2]\,
      D => s_axis_tdata(41),
      Q => data_2_o(9),
      R => tready_i_1_n_0
    );
fsm_start_edge_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => ready_enb,
      I1 => fsm_start_prev,
      O => fsm_start_edge_i_1_n_0
    );
fsm_start_edge_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axis_aclk,
      CE => '1',
      CLR => tready_i_1_n_0,
      D => fsm_start_edge_i_1_n_0,
      Q => fsm_start_edge
    );
fsm_start_prev_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axis_aclk,
      CE => '1',
      CLR => tready_i_1_n_0,
      D => ready_enb,
      Q => fsm_start_prev
    );
tready_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axis_aresetn,
      O => tready_i_1_n_0
    );
tready_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => '1',
      D => tready,
      Q => s_axis_tready,
      R => tready_i_1_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_myaxistream_0_0_myaxistream_v1_0 is
  port (
    s_axis_tready : out STD_LOGIC;
    data_1_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    data_2_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    ready_enb : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_aresetn : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_myaxistream_0_0_myaxistream_v1_0 : entity is "myaxistream_v1_0";
end design_1_myaxistream_0_0_myaxistream_v1_0;

architecture STRUCTURE of design_1_myaxistream_0_0_myaxistream_v1_0 is
begin
myaxistream_v1_0_S_AXIS_inst: entity work.design_1_myaxistream_0_0_myaxistream_v1_0_S_AXIS
     port map (
      data_1_o(31 downto 0) => data_1_o(31 downto 0),
      data_2_o(31 downto 0) => data_2_o(31 downto 0),
      ready_enb => ready_enb,
      s_axis_aclk => s_axis_aclk,
      s_axis_aresetn => s_axis_aresetn,
      s_axis_tdata(63 downto 0) => s_axis_tdata(63 downto 0),
      s_axis_tready => s_axis_tready,
      s_axis_tvalid => s_axis_tvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_myaxistream_0_0 is
  port (
    ready_enb : in STD_LOGIC;
    instr_valid : out STD_LOGIC;
    data_1_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    data_2_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_aclk : in STD_LOGIC;
    s_axis_aresetn : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_tvalid : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_myaxistream_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_myaxistream_0_0 : entity is "design_1_myaxistream_0_0,myaxistream_v1_0,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_1_myaxistream_0_0 : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of design_1_myaxistream_0_0 : entity is "myaxistream_v1_0,Vivado 2024.2";
end design_1_myaxistream_0_0;

architecture STRUCTURE of design_1_myaxistream_0_0 is
  signal \^s_axis_tready\ : STD_LOGIC;
  attribute x_interface_info : string;
  attribute x_interface_info of s_axis_aclk : signal is "xilinx.com:signal:clock:1.0 S_AXIS_CLK CLK";
  attribute x_interface_mode : string;
  attribute x_interface_mode of s_axis_aclk : signal is "slave S_AXIS_CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of s_axis_aclk : signal is "XIL_INTERFACENAME S_AXIS_CLK, ASSOCIATED_BUSIF S_AXIS, ASSOCIATED_RESET s_axis_aresetn, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute x_interface_info of s_axis_aresetn : signal is "xilinx.com:signal:reset:1.0 S_AXIS_RST RST";
  attribute x_interface_mode of s_axis_aresetn : signal is "slave S_AXIS_RST";
  attribute x_interface_parameter of s_axis_aresetn : signal is "XIL_INTERFACENAME S_AXIS_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s_axis_tready : signal is "xilinx.com:interface:axis:1.0 S_AXIS TREADY";
  attribute x_interface_mode of s_axis_tready : signal is "slave S_AXIS";
  attribute x_interface_parameter of s_axis_tready : signal is "XIL_INTERFACENAME S_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute x_interface_info of s_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
  attribute x_interface_info of s_axis_tdata : signal is "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
begin
  instr_valid <= \^s_axis_tready\;
  s_axis_tready <= \^s_axis_tready\;
U0: entity work.design_1_myaxistream_0_0_myaxistream_v1_0
     port map (
      data_1_o(31 downto 0) => data_1_o(31 downto 0),
      data_2_o(31 downto 0) => data_2_o(31 downto 0),
      ready_enb => ready_enb,
      s_axis_aclk => s_axis_aclk,
      s_axis_aresetn => s_axis_aresetn,
      s_axis_tdata(63 downto 0) => s_axis_tdata(63 downto 0),
      s_axis_tready => \^s_axis_tready\,
      s_axis_tvalid => s_axis_tvalid
    );
end STRUCTURE;
