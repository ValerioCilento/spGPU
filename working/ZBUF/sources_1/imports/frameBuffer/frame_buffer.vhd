library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frame_buffer is
    generic(
        VIDEO_X     : integer := 320;
        VIDEO_Y     : integer := 240;
        N_PIXEL     : integer := 9  -- 9 bit necessari per arrivare a 320
    );
    Port (
        clock_w, clock_r, rst : in std_logic;
        z_in         : in std_logic_vector(3 downto 0);
        fb_swap      : in std_logic;
        pixel_valid          : in std_logic;
        v_sync       : in std_logic;
        swapped      : out std_logic;
        x_w, y_w     : in std_logic_vector(N_PIXEL-1 downto 0);
        x_r, y_r     : in std_logic_vector(N_PIXEL-1 downto 0);
        data_w       : in std_logic_vector(14 downto 0);
        data_r       : out std_logic_vector(14 downto 0)
     );
end frame_buffer;

architecture Behavioral of frame_buffer is
    constant FB_SIZE : integer := VIDEO_X*VIDEO_Y; -- 320 * 240 = 76.800
    type mem_type is array (0 to 2*FB_SIZE-1) of std_logic_vector(14 downto 0);
    type z_type is array(0 to FB_SIZE-1) of std_logic_vector(3 downto 0);
    signal VRAM : mem_type;
    signal ZBUF : z_type;
    
    signal state : integer := 0;
    signal current_fb : std_logic := '0';
    signal normal : std_logic;
    
    signal clear_cnt : std_logic_vector(17 downto 0);
    signal addr_clear : std_logic_vector(17 downto 0);
    signal offset_w, offset_r : std_logic_vector(17 downto 0);
    signal address_w, address_r : std_logic_vector(17 downto 0);
    signal address_w_final, address_r_final : std_logic_vector(17 downto 0);
    signal write_addr : std_logic_vector(17 downto 0);
    signal write_data : std_logic_vector(14 downto 0);
    signal write_enb : std_logic;

    signal z_prev : std_logic_vector(3 downto 0);
    signal z_enb : std_logic; 

    --Registers
    signal pixel_valid_reg : std_logic;
    signal address_w_reg : std_logic_vector(17 downto 0);
    signal z_in_reg : std_logic_vector(3 downto 0);
    signal color_reg : std_logic_vector(14 downto 0);
    signal normal_reg : std_logic;
begin

    -- ==========================================
    -- MATEMATICA DEGLI INDIRIZZI
    -- Y * 320 + X = (Y * 256) + (Y * 64) + X
    -- ==========================================
    address_r <= std_logic_vector(
        shift_left(resize(unsigned(y_r), 18), 8) + 
        shift_left(resize(unsigned(y_r), 18), 6) + 
        resize(unsigned(x_r), 18)
    );
    
    address_w <= std_logic_vector(
        shift_left(resize(unsigned(y_w), 18), 8) + 
        shift_left(resize(unsigned(y_w), 18), 6) + 
        resize(unsigned(x_w), 18)
    );
    
    offset_w <= std_logic_vector(to_unsigned(FB_SIZE,18)) when current_fb = '0' else (others => '0');
    offset_r <= std_logic_vector(to_unsigned(FB_SIZE,18)) when current_fb = '1' else (others => '0');
    
    address_w_final <= std_logic_vector(unsigned(address_w_reg) + unsigned(offset_w));
    address_r_final <= std_logic_vector(unsigned(address_r) + unsigned(offset_r));

    addr_clear <= std_logic_vector(unsigned(clear_cnt) + unsigned(offset_w));

    write_addr <= address_w_final when normal_reg = '1' else addr_clear;
    write_enb <= (pixel_valid_reg and z_enb) when normal_reg = '1' else '1';
    write_data <= color_reg when normal_reg = '1' else "111111111111111";
    -- ==============================================

    rst_fsm : process(clock_w, rst)
    begin
        if rst = '1' then
            normal <= '0';
            swapped <= '0';
            state <= 0;
            current_fb <= '0';
            clear_cnt <= (others => '0');
        elsif rising_edge(clock_w) then
            case state is 
                when 0 => --Writing the back buffer
                    swapped <= '0';
                    normal <= '1';
                    if fb_swap = '1' then
                        state <= 1;
                    else 
                        state <= 0;
                    end if;
                when 1 => --Ready to swap but waiting for v_sync
                    swapped <= '0';
                    if v_sync = '0' then
                        state <= 2;
                        clear_cnt <= (others => '0');
                        normal <= '0';
                        current_fb <= not current_fb; --SWAP!
                    else 
                        state <= 1;
                    end if;
                when 2 => --Reset the buffer
                    if unsigned(clear_cnt) = to_unsigned(FB_SIZE-1, 18) then
                        state <= 0;
                        swapped <= '1';
                        normal <= '1';
                    else
                        clear_cnt <= std_logic_vector(unsigned(clear_cnt) + 1);
                        state <= 2;
                        normal <= '0';
                        swapped <= '0';
                    end if;
            when others => 
                    normal <= '0';
                    state <= 0;
                    swapped <= '0';
            end case;
        end if;
    end process;

    write_proc: process(clock_w)
    begin
        if rising_edge(clock_w) then     
            if write_enb = '1' then
                VRAM(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;    
    
    read_proc: process(clock_r)
    begin
        if rising_edge(clock_r) then 
            data_r <= VRAM(to_integer(unsigned(address_r_final)));
        end if;
    end process;
    
    --====================================================================
    --ZBUFFER HANDLER 
    --====================================================================
    process(clock_w) begin
        if rising_edge(clock_w) then
            if normal_reg = '0' then
                zbuf(to_integer(unsigned(clear_cnt))) <= (others => '1');
            elsif z_enb = '1' then 
                zbuf(to_integer(unsigned(address_w_reg))) <= z_in_reg;
            end if;

            z_prev <= zbuf(to_integer(unsigned(address_w)));

        end if;
    end process;
    
        
    z_comp : process(z_prev, z_in_reg,pixel_valid_reg)
    begin
        if pixel_valid_reg = '1' then
            if unsigned(z_prev) >= unsigned(z_in_reg) then 
                z_enb <= '1';
            else 
                z_enb <= '0';
            end if;
        else 
            z_enb <= '0';
        end if;
    end process;
        
    pipeline_reg : process(clock_w, rst) begin
        if rst = '1' then
            pixel_valid_reg <= '0';
            z_in_reg <= (others => '1');
            address_w_reg <= (others => '0');
            color_reg <= (others => '0');
            normal_reg <= '0';
        elsif rising_edge(clock_w) then
            pixel_valid_reg <= pixel_valid;
            z_in_reg <= z_in;
            address_w_reg <= address_w;
            color_reg <= data_w;
            normal_reg <= normal;
        end if;
    end process;    


end Behavioral;