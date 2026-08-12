library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.spPKG.all;

entity tb_spScheduler_CORE is
end entity tb_spScheduler_CORE;

architecture sim of tb_spScheduler_CORE is

    -- === Timing ===
    constant CLK_PERIOD : time := 10 ns;

    -- === Segnali Generici / Controllo ===
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal core_halt    : std_logic := '0';

    -- === Interfaccia AXI Stream (Input) ===
    signal instr_word_axi  : std_logic_vector(INSTR_LENGTH-1 downto 0) := (others => '0');
    signal instr_valid_axi : std_logic := '0';
    signal instr_req_sc    : std_logic;

    -- === Interconnessione Scheduler <-> Core ===
    signal fifo_out_core   : sch_instr;
    signal fifo_valid_core : std_logic_vector(N_cores-1 downto 0);
    signal instr_req_core  : std_logic_vector(N_cores-1 downto 0);

    -- === Segnali di Handshake & Output del Core ===
    signal fb_swap        : std_logic;
    signal swapped        : std_logic := '0';
    signal pixel_valid_o  : std_logic;
    signal pixel_x_o      : std_logic_vector(N_pixel-1 downto 0);
    signal pixel_y_o      : std_logic_vector(N_pixel-1 downto 0);
    signal pixel_color_o  : std_logic_vector(N_color-1 downto 0);

begin

    -- ==========================================================
    -- Generatore di Clock
    -- ==========================================================
    clk <= not clk after CLK_PERIOD/2;

    -- ==========================================================
    -- Generatore di Reset (Active HIGH)
    -- ==========================================================
    reset_p : process
    begin
        rst <= '1';
        wait for 5 * CLK_PERIOD;
        rst <= '0';
        wait;
    end process;

    -- ==========================================================
    -- INSTANZIAZIONE SCHEDULER
    -- ==========================================================
    SCHEDULER_INST : entity work.spScheduler
        port map(
            clk             => clk,
            rst             => rst,
            core_halt       => core_halt,
            instr_word_axi  => instr_word_axi,
            instr_req_core  => instr_req_core,
            instr_valid_axi => instr_valid_axi,
            fifo_out_core   => fifo_out_core,
            fifo_valid_core => fifo_valid_core,
            instr_req_sc    => instr_req_sc
        );

    -- ==========================================================
    -- INSTANZIAZIONE CORE (Core 0)
    -- ==========================================================
    CORE_INST : entity work.spCORE
        generic map(
            INSTR_LENGTH   => INSTR_LENGTH,
            N_opcode       => N_opcode,
            N_color        => N_color,
            N_pixel        => N_pixel,
            N_Accelerators => N_Accelerators
        )
        port map(
            clk           => clk,
            rst           => rst,
            instr_valid   => fifo_valid_core(0),
            instr_word    => fifo_out_core(0),     -- Collegamento diretto a 64-bit
            core_halt     => core_halt,
            swapped       => swapped,
            tile_index    => "0000",                -- Tile 0
            instr_req     => instr_req_core(0),     -- Richiesta inviata alla FIFO dello Scheduler
            fb_swap       => fb_swap,
            pixel_valid_o => pixel_valid_o,
            pixel_x_o     => pixel_x_o,
            pixel_y_o     => pixel_y_o,
            pixel_color_o => pixel_color_o
        );

    -- ==========================================================
    -- STIMOLO PRODUCER: Lettura Istruzioni da File (AXI Stream)
    -- ==========================================================
    stim_proc : process
        file fin          : text open read_mode is "instr.txt";
        variable L        : line;
        variable word_in  : std_logic_vector(INSTR_LENGTH-1 downto 0);
    begin
        instr_valid_axi <= '0';
        instr_word_axi  <= (others => '0');

        wait until rst = '0';
        wait until rising_edge(clk);

        while not endfile(fin) loop
            readline(fin, L);
            read(L, word_in);

            -- Attende che lo Scheduler sia pronto ad accettare istruzioni
            wait until instr_req_sc = '1' and rising_edge(clk);

            -- Trasmette la parola per 1 ciclo di clock
            instr_word_axi  <= word_in;
            instr_valid_axi <= '1';
            wait until rising_edge(clk);

            instr_valid_axi <= '0';
            instr_word_axi  <= (others => '0');
        end loop;

        report "=== FINITA LETTURA FILE ISTRUZIONI ===" severity note;
        wait;
    end process;

    -- ==========================================================
    -- EMULATORE FRAMEBUFFER SWAP HANDSHAKE
    -- ==========================================================
    swap_handshake_proc : process(clk, rst)
    begin
        if rst = '1' then
            swapped <= '0';
        elsif rising_edge(clk) then
            if fb_swap = '1' then
                swapped <= '1';
            else
                swapped <= '0';
            end if;
        end if;
    end process;

    -- ==========================================================
    -- CONSUMER LOGGER: Salva i Pixel generati su File
    -- ==========================================================
    log_proc : process
        file fout  : text open write_mode is "output_pixels.txt";
        variable L : line;
    begin
        wait until rst = '0';

        while true loop
            wait until rising_edge(clk);

            if pixel_valid_o = '1' then
                write(L, to_integer(unsigned(pixel_x_o)));
                write(L, string'(" "));
                write(L, to_integer(unsigned(pixel_y_o)));
                write(L, string'(" "));
                write(L, to_integer(unsigned(pixel_color_o)));
                writeline(fout, L);
            end if;
        end loop;
    end process;

end architecture sim;