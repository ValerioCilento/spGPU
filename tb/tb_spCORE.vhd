library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_spcore is
end entity;

architecture tb of tb_spcore is

    --------------------------------------------------------------------
    -- Component Under Test (CUT)
    --------------------------------------------------------------------
    component spCORE is
        generic (
            INSTR_LENGTH : integer   := 64;
            N_opcode     : integer   := 4;
            N_color      : integer   := 24;
            N_pixel      : integer   := 8;
            N_Accelerators : integer := 6
        );
        port(
            clk, rst          : in  std_logic;
            instr_valid       : in  std_logic;
            instr_word        : in  std_logic_vector(INSTR_LENGTH-1 downto 0);
            core_halt         : in  std_logic;
            instr_req         : out std_logic;
            pixel_valid_o     : out std_logic;
            pixel_x_o         : out std_logic_vector(N_pixel-1 downto 0);
            pixel_y_o         : out std_logic_vector(N_pixel-1 downto 0);
            pixel_color_o     : out std_logic_vector(N_color-1 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Signals
    --------------------------------------------------------------------
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '1';
    signal instr_valid   : std_logic := '0';
    signal instr_word    : std_logic_vector(63 downto 0) := (others => '0');
    signal core_halt     : std_logic := '0';
    signal instr_req     : std_logic;
    signal pixel_valid_o : std_logic;
    signal pixel_x_o     : std_logic_vector(7 downto 0);
    signal pixel_y_o     : std_logic_vector(7 downto 0);
    signal pixel_color_o : std_logic_vector(23 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    --------------------------------------------------------------------
    -- Funzione: string (es: "0101...") → std_logic_vector
    --------------------------------------------------------------------
    function str_to_slv(s: in string) return std_logic_vector is
        variable result : std_logic_vector(s'length-1 downto 0);
    begin
        for i in s'range loop
            if s(i) = '1' then
                result(s'length-1 - (i - s'low)) := '1';
            else
                result(s'length-1 - (i - s'low)) := '0';
            end if;
        end loop;
        return result;
    end function;

begin

    --------------------------------------------------------------------
    -- Clock
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    --------------------------------------------------------------------
    -- Reset
    --------------------------------------------------------------------
    rst_process : process
    begin
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait;
    end process;

    --------------------------------------------------------------------
    -- Instantiate DUT
    --------------------------------------------------------------------
    dut: spCORE
        port map (
            clk           => clk,
            rst           => rst,
            instr_valid   => instr_valid,
            instr_word    => instr_word,
            core_halt     => core_halt,
            instr_req     => instr_req,
            pixel_valid_o => pixel_valid_o,
            pixel_x_o     => pixel_x_o,
            pixel_y_o     => pixel_y_o,
            pixel_color_o => pixel_color_o
        );

    --------------------------------------------------------------------
    -- Stimulus (lettura file + scrittura output)
    --------------------------------------------------------------------
    stimulus : process
        file instr_file : text open read_mode  is "instr_input.txt";
        file out_file   : text open write_mode is "output_pixels.txt";
        variable line_in  : line;
        variable line_out : line;
        variable instr_str : string(1 to 64);
    begin
        ----------------------------------------------------------------
        -- Attendi fine reset
        ----------------------------------------------------------------
        wait until rst = '0';

        ----------------------------------------------------------------
        -- Leggi e invia ogni istruzione
        ----------------------------------------------------------------
        while not endfile(instr_file) loop
            readline(instr_file, line_in);
            read(line_in, instr_str);

            instr_word <= str_to_slv(instr_str);
            instr_valid <= '1';
            wait for CLK_PERIOD;
            instr_valid <= '0';

            wait for (5 * CLK_PERIOD);
        end loop;

        ----------------------------------------------------------------
        -- Segnala fine core (opzionale)
        ----------------------------------------------------------------
        core_halt <= '1';

        ----------------------------------------------------------------
        -- Osserva uscite per un po' e salva nel file
        ----------------------------------------------------------------
        for i in 1 to 50 loop
            wait until rising_edge(clk);
                write(line_out, to_integer(unsigned(pixel_x_o)));
                write(line_out, ' ');
                write(line_out, to_integer(unsigned(pixel_y_o)));
                write(line_out, ' ');
                write(line_out, to_hstring(pixel_color_o));
                writeline(out_file, line_out);
        end loop;

        ----------------------------------------------------------------
        -- Fine simulazione
        ----------------------------------------------------------------
        wait;
    end process;

end architecture;
