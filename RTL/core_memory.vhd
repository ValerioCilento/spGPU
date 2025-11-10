library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.spPKG.all;

entity core_memory is 
generic (
		N_BITS : integer := 42;
		N_LOCATIONS : integer := 1000
);
port (
		clk, rst : in std_logic;
		write_en : in std_logic;
		read_en : in std_logic;
		color_i : in std_logic_vector(23 downto 0);
		x_i, y_i : in std_logic_vector(7 downto 0);
		z_i : in std_logic;
		full_flag :  out std_logic;
	    read_data : out std_logic_vector(N_BITS-1 downto 0);
		empty_flag : out std_logic
);
end entity;

architecture RTL of core_memory is 
	type fifo_t is array(0 to N_LOCATIONS-1) of std_logic_vector(N_BITS-1 downto 0);
	signal fifo : fifo_t;
 	signal fifo_word_count : integer range -1 to N_LOCATIONS+1 := 0;
	signal full_s, empty_s : std_logic;
	signal write_data : std_logic_vector(N_BITS-1 downto 0);
	signal address : std_logic_vector(16 downto 0);
	signal write_ptr, read_ptr : integer range 0 to N_LOCATIONS-1 := 0;
	
	signal tmp_z : std_logic;
begin
	tmp_z <= '0'; --Temporary ground for Z 
	address <= std_logic_vector(resize(shift_left(resize(unsigned(y_i), 16), 8) + resize(unsigned(x_i), 16), 17));
	write_data <= tmp_z & color_i & address;
	process(clk, rst) 
	begin
		if rst = '1' then
			fifo_word_count <= 0;
			write_ptr <= 0;
			read_ptr <= 0;
		elsif rising_edge(clk) then
			if(write_en = '1' and read_en = '0' and full_s = '0') then
				fifo_word_count <= fifo_word_count + 1;
			elsif (write_en = '0' and read_en = '1' and empty_s = '0') then
				fifo_word_count <= fifo_word_count - 1;
			end if;

			if(write_en = '1' and full_s = '0') then
				if write_ptr = N_LOCATIONS-1 then
					write_ptr <= 0;
				else 
					write_ptr <= write_ptr + 1;
				end if;
			end if;

			if(read_en = '1' and empty_s = '0') then
				if read_ptr = N_LOCATIONS-1 then
					read_ptr <= 0;
				else 
					read_ptr <= read_ptr + 1;
				end if;
			end if;

			if write_en = '1' then
				fifo(write_ptr) <= write_data;
			end if;
		end if;
	end process;

	read_data <= fifo(read_ptr);
	full_s <= '1' when fifo_word_count = N_LOCATIONS else '0';
	empty_s <= '1' when fifo_word_count = 0 else '0';

	full_flag <= full_s;
	empty_flag <= empty_s;
end RTL;	