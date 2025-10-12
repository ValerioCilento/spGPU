----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2025 05:07:53 PM
-- Design Name: 
-- Module Name: edge_fill - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_fill is
Port ( 
    x1, y1, x2, y2, px, py : in std_logic_vector(7 downto 0); 
    clk, rst, start : in std_logic;
    done : out std_logic;
    area : out std_logic_vector(17 downto 0)
);
end edge_fill;

architecture Behavioral of edge_fill is
    type state_t is (IDLE, CALC1, CALC2, CALC3, FINISH);
    signal state, next_state : state_t;
    signal x1_s, y1_s, x2_s, y2_s, px_s, py_s : std_logic_vector(8 downto 0);
    signal reg : signed(17 downto 0);
    signal tmp1, tmp2 : signed(8 downto 0);
 
begin
    x1_s <= "0"&x1;
    y1_s <= "0"&y1;
    x2_s <= "0"&x2;
    y2_s <= "0"&y2;
    px_s <= "0"&px;
    py_s <= "0"&py;
    
    process(all) begin 
        done <= '0';
        if rst = '1' then
            next_state <= IDLE;
        else 
            case state is 
                when IDLE => 
                    if start = '1' then
                        next_state <= CALC1;
                    else 
                        next_state <= IDLE;
                    end if;
                when CALC1 => 
                    next_state <= CALC2;
                when CALC2 =>
                    next_state <= CALC3;
                when CALC3 =>
                    next_state <= FINISH;
                when FINISH =>
                    done <= '1';
                    next_state <= IDLE;
                when others => 
                    next_state <= IDLE;
             end case;
        end if;
    end process;
    
    process(clk, rst) begin
        if rst = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;
    
    data_path : process(clk, rst) 
    begin
        if rst = '1' then
            reg <= (others => '0');
            tmp1 <= (others => '0');
            tmp2 <= (others => '0');
        elsif rising_edge(clk) then
            case state is 
                when IDLE =>
                    reg <= (others => '0');
                when CALC1 =>
                    tmp1 <= signed(px_s) - signed(x1_s);
                    tmp2 <= signed(y2_s) - signed(y1_s);
                when CALC2 =>
                    reg <= tmp1*tmp2;
                    tmp1 <= signed(py_s) - signed(y1_s);
                    tmp2 <= signed(x2_s) - signed(x1_s);
                when CALC3 =>
                    area <= std_logic_vector(reg - (tmp1*tmp2));
                when FINISH =>
                    null;
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;
