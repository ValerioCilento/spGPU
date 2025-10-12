library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE std.textio.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity tb_line_acc is
--  Port ( );
end tb_line_acc;

architecture Behavioral of tb_line_acc is
    component line_acc is port(
    clk, rst, start : in std_logic;
    x1, x2, y1, y2 : in std_logic_vector(7 downto 0);
    color : in std_logic_vector(23 downto 0);
    z_in : in std_logic; 
    z_out : out std_logic;
    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
    pixel_color : out std_logic_vector(23 downto 0);
    finish, pixel_valid : out std_logic
    ); end component;
    
    signal clk : std_logic;
    signal rst : std_logic;
    signal start : std_logic;
    signal x1, x2, y1, y2, pixel_x, pixel_y : std_logic_vector(7 downto 0);
    signal color, pixel_color : std_logic_vector(23 downto 0);
    signal finish, pixel_valid : std_logic;
begin
    DUT : line_acc port map(
        clk => clk,
        rst => rst,
        start => start,
        x1 => x1,
        y1 => y1,
        x2 => x2,
        y2 => y2,
        pixel_x => pixel_x,
        pixel_y => pixel_y,
        color => color,
        pixel_color => pixel_color,
        finish => finish,
        pixel_valid => pixel_valid
    );
    
    process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;
    
   write_file: process(clk) is file my_output : TEXT open WRITE_MODE is "/home/luca/gpu_prj/SchedulerGPU/sw/tb_line_acc.txt";
       
      variable my_output_line : LINE;
    begin
     if rising_edge(clk) then
        write(my_output_line, to_integer(unsigned(pixel_x)));
        write(my_output_line, ' ');
        write(my_output_line, to_integer(unsigned(pixel_y)));
        write(my_output_line, ' ');
        write(my_output_line, to_integer(unsigned(pixel_color)));
        writeline(my_output, my_output_line);
       end if;
     
    end process write_file;

rst <= '1', '0' after 20 ns;
start <= '1', '0' after 30 ns;
x1 <= std_logic_vector(to_unsigned(100, 8));
y1 <= std_logic_vector(to_unsigned(100, 8));
x2 <= std_logic_vector(to_unsigned(70, 8));
y2 <= std_logic_vector(to_unsigned(240, 8));

color<= x"FF0000";
end Behavioral;