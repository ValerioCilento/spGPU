library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;
use work.spPKG.all;

-- Structural top-level combining 10 Cores, 10 Framebuffer Tiles, and the Instruction Scheduler (Non-SIMD)
entity spgpu is 
generic(
    INSTR_LENGTH   : integer := 64; -- #Instruction bits
    N_opcode       : integer := 8;  -- #Opcode bits
    N_color        : integer := 15; -- #RGB bits
    N_pixel        : integer := 9;  -- #Pixel coordinates bits
    N_Accelerators : integer := 6;  -- #Accelerators
    TILE_X         : integer := 320;
    TILE_Y         : integer := 24
);
port(
    clk, rst             : in std_logic;
    clock_r              : in std_logic;
    instr_valid          : in std_logic;
    instr_word           : in std_logic_vector(INSTR_LENGTH-1 downto 0);
    core_halt            : in std_logic;
    v_sync               : in std_logic;
    instr_req            : out std_logic;
    int_pin              : out std_logic;
    x_r, y_r             : in std_logic_vector(N_PIXEL-1 downto 0); -- Coordinate GLOBALI
    fps                  : out std_logic_vector(9 downto 0);
    data_r               : out std_logic_vector(14 downto 0)
);
end entity;

architecture structural of spgpu is 

    -- =========================================================================
    -- COMPONENT DECLARATIONS
    -- =========================================================================
    
    -- Scheduler Component for dynamic instruction dispatching (Non-SIMD)
    component spScheduler is
    generic(
        INSTR_LENGTH   : integer := 64;
        FIFO_DEPTH     : integer := 12;
        N_cores        : integer := 10;
        N_pixel        : integer := 9;
        N_opcode       : integer := 8;
        VIDEO_X        : integer := 320;
        VIDEO_Y        : integer := 240
    );
    port(
        clk, rst        : in std_logic;
        core_halt       : in std_logic;
        instr_word_axi  : in std_logic_vector(INSTR_LENGTH-1 downto 0);
        instr_req_core  : in std_logic_vector(N_cores-1 downto 0);
        instr_valid_axi : in std_logic;
        fifo_out_core   : out sch_instr;
        fifo_valid_core : out std_logic_vector(N_cores-1 downto 0);
        instr_req_sc    : out std_logic
    );
    end component spScheduler;

    component spANALYZER is
    generic(
        CLK_CNT  : integer := 27;
        SWAP_CNT : integer := 10;
        TC_VALUE : integer := 99999999
    );
    port (
        clk, rst : in std_logic;
        swapped  : in std_logic;
        int_pin  : out std_logic;
        fps      : out std_logic_vector(SWAP_CNT-1 downto 0)
    );
    end component spANALYZER;
    
    component tile is
    generic(
        TILE_X      : integer := 320;
        TILE_Y      : integer := 24;
        N_PIXEL     : integer := 9  
    );
    Port (
        clock_w      : in std_logic;
        clock_r      : in std_logic;
        rst          : in std_logic;
        z_in         : in std_logic_vector(3 downto 0);
        pixel_valid  : in std_logic;
        x_w, y_w     : in std_logic_vector(N_PIXEL-1 downto 0);
        data_w       : in std_logic_vector(14 downto 0);
        fb_swap      : in std_logic;
        v_sync       : in std_logic;
        swapped      : out std_logic;
        tile_index   : in std_logic_vector(3 downto 0); 
        x_r, y_r     : in std_logic_vector(N_PIXEL-1 downto 0); 
        data_r       : out std_logic_vector(14 downto 0)
    );
    end component;

    component spCORE is 
    generic (
        INSTR_LENGTH   : integer := 64; 
        N_opcode       : integer := 8;  
        N_color        : integer := 15; 
        N_pixel        : integer := 9;  
        N_Accelerators : integer := 6;  
        TILE_X         : integer := 320;
        TILE_Y         : integer := 24
    );
    Port(
        clk, rst         : in std_logic;
        instr_valid      : in std_logic;
        instr_word_low   : in std_logic_vector(INSTR_LENGTH/2-1 downto 0);
        instr_word_upper : in std_logic_vector(INSTR_LENGTH/2-1 downto 0);
        core_halt        : in std_logic;
        swapped          : in std_logic;
        tile_index       : in std_logic_vector(3 downto 0);
        instr_req        : out std_logic;
        fb_swap          : out std_logic;
        pixel_valid_o    : out std_logic;
        pixel_x_o        : out std_logic_vector(N_pixel-1 downto 0);
        pixel_y_o        : out std_logic_vector(N_pixel-1 downto 0);
        pixel_color_o    : out std_logic_vector(N_color-1 downto 0)
    );
    end component;

    -- =========================================================================
    -- INTERNAL SIGNALS
    -- =========================================================================
    
    -- Scheduler bus signals
    signal instr_word_axi_sig : std_logic_vector(INSTR_LENGTH-1 downto 0);
    signal fifo_out_core_sig  : sch_instr;
    signal fifo_valid_core_sig: std_logic_vector(N_cores-1 downto 0);

    -- Core and Tile interconnected signals
    type data_r_array is array (0 to N_cores-1) of std_logic_vector(14 downto 0);
    signal tile_data_r : data_r_array;

    type coord_array is array (0 to N_cores-1) of std_logic_vector(N_pixel-1 downto 0);
    signal pixel_x_sig : coord_array;
    signal pixel_y_sig : coord_array;

    type color_array is array (0 to N_cores-1) of std_logic_vector(N_color-1 downto 0);
    signal pixel_color_sig : color_array;

    signal swapped_sig     : std_logic_vector(N_cores-1 downto 0);
    signal fb_swap_sig     : std_logic_vector(N_cores-1 downto 0);
    signal pixel_valid_sig : std_logic_vector(N_cores-1 downto 0);
    signal instr_req_sig   : std_logic_vector(N_cores-1 downto 0);

    signal fb_swap_general : std_logic;
    signal swapped_general : std_logic;
    signal y_r_reg         : std_logic_vector(N_pixel-1 downto 0);

