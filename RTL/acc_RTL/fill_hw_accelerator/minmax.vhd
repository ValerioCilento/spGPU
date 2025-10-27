library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity minmax is
    generic (
            N_pixel : integer
    );
    Port (
    enable : in std_logic; 
    x1, x2, x3, y1, y2, y3 : in std_logic_vector(N_pixel-1 downto 0);
    minx, miny, maxx, maxy : out std_logic_vector(N_pixel-1 downto 0)
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
