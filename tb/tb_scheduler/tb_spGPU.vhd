library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_spGPU is
end entity;

architecture sim of tb_spGPU is
    -- === Parametri allineati alla entity spGPU ===
    constant INSTR_LENGTH : integer   := 64; --#Istruction bits
    constant N_opcode : integer       := 4; --#Opcode bits
    constant N_color : integer        := 24; --#RGB bits
    constant N_pixel : integer        := 10; --#Pixel coordinates bits
    constant N_Accelerators : integer := 6; --#Accelerators
    constant FIFO_DEPTH : integer := 12; --#Fifo available instruction locations

    -- === Timing ===
    constant CLK_PERIOD : time := 10 ns;

    -- === Segnali UUT ===
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '1';
    signal core_halt      : std_logic := '0';
    signal swapped        : std_logic := '0';

    signal instr_word_axi : std_logic_vector(INSTR_LENGTH-1 downto 0) := (others => '0');
    signal instr_valid_axi: std_logic := '0';
    signal instr_req_sc   : std_logic;

    signal fb_swap        : std_logic;
    signal finish_exec    : std_logic;  -- esposto da spGPU
    signal pixel_valid_o  : std_logic;
    signal pixel_x_o      : std_logic_vector(N_PIXEL-1 downto 0);
    signal pixel_y_o      : std_logic_vector(N_PIXEL-1 downto 0);
    signal pixel_color_o  : std_logic_vector(N_COLOR-1 downto 0);

begin
    -- =====================
    -- Clock
    -- =====================
    clk <= not clk after CLK_PERIOD/2;

    -- =====================
    -- Reset
    -- =====================
    reset_p : process
    begin
        rst <= '0';
        wait for 10*CLK_PERIOD;
        rst <= '1';
        wait;
    end process;

    -- =====================
    -- UUT
    -- =====================
    UUT : entity work.spGPU
        generic map(
            INSTR_LENGTH   => INSTR_LENGTH,
            FIFO_DEPTH     => FIFO_DEPTH,
            N_opcode       => N_OPCODE,
            N_color        => N_COLOR,
            N_pixel        => N_PIXEL,
            N_Accelerators => N_ACCELERATORS
        )
        port map(
            clk             => clk,
            rst             => rst,
            core_halt       => core_halt,
            instr_word_axi  => instr_word_axi,
            instr_valid_axi => instr_valid_axi,
            swapped         => swapped,
            fb_swap         => fb_swap,
            instr_req_sc    => instr_req_sc,
            finish_exec     => finish_exec,
            pixel_valid_o   => pixel_valid_o,
            pixel_x_o       => pixel_x_o,
            pixel_y_o       => pixel_y_o,
            pixel_color_o   => pixel_color_o
        );

    -- ==========================================================
    -- Stimolo: leggi istruzioni da file e inviale allo scheduler
    -- ==========================================================
    stim_proc : process
        file fin          : text open read_mode is "instructions.txt";
        variable L        : line;
        variable word_in  : std_logic_vector(INSTR_LENGTH-1 downto 0);
    begin
        -- attesa fine reset
        wait until rst = '1';
        wait until rising_edge(clk);

        -- loop di lettura file
        while not endfile(fin) loop
            -- Legge una riga come std_logic_vector in binario ('0'/'1')
            readline(fin, L);
            -- NB: la riga deve avere esattamente INSTR_LENGTH bit (senza spazi)
            read(L, word_in);

            wait until instr_req_sc = '1' and rising_edge(clk);

            -- Presenta l'istruzione: 1 istruzione per ciclo
            instr_word_axi  <= word_in;
            instr_valid_axi <= '1';
            wait until rising_edge(clk);
            instr_valid_axi <= '0';
        end loop;

        -- Fine file: abbassa valid e stall
        instr_valid_axi <= '0';
        -- Stallo del processo come richiesto (non termina la simulazione)
        wait;
    end process;

    -- ==========================================
    -- Logger pixel: scrivi RGB, x, y su file .txt
    -- ==========================================
    log_proc : process
        file fout         : text open write_mode is "output_pixels.txt";
        variable L        : line;
        variable r_u      : unsigned(7 downto 0);
        variable g_u      : unsigned(7 downto 0);
        variable b_u      : unsigned(7 downto 0);
        variable x_i, y_i : integer;
        -- helper per conversione coord
        function to_int(slv : std_logic_vector) return integer is
        begin
            return to_integer(unsigned(slv));
        end function;
    begin
        -- attesa fine reset
        wait until rst = '1';
        wait until rising_edge(clk);

        while true loop
            wait until rising_edge(clk);
            -- Gating sull'uscita valida: "ignoro" il pixel_valid nel file, non come abilitazione
            if pixel_valid_o = '1' then

                r_u := unsigned(pixel_color_o(N_COLOR-1 downto N_COLOR-8));
                g_u := unsigned(pixel_color_o(N_COLOR-9 downto N_COLOR-16));
                b_u := unsigned(pixel_color_o(7 downto 0));

                x_i := to_int(pixel_x_o);
                y_i := to_int(pixel_y_o);

                -- Formato riga: x y R G B (decimali)
                write(L, x_i);
                write(L, string'(" "));
                write(L, y_i);
                write(L, string'(" "));
                write(L, integer(to_integer(r_u)));
                write(L, string'(" "));
                write(L, integer(to_integer(g_u)));
                write(L, string'(" "));
                write(L, integer(to_integer(b_u)));
                writeline(fout, L);
            end if;
        end loop;
    end process;

end architecture;
