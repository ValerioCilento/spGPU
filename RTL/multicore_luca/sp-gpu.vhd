library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.spPKG.all;

--This structural combines the single core with the framebuffer. In this case we added the single core to the 10 tiles.
entity spgpu is 
generic(
	INSTR_LENGTH : integer   := 64; --#Istruction bits
	N_opcode : integer       := 8; --#Opcode bits
	N_color : integer        := 15; --#RGB bits
	N_pixel : integer        := 9; --#Pixel coordinates bits
	N_Accelerators : integer := 6; --#Accelerators
	TILE_X      : integer := 320;
    TILE_Y      : integer := 24
	);
port(
	clk, rst : in std_logic;
	clock_r      : in std_logic;
	instr_valid 			: in std_logic;
	instr_word_low, instr_word_upper      		: in std_logic_vector(INSTR_LENGTH/2-1 downto 0);
	core_halt               : in std_logic;
	v_sync       : in std_logic;
	instr_req   			: out std_logic;
	x_r, y_r     : in std_logic_vector(N_PIXEL-1 downto 0); -- Coordinate GLOBALI
	data_r       : out std_logic_vector(14 downto 0)
);
end entity;

architecture structural of spgpu is 
    component tile is
        generic(
            TILE_X      : integer := 320;
            TILE_Y      : integer := 24;
            N_PIXEL     : integer := 9  -- 9 bit necessari per arrivare a 320
        );
        Port (
            clock_w      : in std_logic;
            clock_r      : in std_logic;
            rst          : in std_logic;
            
            -- Dati in ingresso dal Core/Rasterizer
            z_in         : in std_logic_vector(3 downto 0);
            pixel_valid  : in std_logic;
            x_w, y_w     : in std_logic_vector(N_PIXEL-1 downto 0); -- Coordinate GLOBALI
            data_w       : in std_logic_vector(14 downto 0);
            
            -- Segnali di Sincronizzazione e Multicore
            fb_swap      : in std_logic;
            v_sync       : in std_logic;
            swapped      : out std_logic;
            tile_index   : in std_logic_vector(3 downto 0); -- 4 bit (permette da 0 a 15 core)
            
            -- Dati in uscita al controller VGA/Display
            x_r, y_r     : in std_logic_vector(N_PIXEL-1 downto 0); -- Coordinate GLOBALI
            data_r       : out std_logic_vector(14 downto 0)
         );
    end component;

    component spCORE is 
    generic (
        INSTR_LENGTH : integer   := 64; --#Istruction bits
        N_opcode : integer       := 8; --#Opcode bits
        N_color : integer        := 15; --#RGB bits
        N_pixel : integer        := 9; --#Pixel coordinates bits
        N_Accelerators : integer := 6; --#Accelerators
        TILE_X      : integer := 320;
        TILE_Y      : integer := 24
    );
    Port(
        clk, rst : in std_logic;
        instr_valid             : in std_logic;
        instr_word_low, instr_word_upper            : in std_logic_vector(INSTR_LENGTH/2-1 downto 0);
        core_halt               : in std_logic;
        swapped                 : in std_logic;
        tile_index              : in std_logic_vector(3 downto 0);
        instr_req               : out std_logic;
        fb_swap                 : out std_logic;
        pixel_valid_o           : out std_logic;
        pixel_x_o               : out std_logic_vector(N_pixel-1 downto 0);
        pixel_y_o               : out std_logic_vector(N_pixel-1 downto 0);
        pixel_color_o           : out std_logic_vector(N_color-1 downto 0)
    );
    end component;

    -- ==========================================
    -- DEFINIZIONE TIPI PER ARRAY DI SEGNALI
    -- ==========================================
    type data_r_array is array (0 to 9) of std_logic_vector(14 downto 0);
    signal tile_data_r : data_r_array;

    type coord_array is array (0 to 9) of std_logic_vector(N_pixel-1 downto 0);
    signal pixel_x_sig : coord_array;
    signal pixel_y_sig : coord_array;

    type color_array is array (0 to 9) of std_logic_vector(N_color-1 downto 0);
    signal pixel_color_sig : color_array;

    signal swapped_sig     : std_logic_vector(9 downto 0);
    signal fb_swap_sig     : std_logic_vector(9 downto 0);
    signal pixel_valid_sig : std_logic_vector(9 downto 0);
    signal instr_req_sig   : std_logic_vector(9 downto 0);

