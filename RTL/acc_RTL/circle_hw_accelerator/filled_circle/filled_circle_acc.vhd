library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity F_CIRCLE_ACC is
generic(
    N_pixel : integer
);
Port ( 
    clk, rst, start : in std_logic;
    xc, yc, r: in std_logic_vector(N_pixel-1 downto 0);
    color : in std_logic_vector(14 downto 0);
    --z_in : in std_logic; 
    --z_out : out std_logic;
    pixel_x, pixel_y : out std_logic_vector(N_pixel-1 downto 0);
    pixel_color : out std_logic_vector(14 downto 0);
    pixel_valid : out std_logic;
    finish : out std_logic
);
end entity F_CIRCLE_ACC;

architecture Behavioral of F_CIRCLE_ACC is
    type state_type is (IDLE, DRAW1, DRAW2, DRAW3, DRAW4, SETCHECK, COMPUTE);
    signal state : state_type := IDLE;
    signal d: integer := 0;
    signal x, y, i, j : std_logic_vector(N_pixel-1 downto 0);

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
            pixel_valid <= '0';
            i <= (others => '0');
            j <= (others => '0');
            
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    pixel_valid <= '0';
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
                    pixel_valid <= '0';
                    -- Controllo di fine ciclo principale
                    if unsigned(y) < unsigned(x) then
                        finish <= '1';
                        state <= IDLE;
                    else
                        i <= std_logic_vector(unsigned(xc) - unsigned(x));
                        j <= std_logic_vector(unsigned(xc) - unsigned(y));
                        state <= DRAW1;
                    end if;

                when DRAW1 =>
                    pixel_x <= i;
                    pixel_y <= std_logic_vector(unsigned(yc) + unsigned(y));
                    pixel_valid <= '1';
                    state <= DRAW2;

                when DRAW2 =>
                    pixel_x <= i;
                    pixel_y <= std_logic_vector(unsigned(yc) - unsigned(y));
                    pixel_valid <= '1';
                    
                    -- Comparazione sicura tra tipi unsigned
                    if unsigned(i) = (unsigned(xc) + unsigned(x)) then
                        state <= DRAW3;
                    else
                        i <= std_logic_vector(unsigned(i) + 1);
                        state <= DRAW1;
                    end if;

                when DRAW3 => 
                    pixel_x <= j;
                    pixel_y <= std_logic_vector(unsigned(yc) + unsigned(x));
                    pixel_valid <= '1';
                    state <= DRAW4;

                when DRAW4 =>
                    pixel_x <= j;
                    pixel_y <= std_logic_vector(unsigned(yc) - unsigned(x));
                    pixel_valid <= '1';
                    
                    -- Comparazione sicura tra tipi unsigned
                    if unsigned(j) = (unsigned(xc) + unsigned(y)) then
                        state <= COMPUTE;
                    else
                        j <= std_logic_vector(unsigned(j) + 1);
                        state <= DRAW3;
                    end if;

                when COMPUTE =>
                    pixel_valid <= '0';
                    if d > 0 then
                        -- Aggiornamento matematicamente compensato (10 -> 14)
                        d <= d + (4 * (to_integer(unsigned(x)) - to_integer(unsigned(y)))) + 14;
                        x <= std_logic_vector(unsigned(x) + 1);
                        y <= std_logic_vector(unsigned(y) - 1);
                    else
                        d <= d + (4 * to_integer(unsigned(x))) + 6;
                        x <= std_logic_vector(unsigned(x) + 1);
                    end if;
                    state <= SETCHECK;

                when others =>
                    pixel_valid <= '0';
                    state <= IDLE;
            end case;
        end if;
    end process f_circle_draw;
 
end architecture Behavioral;