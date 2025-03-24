----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2025 02:07:16 PM
-- Design Name: 
-- Module Name: tb_edge_fill_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE std.textio.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_edge_fill_top is
--  Port ( );
end tb_edge_fill_top;

architecture Behavioral of tb_edge_fill_top is
    
    component edge_fill_top_v2 is
    Port ( 
        x1, y1, x2, y2, x3, y3 : in std_logic_vector(7 downto 0);
        clk, rst, start : in std_logic;
        finish : out std_logic;
        color : in std_logic_vector(23 downto 0);
        pixel_color : out std_logic_vector(23 downto 0);
        pixel_x, pixel_y : out std_logic_vector(7 downto 0)
    );
    end component;
    
    signal x1, y1, x2, y2, x3, y3 :  std_logic_vector(7 downto 0);
    signal clk, rst, start :  std_logic;
    signal finish :  std_logic;
    signal color, pixel_color : std_logic_vector(23 downto 0);
    signal pixel_x, pixel_y : std_logic_vector(7 downto 0);
    
begin
    
    U1 : edge_fill_top_v2 port map(
        clk => clk,
        rst => rst,
        start => start,
        finish => finish,
        x1 => x1,
        x2 => x2,
        y1 => y1,
        x3 => x3,
        y3 => y3,
        y2 => y2,
        color => color,
        pixel_color => pixel_color,
        pixel_x => pixel_x,
        pixel_y => pixel_y
    );
    process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;



rst <= '1', '0' after 20 ns;
start <= '1', '0' after 40 ns;
x1 <= std_logic_vector(to_unsigned(100, 8));
y1 <= std_logic_vector(to_unsigned(100, 8));
x2 <= std_logic_vector(to_unsigned(70, 8));
y2 <= std_logic_vector(to_unsigned(240, 8));
x3 <= std_logic_vector(to_unsigned(150, 8));
y3 <= std_logic_vector(to_unsigned(150, 8));
color <= x"FF0000";
   write_file: process(clk) is file my_output : TEXT open WRITE_MODE is "/home/luca/gpu_prj/spGPU/sw/tb_fill.txt";
       
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
end Behavioral;
