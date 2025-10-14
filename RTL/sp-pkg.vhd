library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spPKG is 
	
	constant INSTR_LENGTH : integer   := 64; --#Istruction bits
	constant N_opcode : integer       := 4; --#Opcode bits
	constant N_color : integer        := 24; --#RGB bits
	constant N_pixel : integer        := 8; --#Pixel coordinates bits
	constant N_Accelerators : integer := 6; --#Accelerators

	type instr_isa is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F, NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR);
	type fsm_state is (normal, drawing, halt);
	type pixel_array is array(0 to N_Accelerators-1) of std_logic_vector(N_pixel-1 downto 0);
	type color_array is array(0 to N_Accelerators-1) of std_logic_vector(N_color-1 downto 0);

end package;