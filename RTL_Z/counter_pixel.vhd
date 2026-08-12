library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.spPKG.all;

entity counter_pixel is 
    generic(
        H_COORDINATE : integer;
        V_COORDINATE : integer;
        N_coordinates      : integer;
        VIDEO_pixel  : integer;
        HF_PORCH     : integer;
        HB_PORCH     : integer;
        VF_PORCH     : integer;
        VB_PORCH     : integer;
        HSYNC        : integer;
        VSYNC        : integer
    );
    port(
        clk, rst      : in std_logic;
        video_active  : out std_logic; 
        --image_enable  : out std_logic;
        h_coord       : out std_logic_vector(9 downto 0);
        v_coord       : out std_logic_vector(9 downto 0);
        h_sync, v_sync: out std_logic
    );
end counter_pixel;

architecture RTL of counter_pixel is 
    signal acc_h : std_logic_vector(9 downto 0);
    signal acc_v : std_logic_vector(9 downto 0);
   

begin

    counters : process(clk,rst) begin
    if rst = '1' then
            acc_h <= (others => '0');
            acc_v <= (others => '0');
        elsif rising_edge(clk) then
            if unsigned(acc_h) = to_unsigned(H_COORDINATE+HF_PORCH+HB_PORCH+HSYNC-1, 10) then 
                acc_h <= (others => '0');
                if unsigned(acc_v) = to_unsigned(V_COORDINATE+VF_PORCH+VB_PORCH+VSYNC-1, 10) then
                    acc_v <= (others => '0');
                else 
                    acc_v <= std_logic_vector(unsigned(acc_v) + 1);
                end if;
            else 
                acc_h <= std_logic_vector(unsigned(acc_h) + 1);
            end if;
        end if;
    end process;
    
    video_active <= '1' when (unsigned(acc_h) < to_unsigned(H_COORDINATE, 10) and unsigned(acc_v) < to_unsigned(V_COORDINATE, 10)) else '0';
    h_sync <= '0' when (unsigned(acc_h) >= to_unsigned(H_COORDINATE + HF_PORCH, 10) and unsigned(acc_h) < to_unsigned(H_COORDINATE+HF_PORCH+HSYNC, 10)) else '1';
    v_sync <= '0' when (unsigned(acc_v) >= to_unsigned(V_COORDINATE + VF_PORCH, 10) and unsigned(acc_v) < to_unsigned(V_COORDINATE+VF_PORCH+VSYNC, 10)) else '1';
    
    H_COORD <= acc_h when unsigned(acc_h) < to_unsigned(H_COORDINATE, 10) else (others => '0');
    V_COORD <= acc_v when unsigned(acc_v) < to_unsigned(V_COORDINATE, 10) else (others => '0');

end RTL;