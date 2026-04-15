library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- Per scrivere std_logic_vector in modo semplice

entity tb_spANALYZER is
end entity tb_spANALYZER;

architecture bench of tb_spANALYZER is

    -- PARAMETRI CONFIGURABILI
    constant CLK_FREQ_HZ : integer := 100_000_000; -- 100 MHz
    constant CLK_PERIOD  : time    := 1 sec / CLK_FREQ_HZ;
    constant N_SWAP      : integer := 1666667; -- Uno swap ogni N_SWAP colpi di clock, FPS = F_CLK/N_SWAP
    
    -- Segnali interni
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal swapped : std_logic := '0';
    signal fps     : std_logic_vector(9 downto 0); -- Assumendo SWAP_CNT = 10

    -- File di output
    file file_results : text;

begin

    -- Istanza dell'Unità Sotto Test (UUT)
    uut: entity work.spANALYZER
        generic map (
            CLK_CNT  => 27,
            SWAP_CNT => 10,
            TC_VALUE => "101111101011110000011111111" -- 10^8 - 1
        )
        port map (
            clk     => clk,
            rst     => rst,
            swapped => swapped,
            fps     => fps
        );

    -- Generazione del Clock
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process clk_process;

    -- Stimoli: Reset e Swapped
    stim_proc: process
    begin
        -- Reset asserito per i primi 5 cicli
        rst <= '1';
        wait for CLK_PERIOD * 5;
        rst <= '0';

        -- Generazione segnale swapped ogni N cicli
        loop
            swapped <= '1';
            wait for CLK_PERIOD;
            swapped <= '0';
            wait for CLK_PERIOD * (N_SWAP - 1);
        end loop;
    end process stim_proc;

    -- LOGGING SU FILE: Scrive gli FPS ogni volta che il valore cambia
    file_io_proc: process(fps)
        variable line_v : line;
    begin
        -- Apriamo il file in modalità append o write
        -- Nota: In una simulazione reale, meglio aprire il file nel processo di inizializzazione
        file_open(file_results, "fps_log.txt", append_mode);
        
        if rst = '0' then
            write(line_v, to_integer(unsigned(fps))); -- Converte vector in integer per leggibilità
            writeline(file_results, line_v);
        end if;
        
        file_close(file_results);
    end process file_io_proc;

end architecture bench;