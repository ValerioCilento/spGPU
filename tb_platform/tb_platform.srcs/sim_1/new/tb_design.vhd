----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2025 01:19:06 PM
-- Design Name: 
-- Module Name: tb_design - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_design is
--  Port ( );
end tb_design;

architecture Behavioral of tb_design is
  component design_1_wrapper is
  port (
    M_AXIS_ACLK_0 : in STD_LOGIC;
    M_AXIS_ARESETN_0 : in STD_LOGIC;
    instr_word_0 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    ready_enb_0 : in STD_LOGIC
  );
    end component;
    
    signal M_AXIS_ACLK_0 :  STD_LOGIC;
    signal M_AXIS_ARESETN_0 :  STD_LOGIC;
    signal instr_word_0 :  STD_LOGIC_VECTOR ( 63 downto 0 );
    signal ready_enb_0 :  STD_LOGIC;
begin
    DUT : design_1_wrapper port map(
        M_AXIS_ACLK_0 => M_AXIS_ACLK_0,
        M_AXIS_ARESETN_0 => M_AXIS_ARESETN_0,
        instr_word_0 => instr_word_0,
        ready_enb_0 => ready_enb_0
    );
    
    process begin
        M_AXIS_ACLK_0 <= '1';
        wait for 5 ns;
        M_AXIS_ACLK_0 <= '0';
        wait for 5 ns;
    end process;


M_AXIS_ARESETN_0 <= '0', '1' after 30 ns;
ready_enb_0 <= '0', '1' after 50 ns, '0' after 60 ns, '1' after 100 ns, '0' after 110 ns;

end Behavioral;
