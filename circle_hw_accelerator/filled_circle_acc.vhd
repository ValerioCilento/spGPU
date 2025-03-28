library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity f_circle_acc is
Port ( 
    clk, rst, start : in std_logic;
    xc, yc, r: in std_logic_vector(7 downto 0);
    color : in std_logic_vector(23 downto 0);
    z_in : in std_logic; 
    z_out : out std_logic;
    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
    pixel_color : out std_logic_vector(23 downto 0);
    finish : out std_logic
);
end entity f_circle_acc;

architecture Behavioral of f_circle_acc is
    signal draw_stage : std_logic;
    type state_type is (IDLE, DRAW1, DRAW2, DRAW3, DRAW4, INCR, SET, COMPUTE1, COMPUTE2);
    signal state : state_type := IDLE;
    signal d: integer := 0;
    signal x, y, i : std_logic_vector(8 downto 0);
    signal xc_s, yc_s, r_s : std_logic_vector(8 downto 0);
    signal pixel_x_s, pixel_y_s : std_logic_vector(8 downto 0);
    --variable test : std_logic_vector(7 downto 0);
begin
    xc_s <= "0"&xc;
    yc_s <= "0"&yc;
    r_s <= "0"&r;
    pixel_x <= pixel_x_s(7 downto 0);
    pixel_y <= pixel_y_s(7 downto 0);
    z_out <= z_in;
    pixel_color <= color;
    
    f_circle_draw: process(clk, rst)
    begin

    if rst = '1' then
        state <= IDLE;
    elsif rising_edge(clk) then
        case state is
            when IDLE =>
                if start = '1' then
                    x <= (others => '0');
                    y <= r_s;
                    d <= to_integer(3-(2*signed(r_s)));
                    i <= (others => '0');
                    draw_stage <= '0';
                    finish <= '0';
                    state <= SET;
                else 
                    state <= IDLE;
                    finish <= '1';
                end if;

            when SET => 
                if draw_stage = '0' then
                    i <= std_logic_vector(signed(xc_s) - signed(x));
                    state <= DRAW1;
                else 
                    i <= std_logic_vector(signed(xc_s) - signed(y));
                    state <= DRAW3;
                end if; 

            when INCR =>
                i <= std_logic_vector(unsigned(i) + 1);

                if draw_stage = '0' then
                    state <= DRAW1;
                else
                    state <= DRAW3;
                end if;

            when DRAW1 =>
                pixel_x_s <= i;
                pixel_y_s <= std_logic_vector(signed(yc_s) + signed(y));
                state <= DRAW2;

            when DRAW2 =>
                pixel_x_s <= i;
                pixel_y_s <= std_logic_vector(signed(yc_s) - signed(y));

                if i < std_logic_vector(signed(xc_s) + signed(x)) then
                    state <= INCR;
                else 
                    draw_stage <= '1';
                    state <= SET;
                end if;

            when DRAW3 => 
                pixel_x_s <= i;
                pixel_y_s <= std_logic_vector(signed(yc_s) + signed(x));
                state <= DRAW4;

            when DRAW4 =>
                pixel_x_s <= i;
                pixel_y_s <= std_logic_vector(signed(yc_s) - signed(x));

                if i < std_logic_vector(signed(xc_s) + signed(y)) then
                    state <= INCR;
                else 
                    if d > 0 then
                        y <= std_logic_vector(signed(y) - 1);
                        state <= COMPUTE1;
                    else
                        state <= COMPUTE2;
                    end if;
                    draw_stage <= '0';
                end if;

            when COMPUTE1 =>
                if y < std_logic_vector(signed(x) + 1) then
                    state <= IDLE;
                    finish <= '1';
                else 
                    d <= d + (4 * to_integer(signed(x) - signed(y))) + 10;
                    x <= std_logic_vector(signed(x) + 1);  
                    state <= SET;             
                end if;

            when COMPUTE2 =>
                if y < std_logic_vector(signed(x) + 1) then
                    state <= IDLE;
                    finish <= '1';
                else 
                    d <= d + (4*to_integer(signed(x))) + 6;
                    x <= std_logic_vector(signed(x) + 1);
                    state <= SET;             
                end if;
                
            when others =>
                state <= IDLE;
            
            end case;
         end if;
                
    end process f_circle_draw;
 
end architecture Behavioral;