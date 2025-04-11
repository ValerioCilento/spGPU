library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frame_buf is
generic (
	FRAME_DIM : integer := 32400;
	RGB : integer := 24
);
port(
clk : in std_logic;
en : in std_logic;
we : in std_logic;
rst : in std_logic;
addr : in std_logic_vector(9 downto 0);
di : in std_logic_vector(15 downto 0);
do : out std_logic_vector(15 downto 0)
);
end frame_buf;

architecture behavioral of frame_buf is
type vram is array ((FRAME_DIM-1) downto 0) of std_logic_vector((RGB-1) downto 0);
signal fb : vram;
begin

do <= fb(to_integer(unsigned(addr)))  when rst = '0' else (others => '0');

write_fb: process(clk)
begin

	if rising_edge(clk) then
		if en = '1' then
			if we = '1' then 
				fb(to_integer(unsigned(addr))) <= di;
			end if;
		end if;
	end if;

end process write_fb;

end behavioral;
