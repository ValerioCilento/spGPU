library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.spPKG.all;

entity spANALYZER is
generic(
	CLK_CNT  : integer := 27;        -- #bit per rappresentare i cicli al secondo
	SWAP_CNT : integer := 10;        -- #bit per contare gli FPS
	TC_VALUE : integer := 99999999   -- Terminal count per clock a 100MHz (10^8 - 1)
);
port (
	clk, rst : in std_logic;
	swapped  : in std_logic;
	int_pin  : out std_logic;
	fps      : out std_logic_vector(SWAP_CNT-1 downto 0)
);
end entity spANALYZER;

architecture RTL of spANALYZER is
	signal sync_vector     : std_logic_vector(CLK_CNT-1 downto 0);
	signal swap_vector     : std_logic_vector(SWAP_CNT-1 downto 0);
	signal fps_int_reg     : std_logic_vector(SWAP_CNT-1 downto 0);
	signal one_sec_elapsed : std_logic;
begin

	fps <= fps_int_reg;
	one_sec_elapsed <= '1' when unsigned(sync_vector) = to_unsigned(TC_VALUE, CLK_CNT) else '0';

	-- Contatore per il timing di 1 secondo
	time_cnt_proc : process(clk, rst)
	begin
		if rst = '1' then
			sync_vector <= (others => '0');
		elsif rising_edge(clk) then
			if one_sec_elapsed = '1' then
				sync_vector <= (others => '0');
			else
				sync_vector <= std_logic_vector(unsigned(sync_vector) + 1);
			end if;
		end if;
	end process time_cnt_proc;

	-- Contatore dei frame (swap)
	swap_cnt_proc: process(clk, rst)
	begin
		if rst = '1' then
			swap_vector <= (others => '0');
		elsif rising_edge(clk) then
			if one_sec_elapsed = '1' then
				if swapped = '1' then
					swap_vector <= std_logic_vector(to_unsigned(1, SWAP_CNT));
				else
					swap_vector <= (others => '0');
				end if;
			elsif swapped = '1' then
				swap_vector <= std_logic_vector(unsigned(swap_vector) + 1);
			end if;
		end if;
	end process swap_cnt_proc;

	-- Registro di uscita FPS e generazione impulso interrupt ogni secondo
	out_reg : process(clk, rst)
	begin
		if rst = '1' then
			fps_int_reg <= (others => '0');
			int_pin     <= '0';
		elsif rising_edge(clk) then
			if one_sec_elapsed = '1' then
				fps_int_reg <= swap_vector;
				int_pin     <= '1'; -- Impulso ogni secondo per triggerare la stampa FPS
			else
				int_pin     <= '0';
			end if;
		end if;			
	end process out_reg;

end architecture RTL;