library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sc_fifo is
generic(
	INSTR_LENGTH : integer := 64; --#Istruction bits
	FIFO_DEPTH   : integer := 12 --#Fifo available instruction locations
);
port(
	clk, rst        : in std_logic;
	-- wr interface --
	fifo_wr_en      : in std_logic;
	fifo_wr_data    : in std_logic_vector(INSTR_LENGTH-1 downto 0);
	-- rd interface --
	fifo_rd_en      : in std_logic;
	fifo_rd_data    : out std_logic_vector(INSTR_LENGTH-1 downto 0);
	-- ctrl signals --
	fifo_valid      : out std_logic;
	fifo_empty      : out std_logic;
	fifo_full       : out std_logic
);
end entity sc_fifo;

architecture RTL of sc_fifo is

	type scfifo is array(0 to FIFO_DEPTH-1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	signal fifo      : scfifo;
	signal fifo_cnt  : integer range 0 to FIFO_DEPTH;
	signal wr_index  : integer range 0 to FIFO_DEPTH-1;
	signal rd_index  : integer range 0 to FIFO_DEPTH-1;
	signal full_int  : std_logic;
	signal empty_int : std_logic;
	signal valid_int : std_logic;

begin

	full_int  <= '1' when fifo_cnt = FIFO_DEPTH else '0';
	empty_int <= '1' when fifo_cnt = 0 else '0';
	valid_int <= '1' when fifo_rd_en = '1' and empty_int = '0' else '0';

	fifo_full  <= full_int;
	fifo_empty <= empty_int;
	fifo_valid <= valid_int;

	fifo_rd_data <= fifo(rd_index);

	process(clk, rst) is
	begin
		if rst = '0' then
			fifo     <= (others => (others => '0'));
			fifo_cnt <= 0;
			wr_index <= 0;
			rd_index <= 0;
		elsif rising_edge(clk) then
			if fifo_wr_en = '1' and full_int = '0' then
				if wr_index = FIFO_DEPTH-1 then
					wr_index <= 0;
				else 
					wr_index <= wr_index + 1;
				end if;
				fifo(wr_index) <= fifo_wr_data;
				fifo_cnt <= fifo_cnt + 1;
			end if;

			if fifo_rd_en = '1' and empty_int = '0' then
				if rd_index = FIFO_DEPTH-1 then
					rd_index <= 0;
				else
					rd_index <= rd_index + 1;
				end if;
				fifo_cnt <= fifo_cnt - 1;
			end if;
		end if;
	end process;

end architecture RTL;