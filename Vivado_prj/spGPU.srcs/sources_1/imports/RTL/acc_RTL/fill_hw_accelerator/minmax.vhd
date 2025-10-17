----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2025 11:54:07 AM
-- Design Name: 
-- Module Name: minmax - Behavioral
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

entity minmax is
Port (
    enable : in std_logic; 
    x1, x2, x3, y1, y2, y3 : in std_logic_vector(7 downto 0);
    minx, miny, maxx, maxy : out std_logic_vector(7 downto 0)
);
end minmax;

architecture Behavioral of minmax is

begin
    minx_process : process(enable) begin
        if enable = '1' then
            if x1 <= x2 then
                if x1 <= x3 then
                    minx <= x1;
                else 
                    minx <= x3;
                end if;
            else 
                 if x2 <= x3 then
                    minx <= x2;
                else 
                    minx <= x3;
                end if;
            end if;
       else 
            minx <= (others => '0');
       end if;
    end process;
    
     miny_process : process(enable) begin
        if enable = '1' then
            if y1 <= y2 then
                if y1 <= y3 then
                    miny <= y1;
                else 
                    miny <= y3;
                end if;
            else 
                 if y2 <= y3 then
                    miny <= y2;
                else 
                    miny <= y3;
                end if;
            end if;
       else 
            miny <= (others => '0');
       end if;
    end process;
    
     maxx_process : process(enable) begin
        if enable = '1' then
            if x1 >= x2 then
                if x1 >= x3 then
                    maxx <= x1;
                else 
                    maxx <= x3;
                end if;
            else 
                 if x2 >= x3 then
                    maxx <= x2;
                else 
                    maxx <= x3;
                end if;
            end if;
       else 
            maxx <= (others => '0');
       end if;
    end process;
    
    
    maxy_process : process(enable) begin
        if enable = '1' then
            if y1 >= y2 then
                if y1 >= y3 then
                    maxy <= y1;
                else 
                    maxy <= y3;
                end if;
            else 
                 if y2 >= y3 then
                    maxy <= y2;
                else 
                    maxy <= y3;
                end if;
            end if;
       else 
            maxy <= (others => '0');
       end if;
    end process;
end Behavioral;
