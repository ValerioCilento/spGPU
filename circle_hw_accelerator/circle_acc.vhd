library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity circle_acc is
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
end entity circle_acc;

architecture Behavioral of circle_acc is
    type state_type is (IDLE, DRAW1, DRAW2, DRAW3, DRAW4, DRAW5, DRAW6, DRAW7, DRAW8, COMPUTE1, COMPUTE2, DONE);
    signal state : state_type := IDLE;
    signal d: integer := 0;
    signal x, y : std_logic_vector(7 downto 0);
    
begin

    z_out <= z_in;
    pixel_color <= color;
    
    draw_circle : process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            case state is
            when IDLE => 
                d <= 3 - to_integer((2*unsigned(r)));
                x <= (others => '0');
                y <= r;
                finish <= '1';
                if start = '1' then
                    state <= DRAW1;
                else 
                    state <= IDLE;
                end if;
            
            when DRAW1 =>
                if x > y then
                    finish <= '1';
                    state <= IDLE;
                else 
                    pixel_x <= std_logic_vector((unsigned(xc)) + unsigned(x));
                    pixel_y <= std_logic_vector((unsigned(yc)) + unsigned(y));
                    finish <= '0';
                    state <= DRAW2;
                end if;
                
            when DRAW2 =>
                pixel_x <= std_logic_vector((unsigned(xc)) - unsigned(x));
                pixel_y <= std_logic_vector((unsigned(yc)) + unsigned(y));
                state <= DRAW3;
            
            when DRAW3 =>
                pixel_x <= std_logic_vector((unsigned(xc)) + unsigned(x));
                pixel_y <= std_logic_vector((unsigned(yc)) - unsigned(y));
                state <= DRAW4;
                
            when DRAW4 =>
                pixel_x <= std_logic_vector((unsigned(xc)) - unsigned(x));
                pixel_y <= std_logic_vector((unsigned(yc)) - unsigned(y));
                state <= DRAW5;
             
            when DRAW5 =>
                pixel_x <= std_logic_vector((unsigned(xc)) + unsigned(y));
                pixel_y <= std_logic_vector((unsigned(yc)) + unsigned(x));
                state <= DRAW6;
            
            when DRAW6 =>
                pixel_x <= std_logic_vector((unsigned(xc)) - unsigned(y));
                pixel_y <= std_logic_vector((unsigned(yc)) + unsigned(x));
                state <= DRAW7;
                
            when DRAW7 =>
                pixel_x <= std_logic_vector((unsigned(xc)) + unsigned(y));
                pixel_y <= std_logic_vector((unsigned(yc)) - unsigned(x));
                state <= DRAW8;
                
            when DRAW8 =>
                pixel_x <= std_logic_vector((unsigned(xc)) - unsigned(y));
                pixel_y <= std_logic_vector((unsigned(yc)) - unsigned(x));
                
                if d > 0 then
                    y <= std_logic_vector(unsigned(y) - 1);
                    state <= COMPUTE1;
                else 
                    state <= COMPUTE2;
                end if;
             
            when COMPUTE1 => 
                d <= d + (4 * to_integer(signed(x) - signed(y))) + 10;
                x <= std_logic_vector(unsigned(x) + 1);
                state <= DRAW1;
            
            when COMPUTE2 => 
                d <= d + (4*to_integer(unsigned(x))) + 6;
                x <= std_logic_vector(unsigned(x) + 1);
                state <= DRAW1;
            
            when others => 
                state <= IDLE;
            
            end case;
            
         end if;
      end process draw_circle;
                        
end Behavioral;
