library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity edge_fill_top_v2 is
Port ( 
    x1, y1, x2, y2, x3, y3 : in std_logic_vector(7 downto 0);
    clk, rst, start : in std_logic;
    finish : out std_logic;
    color : in std_logic_vector(23 downto 0);
    pixel_color : out std_logic_vector(23 downto 0);
    pixel_x, pixel_y : out std_logic_vector(7 downto 0)
);
end edge_fill_top_v2;

architecture Behavioral of edge_fill_top_v2 is
    signal state, next_state : integer := 1;
    signal enb_comp, start_area, start_edge : std_logic;
    signal done_area, done_w0, done_w1, done_w2 : std_logic;
    signal x, y : std_logic_vector(7 downto 0);
    signal area, w0, w1, w2 : std_logic_vector(17 downto 0);
    signal minx, maxx, miny, maxy : std_logic_vector(7 downto 0);

    component edge_fill is 
    port(
        x1, y1, x2, y2, px, py : in std_logic_vector(7 downto 0); 
        clk, rst, start : in std_logic;
        done : out std_logic;
        area : out std_logic_vector(17 downto 0)
    );
    end component;
    
    component minmax is
    Port (
        enable : in std_logic; 
        x1, x2, x3, y1, y2, y3 : in std_logic_vector(7 downto 0);
        minx, miny, maxx, maxy : out std_logic_vector(7 downto 0)
    );
    end component;

begin
    
    MINMAX_MAP : minmax port map(
        enable => enb_comp,
        x1 => x1,
        x2 => x2,
        y1 => y1,
        y2 => y2,
        x3 => x3,
        y3 => y3,
        minx => minx,
        maxx => maxx,
        miny => miny,
        maxy => maxy
    );
    EDGE_AREA_MAP_1 : edge_fill port map(
        clk => clk,
        rst => rst,
        start => start_area,
        done => done_area,
        x1 => x1,
        y1 => y1,
        x2 => x2,
        y2 => y2,
        px => x3,
        py => y3,
        area => area
    );
    EDGE_AREA_MAP_2 : edge_fill port map(
        clk => clk,
        rst => rst,
        start => start_edge,
        done => done_w0,
        x1 => x2,
        y1 => y2,
        x2 => x3,
        y2 => y3,
        px => x,
        py => y,
        area => w0
    );
    EDGE_AREA_MAP_3 : edge_fill port map(
        clk => clk,
        rst => rst,
        start => start_edge,
        done => done_w1,
        x1 => x3,
        y1 => y3,
        x2 => x1,
        y2 => y1,
        px => x,
        py => y,
        area => w1
    );
    EDGE_AREA_MAP_4 : edge_fill port map(
        clk => clk,
        rst => rst,
        start => start_edge,
        done => done_w2,
        x1 => x1,
        y1 => y1,
        x2 => x2,
        y2 => y2,
        px => x,
        py => y,
        area => w2
    );

process(all) begin
    finish <= '0';
        case state is 
            when 1 =>
                if start = '1' then
                        next_state <= 2;
                else 
                        next_state <= 1;
                end if;
            when 2 =>
                if done_area = '1' then
                        next_state <= 3;
                else 
                        next_state <= 2;
                end if;
            when 3 => 
                if done_w0 = '1' and done_w1 = '1' and done_w2 = '1' then
                        next_state <= 4;
                else 
                        next_state <= 3;
                end if;
            when 4 => 
                next_state <= 5;
            when 5 =>
                if unsigned(x) < unsigned(maxx) then
                    next_state <= 3;
                else 
                    next_state <= 6;
                end if;
            when 6 =>
                if unsigned(y) < unsigned(maxy) then
                        next_state <= 3;
                else  
                        finish <= '1';
                        next_state <= 1;
                end if;
            when others => 
                next_state <= 1;
            end case;
      
end process;

process (clk, rst) begin
    if rst = '1' then
        state <= 1;
    elsif rising_edge(clk) then
        state <= next_state;
    end if;
end process;

data_path : process(clk, rst) 
begin
    if rst = '1' then
            enb_comp <= '0';
            start_area <= '0';
            x <= (others => '0');
            y <= (others => '0');
            start_edge <= '0';
            start_area <= '0'; 
            --pixel_x <= (others => '0');
            --pixel_y <= (others => '0');
            --pixel_color <= (others => '0');
    elsif rising_edge(clk) then
        case state is 
            when 1 => 
                enb_comp <= '0';
                start_area <= '0';
                x <= (others => '0');
                y <= (others => '0');
                start_edge <= '0';
            when 2 =>
                start_area <= '1';
                enb_comp <= '1';
                y <= miny;
                x <= minx;
            when 3 =>
                start_area <= '0';
                start_edge <= '1';
            when 4 =>
                start_edge <= '0';
                if signed(area) < 0 and signed(w0) <= 0 and signed( w1) <= 0 and signed(w2) <= 0 then
                        pixel_x <= x;
                        pixel_y <= y;
                        pixel_color <= color;
                elsif signed(area) >= 0 and signed(w0) >= 0 and signed( w1) >= 0 and signed(w2) >= 0 then
                        pixel_x <= x;
                        pixel_y <= y;
                        pixel_color <= color; 
                end if;
            when 5 =>
                     x <= std_logic_vector(unsigned(x) + 1);
            when 6 =>
                   y <= std_logic_vector(unsigned(y) + 1);
                   if unsigned(y) < unsigned(maxy) then
                        x <= minx;
                   end if;
            when others =>
                null;
            end case;
    end if;
end process;
end Behavioral;