begin

    -- 64-bit instruction assembly for Scheduler
    instr_word_axi_sig <= instr_word;

    -- Synchronous register for display Y coordinate
    process(clock_r)
    begin
        if rising_edge(clock_r) then
            y_r_reg <= y_r;
        end if;
    end process;

    -- =========================================================================
    -- SCHEDULER INSTANTIATION
    -- =========================================================================
    SCHEDULER_INST : spScheduler
    generic map(
        INSTR_LENGTH => INSTR_LENGTH,
        FIFO_DEPTH   => 12,
        N_cores      => N_cores,
        N_pixel      => N_pixel,
        N_opcode     => N_opcode,
        VIDEO_X      => 320,
        VIDEO_Y      => 240
    )
    port map(
        clk             => clk,
        rst             => rst,
        core_halt       => core_halt,
        instr_word_axi  => instr_word_axi_sig,
        instr_req_core  => instr_req_sig,       -- Collects requests from all 10 cores
        instr_valid_axi => instr_valid,
        fifo_out_core   => fifo_out_core_sig,   -- Array/Record containing instructions per core
        fifo_valid_core => fifo_valid_core_sig, -- Valid per core
        instr_req_sc    => instr_req            -- Main request signal to top interface
    );

    -- =========================================================================
    -- ANALYZER INSTANTIATION
    -- =========================================================================
    ANALYZER : spANALYZER 
    generic map(
      CLK_CNT  => 27,
      SWAP_CNT => 10,
      TC_VALUE => 99999999
    )
    port map(
      clk     => clk,
      rst     => rst,
      swapped => swapped_general,
      int_pin => int_pin, 
      fps     => fps
    );

    -- =========================================================================
    -- CORE & TILE GENERATION
    -- =========================================================================
    GEN_CORES_TILES: for i in 0 to N_cores-1 generate
        
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
            clk               => clk,
            rst               => rst,
            -- Instruction fed dynamically per core from Scheduler
            instr_valid       => fifo_valid_core_sig(i),
            instr_word_low    => fifo_out_core_sig(i)(INSTR_LENGTH/2-1 downto 0),
            instr_word_upper  => fifo_out_core_sig(i)(INSTR_LENGTH-1 downto INSTR_LENGTH/2),
            core_halt         => core_halt,
            swapped           => swapped_sig(i),
            tile_index        => std_logic_vector(to_unsigned(i, 4)),
            instr_req         => instr_req_sig(i), -- Core request back to Scheduler
            fb_swap           => fb_swap_sig(i),
            pixel_valid_o     => pixel_valid_sig(i),
            pixel_x_o         => pixel_x_sig(i),
            pixel_y_o         => pixel_y_sig(i),
            pixel_color_o     => pixel_color_sig(i)
        );

        tile_inst : tile
        generic map (
            TILE_X  => TILE_X,
            TILE_Y  => TILE_Y,
            N_PIXEL => N_pixel
        )
        port map (
            clock_w     => clk,           
            clock_r     => clock_r,       
            rst         => rst,
            z_in        => (others => '0'), 
            pixel_valid => pixel_valid_sig(i),
            x_w         => pixel_x_sig(i),
            y_w         => pixel_y_sig(i),
            data_w      => pixel_color_sig(i),
            fb_swap     => fb_swap_general,
            v_sync      => v_sync,
            swapped     => swapped_sig(i),
            tile_index  => std_logic_vector(to_unsigned(i, 4)),
            x_r         => x_r,
            y_r         => y_r,
            data_r      => tile_data_r(i)
        );
        
    end generate;

    -- =========================================================================
    -- OUTPUT MUX FOR DISPLAY SCANNING
    -- =========================================================================
    process(y_r_reg, tile_data_r)
        variable y_int : integer;
    begin
        y_int := to_integer(unsigned(y_r_reg));

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
            data_r <= (others => '0'); 
        end if;
    end process;

    -- =========================================================================
    -- GLOBAL SWAP MONITORING
    -- =========================================================================
    swapped_general <= swapped_sig(0);

    process(fb_swap_sig)
        variable req_tmp : std_logic;
    begin
        req_tmp := '0';
        for i in 0 to N_cores-1 loop
            req_tmp := req_tmp and fb_swap_sig(i);
        end loop;
        fb_swap_general <= req_tmp;
    end process;
end structural;