begin

    -- ==========================================
    -- GENERATION DEI 10 CORE E DELLE 10 TILE
    -- ==========================================
    GEN_CORES_TILES: for i in 0 to 9 generate
        
        -- Istanza del singolo Core
        core_inst : spCORE
        generic map (
            INSTR_LENGTH   => INSTR_LENGTH,
            N_opcode       => N_opcode,
            N_color        => N_color,
            N_pixel        => N_pixel,
            N_Accelerators => N_Accelerators,
            TILE_X         => TILE_X,
            TILE_Y         => TILE_Y
        )
        port map (
            clk              => clk,
            rst              => rst,
            instr_valid      => instr_valid,
            instr_word_low   => instr_word_low,
            instr_word_upper => instr_word_upper,
            core_halt        => core_halt,
            swapped          => swapped_sig(i),
            instr_req        => instr_req_sig(i),
            tile_index  => std_logic_vector(to_unsigned(i, 4)),

            fb_swap          => fb_swap_sig(i),
            pixel_valid_o    => pixel_valid_sig(i),
            pixel_x_o        => pixel_x_sig(i),
            pixel_y_o        => pixel_y_sig(i),
            pixel_color_o    => pixel_color_sig(i)
        );

        -- Istanza della singola Tile accoppiata al Core
        tile_inst : tile
        generic map (
            TILE_X  => TILE_X,
            TILE_Y  => TILE_Y,
            N_PIXEL => N_pixel
        )
        port map (
            clock_w     => clk,           -- Scrittura dal Core sincronizzata sul clock di sistema
            clock_r     => clock_r,       -- Lettura asincrona/sincrona per lo schermo
            rst         => rst,
            z_in        => (others => '0'), -- Default: il spCORE attuale non gestisce la profondità Z
            pixel_valid => pixel_valid_sig(i),
            x_w         => pixel_x_sig(i),
            y_w         => pixel_y_sig(i),
            data_w      => pixel_color_sig(i),
            fb_swap     => fb_swap_sig(i),
            v_sync      => v_sync,
            swapped     => swapped_sig(i),
            tile_index  => std_logic_vector(to_unsigned(i, 4)),
            x_r         => x_r,
            y_r         => y_r,
            data_r      => tile_data_r(i)
        );
        
    end generate;

    -- ==========================================
    -- MULTIPLEXER DI USCITA PER IL DISPLAY (data_r)
    -- ==========================================
    -- Associa l'output della Tile corretta in base alla coordinata verticale globale `y_r`
    process(y_r, tile_data_r)
        variable y_int : integer;
    begin
        y_int := to_integer(unsigned(y_r));

        -- Dividendo lo schermo orizzontalmente in slice da 24 pixel
        if y_int < 24 then
            data_r <= tile_data_r(0);
        elsif y_int < 48 then
            data_r <= tile_data_r(1);
        elsif y_int < 72 then
            data_r <= tile_data_r(2);
        elsif y_int < 96 then
            data_r <= tile_data_r(3);
        elsif y_int < 120 then
            data_r <= tile_data_r(4);
        elsif y_int < 144 then
            data_r <= tile_data_r(5);
        elsif y_int < 168 then
            data_r <= tile_data_r(6);
        elsif y_int < 192 then
            data_r <= tile_data_r(7);
        elsif y_int < 216 then
            data_r <= tile_data_r(8);
        elsif y_int < 240 then
            data_r <= tile_data_r(9);
        else
            data_r <= (others => '0'); -- Se la coordinata va fuori dai limiti (es: porzione di blanking vga)
        end if;
    end process;

    -- ==========================================
    -- GESTIONE SEGNALE instr_req VERSO L'ESTERNO
    -- ==========================================
    -- In una configurazione SIMD, richiediamo una nuova istruzione solo 
    -- quando tutti i core sono pronti a riceverla (AND logico).
    process(instr_req_sig)
        variable req_tmp : std_logic;
    begin
        req_tmp := '1';
        for i in 0 to 9 loop
            req_tmp := req_tmp and instr_req_sig(i);
        end loop;
        instr_req <= req_tmp;
    end process;

end structural;