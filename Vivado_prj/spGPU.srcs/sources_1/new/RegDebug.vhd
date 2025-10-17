----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2025 16:28:56
-- Design Name: 
-- Module Name: RegDebug - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegDebug is
Port ( 
    clk, rst : in std_logic;
    x, y : in std_logic_vector(7 downto 0);
    color : in std_logic_vector(23 downto 0);
    debug_x, debug_y : out std_logic_vector(7 downto 0);
    debug_color : out std_logic_vector(23 downto 0)
);
end RegDebug;

architecture Behavioral of RegDebug is

begin

    process(clk, rst)
    begin
    if rst = '0' then
        debug_x <= (others => '0');
        debug_y <= (others => '0');
        debug_color <= (others => '0');
     elsif rising_edge(clk) then
        if x /= "00000000" then
            debug_x <= x;
        end if;
        if y /= "00000000" then
            debug_y <= y;
        end if;
        if color /= "000000000000000000000000" then
            debug_color <= color;
        end if;
    end if;
    end process;
end Behavioral;
