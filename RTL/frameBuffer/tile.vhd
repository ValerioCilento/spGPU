
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.spPKG.all;

entity tile is
    generic(
        TILE_X      : integer := 320;
        TILE_Y      : integer := 24;
        VIDEO_PIXEL : integer := 9; -- 9 bit necessari per arrivare a 320
        N_Z         : integer := 4  -- 4 bit per coordinate di profondita' Z
    );
    Port (
        clock_w, clock_r, rst : in std_logic;
        fb_swap      : in std_logic;
        enb          : in std_logic;
        v_sync       : in std_logic;
        swapped      : out std_logic;
        x_w, y_w     : in std_logic_vector(VIDEO_PIXEL-1 downto 0);
        x_r, y_r     : in std_logic_vector(VIDEO_PIXEL-1 downto 0);
        tile_index   : in std_logic_vector(3 downto 0);
        data_w       : in std_logic_vector(14 downto 0);
        z_w          : in std_logic_vector(N_Z-1 downto 0);
        data_r       : out std_logic_vector(14 downto 0)
     );
end tile;

architecture Behavioral of tile is
    constant FB_SIZE : integer := TILE_X*TILE_Y; -- 320 * 24 = 7680
    type mem_type is array (0 to 2*FB_SIZE-1) of std_logic_vector(14 downto 0);
    signal VRAM : mem_type;
    
    -- Z-Buffer per la tile corrente
    type z_mem_type is array (0 to FB_SIZE-1) of std_logic_vector(N_Z-1 downto 0);
    signal ZRAM : z_mem_type := (others => (others => '1'));
    
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

    signal z_current : std_logic_vector(N_Z-1 downto 0);
    signal z_pass    : std_logic;

    signal y_offset   : unsigned(N_PIXEL-1 downto 0);
    signal y_w_local  : unsigned(N_PIXEL-1 downto 0);
    signal y_r_local  : unsigned(N_PIXEL-1 downto 0);
    signal hit_w      : std_logic;
    signal hit_r      : std_logic;

    -- Sincronizzatore a doppio flip-flop per il segnale v_sync da dominio pixelclock a clock_w
    signal v_sync_meta : std_logic := '1';
    signal v_sync_sync : std_logic := '1';

begin

    -- Sincronizzazione clock domain crossing v_sync -> clock_w
    sync_proc : process(clock_w)
    begin
        if rising_edge(clock_w) then
            v_sync_meta <= v_sync;
            v_sync_sync <= v_sync_meta;
        end if;
    end process sync_proc;

    -- ==========================================
    -- MATEMATICA DEGLI INDIRIZZI
    -- Y * 320 + X = (Y * 256) + (Y * 64) + X
    -- ==========================================
    y_offset <= shift_left(resize(unsigned(tile_index), N_PIXEL), 4) + 
                shift_left(resize(unsigned(tile_index), N_PIXEL), 3);
                
    -- Hit Test: Il pixel globale si trova dentro questa specifica Tile?
    hit_w <= '1' when (unsigned(y_w) >= y_offset) and (unsigned(y_w) < (y_offset + TILE_Y)) else '0';
    hit_r <= '1' when (unsigned(y_r) >= y_offset) and (unsigned(y_r) < (y_offset + TILE_Y)) else '0';

    -- Traduzione della Y in coordinata locale interna alla Tile (0 - 23) in modo sicuro
    y_w_local <= (unsigned(y_w) - y_offset) when hit_w = '1' else (others => '0');
    y_r_local <= (unsigned(y_r) - y_offset) when hit_r = '1' else (others => '0');

    -- ==========================================
    -- MATEMATICA DEGLI INDIRIZZI LOCALI
    -- Y_local * 320 + X = (Y_local * 256) + (Y_local * 64) + X
    -- ==========================================
    address_r <= std_logic_vector(
        shift_left(resize(y_r_local, 18), 8) + 
        shift_left(resize(y_r_local, 18), 6) + 
        resize(unsigned(x_r), 18)
    );
    
    address_w <= std_logic_vector(
        shift_left(resize(y_w_local, 18), 8) + 
        shift_left(resize(y_w_local, 18), 6) + 
        resize(unsigned(x_w), 18)
    );
    
    offset_w <= std_logic_vector(to_unsigned(FB_SIZE,18)) when current_fb = '0' else (others => '0');
    offset_r <= std_logic_vector(to_unsigned(FB_SIZE,18)) when current_fb = '1' else (others => '0');
    
    address_w_final <= std_logic_vector(unsigned(address_w) + unsigned(offset_w));
    address_r_final <= std_logic_vector(unsigned(address_r) + unsigned(offset_r));

    addr_clear <= std_logic_vector(unsigned(clear_cnt) + unsigned(offset_w));

    -- ==========================================
    -- LOGICA DI CONFRONTO Z (DEPTH TEST)
    -- ==========================================
    z_current <= ZRAM(to_integer(unsigned(address_w)));
    z_pass    <= '1' when (unsigned(z_w) <= unsigned(z_current)) else '0';

    write_addr <= address_w_final when normal = '1' else addr_clear;
    write_data <= data_w when normal = '1' else "111111111111111";
    write_enb  <= (enb and hit_w and z_pass) when normal = '1' else '1';

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
                    clear_cnt <= (others => '0');
                    normal <= '0';
                    if v_sync_sync = '0' then
                        state <= 2;
                        current_fb <= not current_fb; --SWAP!
                    else 
                        state <= 1;
                    end if;
                when 2 => --Reset the buffer
                    if unsigned(clear_cnt) = to_unsigned(FB_SIZE-1, 18) then
                        state <= 3;
                        swapped <= '1';
                        normal <= '1';
                    else
                        clear_cnt <= std_logic_vector(unsigned(clear_cnt) + 1);
                        state <= 2;
                        normal <= '0';
                        swapped <= '0';
                    end if;
               when 3 => 
                    swapped <= '0';
                    normal <= '1';
                    if fb_swap = '0' then
                        state <= 0;
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

            if normal = '1' then
                if (enb = '1' and hit_w = '1' and z_pass = '1') then
                    ZRAM(to_integer(unsigned(address_w))) <= z_w;
                end if;
            else
                if state = 2 then
                    ZRAM(to_integer(unsigned(clear_cnt))) <= (others => '1');
                end if;
            end if;
        end if;
    end process;    
    
    read_proc: process(clock_r)
    begin
        if rising_edge(clock_r) then 
            data_r <= VRAM(to_integer(unsigned(address_r_final)));
        end if;
    end process;
end Behavioral;