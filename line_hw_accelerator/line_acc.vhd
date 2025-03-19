library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity line_acc is
Port ( 
    clk, rst, start : in std_logic;
    x1, x2, y1, y2 : in std_logic_vector(7 downto 0);
    color : in std_logic_vector(23 downto 0);
    z_in : in std_logic; 
    z_out : out std_logic;
    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
    pixel_color : out std_logic_vector(23 downto 0);
    finish : out std_logic
);
end line_acc;

architecture Behavioral of line_acc is
    type state_type is (IDLE, DRAW, DONE);
    signal state : state_type := IDLE;
    
    
begin
    z_out <= z_in;
    pixel_color <= color;
    
    process(clk ,rst) 
        variable dx, dy, err, sx, sy, e2 : integer;
        variable x_temp, y_temp : std_logic_vector(7 downto 0);
    begin
        if rst = '1' then
            pixel_x <= (others => '0');
            pixel_y <= (others => '0');
            finish <= '0';
            dx := 0;
            dy := 0;
            err := 0;
            sx := 0;
            sy := 0;
            e2 := 0;
        elsif rising_edge(clk) then
            case state is 
                when IDLE => 
                    finish <= '0';
                    x_temp := x1;
                    y_temp := y1;
                    if start = '1' then
                        dx := abs(to_integer(unsigned(x2)) - to_integer(unsigned(x1)));
                        dy := abs(to_integer(unsigned(y2)) - to_integer(unsigned(y1)));
                        if unsigned(x1) < unsigned(x2) then
                            sx := 1;
                        else sx := -1;
                        end if;
                        if unsigned(y1) < unsigned(y2) then
                            sy := 1;
                        else sy := -1;
                        end if;
                        err := dx - dy;
                        state <= DRAW;
                    end if;
               when DRAW => 
                    finish <= '0';
                    if unsigned(x1) /= unsigned(x2) or unsigned(y1) /= unsigned(y2) then
                        pixel_x <= x_temp;
                        pixel_y <= y_temp;
                        e2 := 2*err;
                        if(e2 > (-dy)) then
                            err := err - dy;
                            x_temp := std_logic_vector(unsigned(x_temp) + 1);
                        end if;
                        
                        if (e2 < dx) then
                            err := err + dx;
                            y_temp := std_logic_vector(unsigned(y_temp) + 1);
                        end if;
                        
                        state <= DRAW;
                    else 
                        state <= DONE;
                    end if;
              when DONE =>
                   finish <= '0';
                   state <= IDLE;
             when others => 
                    state <= IDLE;
             end case;
        end if;
    end process;

end Behavioral;
