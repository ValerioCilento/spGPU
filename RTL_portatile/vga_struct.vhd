library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_struct is
generic(
        VIDEO_X      : integer := 640;
        VIDEO_Y      : integer := 480;
        H_COORDINATE : integer := 640;
        V_COORDINATE : integer := 480;
        N_pixel      : integer := 10;
        VIDEO_pixel  : integer := 9;
        HF_PORCH     : integer := 16;
        HB_PORCH     : integer := 48;
        VF_PORCH     : integer := 10;
        VB_PORCH     : integer := 33;
        HSYNC        : integer := 96;
        VSYNC        : integer := 2
    );
Port ( 
    rst          : in std_logic;
    pixelclock   : in std_logic;  -- slow pixel clock 1x
    serialclock  : in std_logic;  -- fast serial clock 5x
    video_data   : in std_logic_vector(14 downto 0);
    h_coord      : out std_logic_vector(VIDEO_pixel-1 downto 0);
    v_coord      : out std_logic_vector(VIDEO_pixel-1 downto 0);
    v_sync       : out std_logic;
    clk_n, clk_p : out std_logic;
    data_n, data_p : out std_logic_vector(2 downto 0)
);
end vga_struct;

architecture structural of vga_struct is

    component rgb2tmds is
        generic (
            SERIES6 : boolean := false
        );
        port(
            rst          : in std_logic;
            pixelclock   : in std_logic;
            serialclock  : in std_logic;
            video_data   : in std_logic_vector(23 downto 0);
            video_active : in std_logic;
            hsync        : in std_logic;
            vsync        : in std_logic;
            clk_p        : out std_logic;
            clk_n        : out std_logic;
            data_p       : out std_logic_vector(2 downto 0);
            data_n       : out std_logic_vector(2 downto 0)
        );
    end component; 
    
    component counter_pixel is 
    generic(
        VIDEO_X      : integer;
        VIDEO_Y      : integer;
        H_COORDINATE : integer;
        V_COORDINATE : integer;
        N_pixel      : integer;
        VIDEO_pixel  : integer;
        HF_PORCH     : integer;
        HB_PORCH     : integer;
        VF_PORCH     : integer;
        VB_PORCH     : integer;
        HSYNC        : integer;
        VSYNC        : integer
    );
    port(
        clk, rst     : in std_logic;
        video_active : out std_logic; 
        h_coord      : out std_logic_vector(9 downto 0);
        v_coord      : out std_logic_vector(9 downto 0);
        h_sync, v_sync : out std_logic
    );
    end component;

    -- Segnali interni dai contatori
    signal video_active_s, h_sync_s, v_sync_s : std_logic;
    signal video_data_int : std_logic_vector(23 downto 0);
    signal h_coord_int, v_coord_int : std_logic_vector(9 downto 0);

    -- =========================================================================
    -- REGISTRI DI PIPELINE PER ALLINEARE LA LATENZA BRAM (1 CICLO DI CLOCK)
    -- =========================================================================
    signal video_active_pipe : std_logic := '0';
    signal h_sync_pipe       : std_logic := '1';
    signal v_sync_pipe       : std_logic := '1';

begin

    -- Espansione colore da RGB555 a RGB888
    video_data_int <= video_data(14 downto 10) & video_data(14 downto 12) & -- Rosso
                      video_data(9 downto 5)   & video_data(9 downto 7)   & -- Verde
                      video_data(4 downto 0)   & video_data(4 downto 2);    -- Blu

    -- Coordinate inviate alla GPU
    h_coord <= h_coord_int(9 downto 1);
    v_coord <= v_coord_int(9 downto 1);

    -- Generatore di temporizzazione VGA
    vga : counter_pixel 
    generic map(
        VIDEO_X      => VIDEO_X,
        VIDEO_Y      => VIDEO_Y,
        H_COORDINATE => H_COORDINATE,
        V_COORDINATE => V_COORDINATE,
        N_pixel      => N_pixel,
        VIDEO_pixel  => VIDEO_pixel,
        HF_PORCH     => HF_PORCH,
        HB_PORCH     => HB_PORCH,
        VF_PORCH     => VF_PORCH,
        VB_PORCH     => VB_PORCH,
        HSYNC        => HSYNC,
        VSYNC        => VSYNC
    )
    port map(
        clk          => pixelclock, 
        rst          => rst, 
        video_active => video_active_s,
        h_sync       => h_sync_s, 
        v_sync       => v_sync_s, 
        h_coord      => h_coord_int, 
        v_coord      => v_coord_int
    );

    -- =========================================================================
    -- PROCESSO DI ALLINEAMENTO (LATENZA = 1 CICLO DI CLOCK)
    -- =========================================================================
    align_proc : process(pixelclock, rst)
    begin
        if rst = '1' then
            video_active_pipe <= '0';
            h_sync_pipe       <= '1';
            v_sync_pipe       <= '1';
        elsif rising_edge(pixelclock) then
            video_active_pipe <= video_active_s;
            h_sync_pipe       <= h_sync_s;
            v_sync_pipe       <= v_sync_s;
        end if;
    end process;

    -- Encoder TMDS HDMI (Usa i segnali ritardati/allineati)
    hdmi : rgb2tmds 
    generic map(
        SERIES6 => false
    ) 
    port map(
        rst          => rst, 
        pixelclock   => pixelclock, 
        serialclock  => serialclock, 
        video_data   => video_data_int, 
        video_active => video_active_pipe,  -- Registrato
        hsync        => h_sync_pipe,        -- Registrato
        vsync        => v_sync_pipe,        -- Registrato
        clk_p        => clk_p, 
        clk_n        => clk_n,
        data_n       => data_n, 
        data_p       => data_p
    );

    -- Uscita V_SYNC sincronizzata
    v_sync <= v_sync_pipe;

end structural;