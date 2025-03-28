library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all; 
use IEEE.NUMERIC_STD.ALL;

entity tb_circ_acc is
--  Port ( );
end tb_circ_acc;

architecture Behavioral of tb_circ_acc is
    component f_circle_acc is port(
    clk, rst, start : in std_logic;
    xc, yc, r : in std_logic_vector(7 downto 0);
    color : in std_logic_vector(23 downto 0);
    z_in : in std_logic; 
    z_out : out std_logic;
    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
    pixel_color : out std_logic_vector(23 downto 0);
    finish : out std_logic
    ); end component;
    
    signal clk : std_logic;
    signal rst : std_logic;
    signal start : std_logic;
    signal xc, yc, r, pixel_x, pixel_y : std_logic_vector(7 downto 0);
    signal color, pixel_color : std_logic_vector(23 downto 0);
    signal finish, z_in, z_out : std_logic;
begin
    DUT : f_circle_acc port map(
        clk => clk,
        rst => rst,
        start => start,
        xc => xc,
        yc => yc,
        r => r,
        pixel_x => pixel_x,
        pixel_y => pixel_y,
        color => color,
        pixel_color => pixel_color,
        finish => finish,
        z_in => z_in,
        z_out => z_out
    );
    
    process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;
    
   write_file: process(clk) is file my_output : TEXT open WRITE_MODE is "C:\Users\vale0\Desktop\University2\University2\DSP\Prj\spGPU\circle_hw_accelerator\tb_filled.txt";
       
      variable my_output_circ : line;
    begin
     if rising_edge(clk) then
        write(my_output_circ, to_integer(unsigned(pixel_x)));
        write(my_output_circ, ' ');
        write(my_output_circ, to_integer(unsigned(pixel_y)));
        write(my_output_circ, ' ');
        write(my_output_circ, to_integer(unsigned(pixel_color)));
        writeline(my_output, my_output_circ);
       end if;
     
    end process write_file;

rst <= '1', '0' after 20 ns;
start <= '1', '0' after 30 ns;
xc <= std_logic_vector(to_unsigned(120, 8));
yc <= std_logic_vector(to_unsigned(70, 8));
r <= std_logic_vector(to_unsigned(90, 8));

color<= x"FF0000";
end Behavioral;

