library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity f_circle_acc is
Port ( 
    clk, rst, start : in std_logic;
    xc, yc, r: in std_logic_vector(7 downto 0);
    color : in std_logic_vector(23 downto 0);
    --z_in : in std_logic; 
    --z_out : out std_logic;
    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
    pixel_color : out std_logic_vector(23 downto 0);
    finish : out std_logic
);
end entity f_circle_acc;

architecture Behavioral of f_circle_acc is
    type state_type is (IDLE, DRAW1, DRAW2, DRAW3, DRAW4, SETCHECK, COMPUTE);
    signal state : state_type := IDLE;
    signal d: integer := 0;
    signal x, y, i, j : std_logic_vector(7 downto 0);

begin

    --z_out <= z_in;
    pixel_color <= color;
    
    f_circle_draw: process(clk, rst)
    begin

    if rst = '1' then
        state <= IDLE;
        finish <= '0';
        x <= (others => '0');
        y <= (others => '0');
        d <= 0;
    elsif rising_edge(clk) then
        case state is
            when IDLE =>
                if start = '1' then
                    x <= (others => '0');
                    y <= r;
                    d <= 3 - (2 * to_integer(unsigned(r)));
                    finish <= '0';
                    state <= SETCHECK;
                else
                    state <= IDLE;
                end if;

            when SETCHECK => 
                i <= std_logic_vector(unsigned(xc) - unsigned(x));
                j <= std_logic_vector(unsigned(xc) - unsigned(y));
                if unsigned(y) < unsigned(x) then
                    finish <= '1';
                    state <= IDLE;
                else
                    state <= DRAW1;
                end if;

            when DRAW1 =>
                pixel_x <= i;
                pixel_y <= std_logic_vector(unsigned(yc) + unsigned(y));
                state <= DRAW2;

            when DRAW2 =>
                pixel_x <= i;
                pixel_y <= std_logic_vector(unsigned(yc) - unsigned(y));
                if unsigned(i) > (unsigned(xc) + unsigned(x)) then
                    state <= DRAW3;
                else
                    i <= std_logic_vector(unsigned(i) + 1);
                    state <= DRAW1;
                end if;
            
            when DRAW3 => 
                pixel_x <= j;
                pixel_y <= std_logic_vector(unsigned(yc) + unsigned(x));
                state <= DRAW4;

            when DRAW4 =>
                pixel_x <= j;
                pixel_y <= std_logic_vector(unsigned(yc) - unsigned(x));
                if unsigned(j) > (unsigned(xc) + unsigned(y)) then
                    y <= std_logic_vector(unsigned(y) - 1);
                    state <= COMPUTE;
                else
                    j <= std_logic_vector(unsigned(j) + 1);
                    state <= DRAW3;
                end if;

            when COMPUTE =>
                if d > 0 then
                    d <= d + (4 * to_integer(signed(x) - signed(y))) + 10;
                    x <= std_logic_vector(unsigned(x) + 1);
                else
                    d <= d + (4*to_integer(signed(x))) + 6;
                    x <= std_logic_vector(unsigned(x) + 1);
                    y <= std_logic_vector(unsigned(y) + 1);
                end if;
                state <= SETCHECK;

            when others =>
                state <= IDLE;
            
            end case;
         end if;
                
    end process f_circle_draw;
 
end architecture Behavioral;