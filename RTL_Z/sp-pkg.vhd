library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spPKG is 
	--============================================== CORE GENERICS =================================================================
	constant INSTR_LENGTH   : integer := 64; --#Istruction bits
	constant N_opcode       : integer := 4; --#Opcode bits
	constant N_color        : integer := 15; --#RGB bits
	constant N_pixel        : integer := 9; --#Pixel coordinates bits
	constant N_Accelerators : integer := 6; --#Accelerators
	constant FIFO_DEPTH     : integer := 12; --#Fifo available instruction locations
	constant N_z            : integer := 4; --#Z coordinate bits
	--==============================================================================================================================

	--=============================================== SP-ANALYZER GENERICS =========================================================
	constant CLK_CNT        : integer := 27; --#bit used to represent #clock cycles per second log2(10^8)
	constant SWAP_CNT       : integer := 10; --#bit used to count #swaps per second (#FPS) max 1024 fps
	constant TC_VALUE       : std_logic_vector := "101111101011110000011111111"; --terminal count value for a 100MHz clk (10^8 - 1)
	--==============================================================================================================================

	--=============================================== FRAMEBUFFER GENERICS =========================================================
	constant VIDEO_X     	: integer := 320; --X coordinate of the frame resolution (different from VGA resolution)
    constant VIDEO_Y     	: integer := 240; --Y coordinate of the frame resolution (different from VGA resolution)
    constant VIDEO_PIXEL    : integer := 9; --Number of bit to represent X,Y coordinates
    --===============================================================================================================================

    --=====================================================VGA GENERICS==============================================================
    constant H_COORDINATE 	: integer := 640; --Horizontal coordinate of VGA resolution
    constant V_COORDINATE 	: integer := 480; --Vertical coordinate of VGA resolution
    constant N_coordinates  : integer := 10; --Number of bit to represent VGA coordinates
    constant HF_PORCH      	: integer := 16; --Horizontal front porch
    constant HB_PORCH      	: integer := 48; --Horizontal back porch
    constant VF_PORCH      	: integer := 10; --Vertical front porch
    constant VB_PORCH      	: integer := 33; --Vertical back porch
    constant HSYNC         	: integer := 96; --Horizontal sync 
    constant VSYNC         	: integer := 2; --Vertical sync
    --================================================================================================================================

    --================================================= SP CUSTOM TYPES ==============================================================
	type instr_isa   is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F, NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR, SWAP_BUFFERS);
	type fsm_state 	 is (normal, drawing, halt);
	type pixel_array is array(0 to N_Accelerators-1) of std_logic_vector(N_pixel-1 downto 0);
	type color_array is array(0 to N_Accelerators-1) of std_logic_vector(N_color-1 downto 0);
	type scfifo      is array(0 to FIFO_DEPTH-1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	type valid_array is array(0 to N_Accelerators-1) of std_logic;
    --================================================================================================================================
end package;