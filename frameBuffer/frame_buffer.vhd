library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frame_buffer is
	 generic(
	 	VIDEO_X 	: integer := 256;
        VIDEO_Y 	: integer := 192;
	 	N_PIXEL     : integer := 10
	 );
    Port (
        clock_w, enable_w, clock_r, rst : in std_logic;
        fb_swap : in std_logic;
        image_enable : in std_logic;
        v_sync : in std_logic;
        swapped : out std_logic;
        x_r, y_r, x_w, y_w : in std_logic_vector(N_PIXEL-1 downto 0);
        data_w: in std_logic_vector(23 downto 0);
        data_r: out std_logic_vector(23 downto 0)
     );
end frame_buffer;

architecture Behavioral of frame_buffer is
    constant FB_SIZE : integer := VIDEO_X*VIDEO_Y;
	type mem_type is array (0 to 2*FB_SIZE-1) of std_logic_vector(23 downto 0);
	signal VRAM : mem_type;
	signal current_fb : std_logic := '0';
	signal offset_w, offset_r : std_logic_vector((N_PIXEL+9) downto 0);
    signal address_w, address_r : std_logic_vector((N_PIXEL+9) downto 0);
	signal address_w_final, address_r_final : std_logic_vector((N_PIXEL+9) downto 0);
begin
	address_r <= std_logic_vector(unsigned(y_r)*VIDEO_X + unsigned(x_r));
	address_w <= std_logic_vector(unsigned(y_w)*VIDEO_X + unsigned(x_w));
    offset_w <= std_logic_vector(to_unsigned(FB_SIZE,(N_PIXEL+10))) when current_fb = '0' else (others => '0');
    offset_r <= std_logic_vector(to_unsigned(FB_SIZE,(N_PIXEL+10))) when current_fb = '1' else (others => '0');
	address_w_final <= std_logic_vector(unsigned(address_w) + unsigned(offset_w));
	address_r_final <= std_logic_vector(unsigned(address_r) + unsigned(offset_r));

	write: process(clock_w)
	begin
		if rising_edge(clock_w) then
				if enable_w = '1' then
					VRAM(to_integer(unsigned(address_w_final))) <= data_w;
				end if;
		end if;
	end process;    
	
	read: process(clock_r)
	begin
		if rising_edge(clock_r) then 
				if image_enable = '1' then
					data_r <= VRAM(to_integer(unsigned(address_r_final)));
			    else 
			        data_r <= x"00FF00";
				end if;
        end if;
	end process;

	swap_fb : process(clock_w)
	begin
		if rising_edge(clock_w) then
			if fb_swap = '1' and v_sync = '0' then
				current_fb <= not current_fb;
				swapped <= '1';
			else 
				swapped <= '0';
			end if;
		end if;
	end process;

end Behavioral;
