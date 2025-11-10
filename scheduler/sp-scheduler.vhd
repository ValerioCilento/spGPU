library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spScheduler is
generic(
	INSTR_LENGTH   : integer := 64; --#Istruction bits
	FIFO_DEPTH     : integer := 12 --#Fifo available instruction locations
);
port(
	clk, rst        : in std_logic;
	core_halt       : in std_logic;
	instr_word_axi  : in std_logic_vector(INSTR_LENGTH-1 downto 0);
	instr_req_core  : in std_logic;
	instr_valid_axi : in std_logic;
	fifo_out_core   : out std_logic_vector(INSTR_LENGTH-1 downto 0);
	fifo_valid_core : out std_logic;
	instr_req_sc    : out std_logic
);
end entity spScheduler;

architecture RTL of spScheduler is

	component sc_fifo is
		generic(
			INSTR_LENGTH : integer;
			FIFO_DEPTH : integer
		);
		port(
			clk, rst     : in std_logic;
			fifo_wr_en   : in std_logic;
			fifo_wr_data : in std_logic_vector(INSTR_LENGTH-1 downto 0);
			fifo_rd_en   : in std_logic;
			fifo_rd_data : out std_logic_vector(INSTR_LENGTH-1 downto 0);
			fifo_valid   : out std_logic;
			fifo_empty   : out std_logic;
			fifo_full    : out std_logic	
		);
	end component;

	signal fifo_empty_wire      : std_logic;
	signal fifo_full_wire       : std_logic;
	--signal instr_valid_axi_wire : std_logic;
	--signal instr_word_axi_wire  : std_logic_vector(INSTR_LENGTH-1 downto 0);
	--signal instr_req_core_wire  : std_logic;
	--signal fifo_out_core_wire   : std_logic_vector(INSTR_LENGTH-1 downto 0);
	--signal fifo_valid_core_wire : std_logic;

begin
	
	FIFO : sc_fifo
	generic map(
		INSTR_LENGTH => INSTR_LENGTH,
		FIFO_DEPTH   => FIFO_DEPTH
	)
	port map(
		clk          => clk,
		rst          => rst,
		fifo_wr_en   => instr_valid_axi,
		fifo_wr_data => instr_word_axi,
		fifo_rd_en   => instr_req_core,
		fifo_rd_data => fifo_out_core,
		fifo_valid   => fifo_valid_core,
		fifo_empty   => fifo_empty_wire,
		fifo_full    => fifo_full_wire
	);

	instr_req_sc <= '1' when fifo_full_wire = '0' and core_halt = '0' else '0';

end architecture RTL;