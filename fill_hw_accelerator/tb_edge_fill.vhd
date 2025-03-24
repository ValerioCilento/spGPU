----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2025 05:40:16 PM
-- Design Name: 
-- Module Name: tb_edge_fill - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_edge_fill is
--  Port ( );
end tb_edge_fill;

architecture Behavioral of tb_edge_fill is
    component edge_fill is
    Port ( 
        x1, y1, x2, y2, px, py : in std_logic_vector(7 downto 0); 
        clk, rst, start : in std_logic;
        done : out std_logic;
        area : out std_logic_vector(17 downto 0)
    );
    end component;
    
    signal x1, y1, x2, y2, px, py : std_logic_vector(7 downto 0);
    signal clk, rst, start, done : std_logic;
    signal area : std_logic_vector(17 downto 0);
begin
    U1 : edge_fill port map(
        clk => clk,
        rst => rst,
        start => start,
        done => done,
        x1 => x1,
        x2 => x2,
        y1 => y1,
        px => px,
        py => py,
        y2 => y2,
        area => area
    );
    process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;

rst <= '1', '0' after 20 ns;
start <= '1', '0' after 40 ns;
x1 <= std_logic_vector(to_unsigned(150, 8));
y1 <= std_logic_vector(to_unsigned(150, 8));
x2 <= std_logic_vector(to_unsigned(100, 8));
y2 <= std_logic_vector(to_unsigned(100, 8));
px <= std_logic_vector(to_unsigned(70, 8));
py <= std_logic_vector(to_unsigned(100, 8));

end Behavioral;
