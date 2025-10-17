--MAX 8 ns clock period (2 states)
--0.46%
--MAX 2.5 ns clock period
--0.46%
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity edge_fill_v2 is
Port ( 
    x1, y1, x2, y2, px, py : in std_logic_vector(7 downto 0); 
    clk, rst, start : in std_logic;
    done : out std_logic;
    area : out std_logic_vector(17 downto 0)
);
end edge_fill_v2;

architecture Behavioral of edge_fill_v2 is
    type state_t is (IDLE, CALC1, CALC2, FINISH);
    signal state, next_state : state_t;
    signal x1_s, y1_s, x2_s, y2_s, px_s, py_s : std_logic_vector(8 downto 0);
    signal reg : signed(17 downto 0);
 
begin
    x1_s <= "0"&x1;
    y1_s <= "0"&y1;
    x2_s <= "0"&x2;
    y2_s <= "0"&y2;
    px_s <= "0"&px;
    py_s <= "0"&py;
    
    process(rst, state, start) begin 
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
    variable tmp1, tmp2,tmp3, tmp4 : signed(8 downto 0);
    begin
        if rst = '1' then
            reg <= (others => '0');
            tmp1 := (others => '0');
            tmp2 := (others => '0');
            tmp3 := (others => '0');
            tmp4 := (others => '0');
            area <= (others => '0');
        elsif rising_edge(clk) then
            case state is 
                when IDLE =>
                    reg <= (others => '0');
                when CALC1 =>
                    tmp1 := signed(px_s) - signed(x1_s);
                    tmp2 := signed(y2_s) - signed(y1_s);
                    tmp3 := signed(py_s) - signed(y1_s);
                    tmp4 := signed(x2_s) - signed(x1_s);
                    area <= std_logic_vector(tmp1*tmp2 - tmp3*tmp4);
                when FINISH =>
                    null;
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;
