library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myaxistream_v1_0 is
	generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
        ready_enb : in std_logic;
        led : out std_logic;
        data_o : out std_logic_vector(2 downto 0);
		s_axis_aclk	: in std_logic;
		s_axis_aresetn	: in std_logic;
		s_axis_tready	: out std_logic;
		s_axis_tdata	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		s_axis_tvalid	: in std_logic
	);
end myaxistream_v1_0;

architecture arch_imp of myaxistream_v1_0 is

	-- component declaration
	component myaxistream_v1_0_S_AXIS is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
		ready_enb : in std_logic;
		led : out std_logic;
		data_o : out std_logic_vector(2 downto 0);
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TVALID	: in std_logic
		);
	end component myaxistream_v1_0_S_AXIS;

begin

-- Instantiation of Axi Bus Interface S_AXIS
myaxistream_v1_0_S_AXIS_inst : myaxistream_v1_0_S_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S_AXIS_TDATA_WIDTH
	)
	port map (
	    data_o => data_o,
		S_AXIS_ACLK	=> s_axis_aclk,
		led => led,
		S_AXIS_ARESETN	=> s_axis_aresetn,
		S_AXIS_TREADY	=> s_axis_tready,
		S_AXIS_TDATA	=> s_axis_tdata,
		ready_enb => ready_enb,
		S_AXIS_TVALID	=> s_axis_tvalid
	);

end arch_imp;
