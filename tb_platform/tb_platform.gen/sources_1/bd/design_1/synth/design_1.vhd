--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
--Date        : Fri Nov 21 13:26:09 2025
--Host        : luca-pc running 64-bit Ubuntu 24.04.3 LTS
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    M_AXIS_ACLK_0 : in STD_LOGIC;
    M_AXIS_ARESETN_0 : in STD_LOGIC;
    instr_word_0 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    ready_enb_0 : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_blk_mem_gen_0_1 is
  port (
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 12 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  end component design_1_blk_mem_gen_0_1;
  component design_1_myaxistream_v1_0_0_0 is
  port (
    ready_enb : in STD_LOGIC;
    instr_valid : out STD_LOGIC;
    instr_word : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_aclk : in STD_LOGIC;
    s_axis_aresetn : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_tvalid : in STD_LOGIC
  );
  end component design_1_myaxistream_v1_0_0_0;
  component design_1_stream_tx_0_0 is
  port (
    enb_rd : out STD_LOGIC;
    data : in STD_LOGIC_VECTOR ( 63 downto 0 );
    valid_rx : in STD_LOGIC;
    M_AXIS_ACLK : in STD_LOGIC;
    M_AXIS_ARESETN : in STD_LOGIC;
    M_AXIS_TREADY : in STD_LOGIC;
    M_AXIS_TDATA : out STD_LOGIC_VECTOR ( 63 downto 0 );
    M_AXIS_TVALID : out STD_LOGIC;
    addr : out STD_LOGIC_VECTOR ( 12 downto 0 )
  );
  end component design_1_stream_tx_0_0;
  signal blk_mem_gen_0_douta : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal myaxistream_v1_0_0_instr_valid : STD_LOGIC;
  signal stream_tx_0_S_AXIS_TDATA : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal stream_tx_0_S_AXIS_TREADY : STD_LOGIC;
  signal stream_tx_0_S_AXIS_TVALID : STD_LOGIC;
  signal stream_tx_0_addr : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal stream_tx_0_enb_rd : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of M_AXIS_ACLK_0 : signal is "xilinx.com:signal:clock:1.0 CLK.M_AXIS_ACLK_0 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of M_AXIS_ACLK_0 : signal is "XIL_INTERFACENAME CLK.M_AXIS_ACLK_0, ASSOCIATED_RESET M_AXIS_ARESETN_0, CLK_DOMAIN design_1_M_AXIS_ACLK_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of M_AXIS_ARESETN_0 : signal is "xilinx.com:signal:reset:1.0 RST.M_AXIS_ARESETN_0 RST";
  attribute X_INTERFACE_PARAMETER of M_AXIS_ARESETN_0 : signal is "XIL_INTERFACENAME RST.M_AXIS_ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW";
begin
blk_mem_gen_0: component design_1_blk_mem_gen_0_1
     port map (
      addra(12 downto 0) => stream_tx_0_addr(12 downto 0),
      clka => M_AXIS_ACLK_0,
      douta(63 downto 0) => blk_mem_gen_0_douta(63 downto 0),
      ena => stream_tx_0_enb_rd
    );
myaxistream_v1_0_0: component design_1_myaxistream_v1_0_0_0
     port map (
      instr_valid => myaxistream_v1_0_0_instr_valid,
      instr_word(63 downto 0) => instr_word_0(63 downto 0),
      ready_enb => ready_enb_0,
      s_axis_aclk => M_AXIS_ACLK_0,
      s_axis_aresetn => M_AXIS_ARESETN_0,
      s_axis_tdata(63 downto 0) => stream_tx_0_S_AXIS_TDATA(63 downto 0),
      s_axis_tready => stream_tx_0_S_AXIS_TREADY,
      s_axis_tvalid => stream_tx_0_S_AXIS_TVALID
    );
stream_tx_0: component design_1_stream_tx_0_0
     port map (
      M_AXIS_ACLK => M_AXIS_ACLK_0,
      M_AXIS_ARESETN => M_AXIS_ARESETN_0,
      M_AXIS_TDATA(63 downto 0) => stream_tx_0_S_AXIS_TDATA(63 downto 0),
      M_AXIS_TREADY => stream_tx_0_S_AXIS_TREADY,
      M_AXIS_TVALID => stream_tx_0_S_AXIS_TVALID,
      addr(12 downto 0) => stream_tx_0_addr(12 downto 0),
      data(63 downto 0) => blk_mem_gen_0_douta(63 downto 0),
      enb_rd => stream_tx_0_enb_rd,
      valid_rx => myaxistream_v1_0_0_instr_valid
    );
end STRUCTURE;
