library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frame_buffer is
	 generic(
	 	VIDEO_X 	: integer := 256;
        VIDEO_Y 	: integer := 192;
	 	N_PIXEL     : integer := 8
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
	signal state : integer := 0;
	signal current_fb : std_logic := '0';
	signal normal : std_logic;
	signal clear_cnt : std_logic_vector(16 downto 0);
	signal addr_clear : std_logic_vector(16 downto 0);
	signal offset_w, offset_r : std_logic_vector(15 downto 0);
    signal address_w, address_r : std_logic_vector(16 downto 0);
	signal address_w_final, address_r_final : std_logic_vector(16 downto 0);
	signal write_addr : std_logic_vector(16 downto 0);
	signal write_data : std_logic_vector(23 downto 0);
	signal write_enb : std_logic;
begin

	address_r <= std_logic_vector(resize(shift_left(resize(unsigned(y_r), 16), 8) + resize(unsigned(x_r), 16), 17));
	address_w <= std_logic_vector(resize(shift_left(resize(unsigned(y_w), 16), 8) + resize(unsigned(x_w), 16), 17));

    offset_w <= std_logic_vector(to_unsigned(FB_SIZE,16)) when current_fb = '0' else (others => '0');
    offset_r <= std_logic_vector(to_unsigned(FB_SIZE,16)) when current_fb = '1' else (others => '0');
	address_w_final <= std_logic_vector(unsigned(address_w) + unsigned(offset_w));
	address_r_final <= std_logic_vector(unsigned(address_r) + unsigned(offset_r));

	addr_clear <= std_logic_vector(unsigned(clear_cnt) + unsigned(offset_w));

	write_addr <= address_w_final when normal = '1' else addr_clear;
	write_data <= data_w when normal = '1' else x"FFFFFF";
	write_enb  <= enable_w when normal = '1' else '1';

    rst_fsm : process(clock_w)
	begin
		if rising_edge(clock_w) then
			case state is 
				when 0 => --Normal Writing and waiting for swap
					swapped <= '0';
					normal <= '1';
					if fb_swap = '1' then
						state <= 1;
					else  
						state <= 0;
					end if;
				when 1 => --Ready to swap but waiting for v_sync
					swapped <= '0'; -- Normal can stay '1' because the cpu is stalling
					if v_sync = '0' then
						state <= 2;
						clear_cnt <= (others => '0');
						current_fb    <= not current_fb; --SWAP!
					else 
						state <= 1;
					end if;
				when 2 => --Reset the whole memory
					if unsigned(clear_cnt) = to_unsigned(FB_SIZE,17) then
						state <= 0;
						normal <= '1';
						swapped <= '1';
					else
						clear_cnt <= std_logic_vector(unsigned(clear_cnt) + 1);
						state <= 2;
						normal <= '0';
						swapped <= '0';
					end if;
			when others => 
					swapped <= '0';
					normal <= '0';
					state <= 0;
			end case;
		end if;
	end process;
	write: process(clock_w)
	begin
		if rising_edge(clock_w) then
				if write_enb = '1' then
					VRAM(to_integer(unsigned(write_addr))) <= write_data;
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

end Behavioral;
