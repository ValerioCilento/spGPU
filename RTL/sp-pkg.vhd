library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spPKG is 
	
	constant INSTR_LENGTH   : integer := 64; --#Istruction bits
	constant N_opcode       : integer := 8; --#Opcode bits
	constant N_color        : integer := 15; --#RGB bits
	constant N_pixel        : integer := 9; --#Pixel coordinates bits
	constant N_Accelerators : integer := 8; --#Accelerators
	constant FIFO_DEPTH     : integer := 12; --#Fifo available instruction locations
	constant CLK_CNT        : integer := 27; --#bit used to represent #clock cycles per second log2(10^8)
	constant SWAP_CNT       : integer := 10; --#bit used to count #swaps per second (#FPS) max 1024 fps
	constant TC_VALUE       : std_logic_vector := "101111101011110000011111111"; --terminal count value for a 100MHz clk (10^8 - 1)

	type instr_isa is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F, NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR, SWAP_BUFFERS);
	type fsm_state is (normal, drawing, halt);
	type pixel_array is array(0 to N_Accelerators-1) of std_logic_vector(N_pixel-1 downto 0);
	type color_array is array(0 to N_Accelerators-1) of std_logic_vector(N_color-1 downto 0);
	type scfifo is array(0 to FIFO_DEPTH-1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	type valid_array is array(0 to N_Accelerators-1) of std_logic;

end package;