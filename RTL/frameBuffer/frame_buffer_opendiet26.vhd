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
        fb_swap      : in std_logic;
        enb          : in std_logic;
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
    signal VRAM : mem_type;
    
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

    -- ====== NUOVI SEGNALI PER IL TESTO DI CONTORNO ======
    signal clear_x : unsigned(8 downto 0) := (others => '0');
    signal clear_y : unsigned(8 downto 0) := (others => '0');
    
    -- Inserisci qui i valori esatti restituiti dallo script Python
    constant TEXT_WIDTH  : integer := 212; 
    constant TEXT_HEIGHT : integer := 13;  
    
    type text_rom_type is array (0 to TEXT_HEIGHT-1) of std_logic_vector(0 to TEXT_WIDTH-1);
    
    -- ATTENZIONE: Sostituisci "others => (others => '0')" con 
    -- l'output dello script Python (le righe di "01001...")
    constant TEXT_BTM : text_rom_type := (
"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
"00100000000000100000000000000000000100000000000100000000000011100010000001000000000000000001000001110000100000000100100000000100100000000000011110000000000000000000001110000100000000100000111000111000111000111000",
"00100000000000100000000000000000000100000000000000000000000100010000000001000000000000000000000001001000000000000000100000000100000000000000100001000000000000000000001001000000000000100001000101000101000101000100",
"00100000011100111000011000110011101110011000110100011000000100000010011111100110001111110001000001000100100011100101110011100100100000000000100001001110000110001110001000100100011001110000000101000100000101111000",
"00100000000100100100100100100000100100100100100100100100000011100010100001001001001001001001000001000100100100100100100000100100100000000000100001001001001001001001001000100100100100100000001001000100001001000100",
"00100000011100100100100100100011100100100100100100100100000000010010011001001111001001001001000001000100100100100100100011100100100001100000100001001001001111001001001000100100111100100000010001000100010001000100",
"00100000100100100100100100100100100100100100100100100100000100010010000101001000001001001001000001001000100100100100100100100100100000000000100001001001001000001001001001000100100000100000100001000100100001000100",
"00111110111100111000011000100111100110011000100100011000000011100010111001100111001001001001000001110000100011100100110111100100100000000000011110001110000111001001001110000100011100110001111100111001111100111000",
"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000",
"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000",
"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    );

    signal is_text_area : std_logic;
    signal text_pixel   : std_logic;
    -- ====================================================

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
    
    address_w_final <= std_logic_vector(unsigned(address_w) + unsigned(offset_w));
    address_r_final <= std_logic_vector(unsigned(address_r) + unsigned(offset_r));

    addr_clear <= std_logic_vector(unsigned(clear_cnt) + unsigned(offset_w));

    write_addr <= address_w_final when normal = '1' else addr_clear;
    write_enb <= enb when normal = '1' else '1';

    -- ====== LOGICA COMBINATORIA PER IL TESTO ======
    -- Controlliamo se (clear_x, clear_y) si trova nel riquadro della scritta (margine 4 px)
    is_text_area <= '1' when (clear_x >= 4 and clear_x < 4 + TEXT_WIDTH) and
                             (clear_y >= 4 and clear_y < 4 + TEXT_HEIGHT) else '0';

    -- Estrazione sicura del pixel dalla ROM
    process(clear_x, clear_y, is_text_area)
    begin
        text_pixel <= '0';
        if is_text_area = '1' then
            text_pixel <= TEXT_BTM(to_integer(clear_y - 4))(to_integer(clear_x - 4));
        end if;
    end process;
    
    -- MUX per i dati in scrittura:
    -- 1. Se "normal", passa i dati dell'utente.
    -- 2. Se in "clear" e siamo su un pixel del testo, scrivi NERO (000000000000000).
    -- 3. Altrimenti in "clear", scrivi BIANCO (111111111111111).
    write_data <= data_w when normal = '1' else 
                  "000000000000000" when (normal = '0' and is_text_area = '1' and text_pixel = '1') else 
                  "111111111111111";
    -- ==============================================

    rst_fsm : process(clock_w, rst)
    begin
        if rst = '1' then
            normal <= '0';
            swapped <= '0';
            state <= 0;
            current_fb <= '0';
            clear_cnt <= (others => '0');
            clear_x <= (others => '0');
            clear_y <= (others => '0');
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
                        clear_x <= (others => '0'); -- Reset coordinate clear
                        clear_y <= (others => '0');
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
                        
                        -- ====== AGGIORNAMENTO COORDINATE X/Y ======
                        if clear_x = to_unsigned(VIDEO_X - 1, 9) then
                            clear_x <= (others => '0');
                            clear_y <= clear_y + 1;
                        else
                            clear_x <= clear_x + 1;
                        end if;
                        -- ==========================================

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
end Behavioral;