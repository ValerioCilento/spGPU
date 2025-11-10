library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;


entity counter_pixel is 
    generic(
        VIDEO_X : integer;
        VIDEO_Y : integer;
        H_COORDINATE : integer;
        V_COORDINATE : integer;
        N_pixel      : integer;
        HF_PORCH      : integer;
        HB_PORCH      : integer;
        VF_PORCH      : integer;
        VB_PORCH      : integer;
        HSYNC         : integer;
        VSYNC         : integer
    );
    port(
        clk,rst : in std_logic;
        video_active : out std_logic; 
        image_enable : out std_logic;
        h_coord, v_coord : out std_logic_vector(N_pixel-1 downto 0);
        image_vsync_n : out std_logic;
        h_sync,v_sync : out std_logic
    );
end counter_pixel;


architecture RTL of counter_pixel is 
    signal acc_h : std_logic_vector(N_pixel-1 downto 0);
    signal acc_v : std_logic_vector(N_pixel-1 downto 0);
    signal en_v : std_logic;
    signal dve_h,dve_v : std_logic;
    signal h_en,v_en : std_logic;
begin
    horizontal_counter_proc : process(clk,rst) begin
        if rst = '1' then
            acc_h <= (others => '0');
        elsif rising_edge(clk) then
                if acc_h = std_logic_vector(to_unsigned(H_COORDINATE+HF_PORCH+HB_PORCH+HSYNC, N_pixel )) then --800
                    acc_h <= (others => '0');
                else 
                    acc_h <= std_logic_vector(unsigned(acc_h) + 1);
                end if;
            end if;
    end process;
    
    horizontal_timings_proc : process(acc_h) begin

        if (acc_h > std_logic_vector(to_unsigned(H_COORDINATE+HF_PORCH, N_pixel)) and acc_h < std_logic_vector(to_unsigned(H_COORDINATE+HF_PORCH+HSYNC, N_pixel ))) then
            h_sync <= '0';
        else 
            h_sync <= '1';
        end if;
        
        if(acc_h = std_logic_vector(to_unsigned(H_COORDINATE+HF_PORCH+HB_PORCH+HSYNC-1, N_pixel ))) then
            en_v <= '1';
        else 
            en_v<= '0';
        end if;
        
        if(acc_h < std_logic_vector(to_unsigned(H_COORDINATE, N_pixel))) then
            dve_h<= '1';         
        else 
            dve_h<= '0';
        end if;

        if acc_h < std_logic_vector(to_unsigned(VIDEO_X, N_pixel)) then --H_CORD = 256 
            h_en <= '1';   
            h_coord <= std_logic_vector(unsigned(acc_h) + 1);     
        elsif acc_h = std_logic_vector(to_unsigned(VIDEO_X, N_pixel)) then  --Bordo schermo max
            h_en <= '1';   
            h_coord <= (others => '0');
        elsif acc_h = std_logic_vector(to_unsigned(H_COORDINATE+HF_PORCH+HB_PORCH+HSYNC, N_pixel)) then
            h_en <= '1';   
            h_coord <= (others => '0');
        else 
            h_coord <= (others => '0');
            h_en <= '0';
        end if;
    end process;
    
    vertical_counter_proc : process(clk,rst) begin
        if rst = '1' then
            acc_v <= (others => '0');
        elsif rising_edge(clk) then
            if en_v = '1' then
                if acc_v = std_logic_vector(to_unsigned(V_COORDINATE+VF_PORCH+VB_PORCH+VSYNC, N_pixel)) then
                    acc_v <= (others => '0');
                else 
                    acc_v <= std_logic_vector(unsigned(acc_v) + 1);
                end if;
            end if;
        end if;
    end process;
    
    vertical_timings_proc : process(acc_v) begin

        if (acc_v > std_logic_vector(to_unsigned(V_COORDINATE+VF_PORCH, N_pixel) ) and acc_v< std_logic_vector(to_unsigned(V_COORDINATE+VF_PORCH+VSYNC, N_pixel ))) then
            v_sync <= '0';
        else 
            v_sync <= '1';
        end if;
        
        if(acc_v < std_logic_vector(to_unsigned(V_COORDINATE, N_pixel ))) then
            dve_v<= '1'; 
        else 
            dve_v<= '0';
        end if;
        
        if acc_v < std_logic_vector(to_unsigned(VIDEO_Y, N_pixel)) then --H_CORD = 256 
            v_en <= '1';   
            v_coord <= std_logic_vector(unsigned(acc_v) + 1);     
        elsif acc_v = std_logic_vector(to_unsigned(VIDEO_Y, N_pixel)) then  --Bordo schermo max
            v_en <= '1';   
            v_coord <= (others => '0');
        elsif acc_v = std_logic_vector(to_unsigned(V_COORDINATE+VF_PORCH+VB_PORCH+VSYNC, N_pixel)) then
            v_en <= '1';   
            v_coord <= (others => '0');
        else 
            v_coord <= (others => '0');
            v_en <= '0';
        end if;
    end process;

    image_vsync_proc : process(acc_h, acc_v) 
    begin
        if (acc_h > std_logic_vector(to_unsigned(VIDEO_X, N_pixel)) and acc_v > std_logic_vector(to_unsigned(VIDEO_Y, N_pixel))) then
            image_vsync_n <= '1';
        else 
            image_vsync_n <= '0';
        end if;
    end process;
    image_enable <= v_en and h_en;
    video_active <= dve_h and dve_v;
end RTL;