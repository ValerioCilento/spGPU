library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity edge_fill_v2 is
    generic(
        N_pixel : integer
    );
Port ( 
    x1, y1, x2, y2, px, py : in std_logic_vector(N_pixel-1 downto 0); 
    clk, rst, start : in std_logic;
    done : out std_logic;
    area : out std_logic_vector((N_pixel+N_pixel+1) downto 0)
);
end edge_fill_v2;

architecture Behavioral of edge_fill_v2 is
    type state_t is (IDLE, CALC1, CALC2, CALC3, FINISH);
    signal state, next_state : state_t;
    signal x1_s, y1_s, x2_s, y2_s, px_s, py_s : std_logic_vector(N_pixel downto 0);
    signal area1, area2 : std_logic_vector((N_pixel+N_pixel+1) downto 0);
    SIGNAL tmp1, tmp2,tmp3, tmp4 : signed(N_pixel downto 0);

--   -- I tuoi registri
--    signal x1_reg, y1_reg, x2_reg, y2_reg, px_reg, py_reg : std_logic_vector(N_pixel-1 downto 0);

--    -- ==========================================
--    -- LO SCUDO ANTI-OTTIMIZZAZIONE
--    -- ==========================================
--    -- L'Opzione Nucleare per bloccare le ottimizzazioni
--    attribute KEEP : string;
--    attribute MARK_DEBUG : string;
    
--    attribute KEEP of x1_reg : signal is "TRUE";
--    attribute MARK_DEBUG of x1_reg : signal is "TRUE";
    
--    attribute KEEP of y1_reg : signal is "TRUE";
--    attribute MARK_DEBUG of y1_reg : signal is "TRUE";
    
--    attribute KEEP of x2_reg : signal is "TRUE";
--    attribute MARK_DEBUG of x2_reg : signal is "TRUE";
    
--    attribute KEEP of y2_reg : signal is "TRUE";
--    attribute MARK_DEBUG of y2_reg : signal is "TRUE";
    
--    attribute KEEP of px_reg : signal is "TRUE";
--    attribute MARK_DEBUG of px_reg : signal is "TRUE";
    
--    attribute KEEP of py_reg : signal is "TRUE";
--    attribute MARK_DEBUG of py_reg : signal is "TRUE";

begin

--    -- PROCESSO AGGIUNTO: Registrazione immediata degli ingressi
--    process(clk) begin
--        if rising_edge(clk) then
--            x1_reg <= x1;
--            y1_reg <= y1;
--            x2_reg <= x2;
--            y2_reg <= y2;
--            px_reg <= px;
--            py_reg <= py;
--        end if;
--    end process;

    -- Concatenazione usando i segnali registrati anziché i pin diretti
    x1_s <= "0"&x1;
    y1_s <= "0"&y1;
    x2_s <= "0"&x2;
    y2_s <= "0"&y2;
    px_s <= "0"&px;
    py_s <= "0"&py;
    
    -- DA QUI IN POI IL CODICE È IDENTICO AL TUO
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
            tmp1 <= (others => '0');
            tmp2 <= (others => '0');
            tmp3 <= (others => '0');
            tmp4 <= (others => '0');
            area1 <= (others => '0');
            area2 <= (others => '0');
            area <= (others => '0');
        elsif rising_edge(clk) then
            case state is 
                when IDLE =>
                    tmp1 <= (others => '0');
                    tmp2 <= (others => '0');
                    tmp3 <= (others => '0');
                    tmp4 <= (others => '0');
                    area1 <= (others => '0');
                    area2 <= (others => '0');
                    area <= (others => '0');
                when CALC1 =>
                    tmp1 <= signed(px_s) - signed(x1_s);
                    tmp2 <= signed(y2_s) - signed(y1_s);
                    tmp3 <= signed(py_s) - signed(y1_s);
                    tmp4 <= signed(x2_s) - signed(x1_s);
                when CALC2 =>
                    area1 <= std_logic_vector(tmp1*tmp2);
                    area2 <= std_logic_vector(tmp3*tmp4);
                when CALC3 =>
                    area <= std_logic_vector(signed(area1) - signed(area2));
                when FINISH =>
                    null;
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;