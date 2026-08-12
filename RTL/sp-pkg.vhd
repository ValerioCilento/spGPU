library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ====================
-- PACKAGE DECLARATION 
-- ====================

package spPKG is 

	--============================================== CORE GENERICS =====================
	constant INSTR_LENGTH   : integer := 64; 
	constant N_opcode        : integer := 8;  
	constant N_color        : integer := 15; 
	constant N_pixel        : integer := 9;  
	constant N_Accelerators : integer := 6;  
	--==================================================================================

	--=============================================== SP-ANALYZER GENERICS =============
	constant CLK_CNT        : integer := 27; 
	constant SWAP_CNT       : integer := 10; 
	constant TC_VALUE       : integer := 99999999; 
	--==================================================================================

	--=============================================== FRAMEBUFFER GENERICS =============
	constant VIDEO_X        : integer := 320; 
    constant VIDEO_Y        : integer := 240; 
    constant VIDEO_PIXEL    : integer := 9; 
    --==================================================================================

    --=====================================================VGA GENERICS=================
    constant H_COORDINATE 	: integer := 640; 
    constant V_COORDINATE 	: integer := 480; 
    constant N_coordinates  : integer := 10; 
    constant HF_PORCH       : integer := 16; 
    constant HB_PORCH       : integer := 48; 
    constant VF_PORCH       : integer := 10; 
    constant VB_PORCH       : integer := 33; 
    constant HSYNC          : integer := 96; 
    constant VSYNC          : integer := 2;  
    --==================================================================================

    --============================================== SCHEDULER GENERICS ================
	constant FIFO_DEPTH     : integer := 12; 
	constant N_cores        : integer := 10;
    --==================================================================================

    --================================================= SP CUSTOM TYPES ================
	type instr_isa   is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F, NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR, SWAP_BUFFERS);
	type fsm_state 	 is (normal, drawing, halt);
	type sch_state   is (request, schedule);
	type y_tile_array_t is array (0 to N_cores - 1) of integer; 
	type sch_instr   is array(0 to N_cores - 1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	type pixel_array is array(0 to N_Accelerators-1) of std_logic_vector(N_pixel-1 downto 0);
	type color_array is array(0 to N_Accelerators-1) of std_logic_vector(N_color-1 downto 0);
	type scfifo      is array(0 to FIFO_DEPTH-1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	type valid_array is array(0 to N_Accelerators-1) of std_logic;
    --==================================================================================

    --===================================================== FUNCTIONS ==================
	function max_val(a, b : unsigned) return unsigned;
	function min_val(a, b : unsigned) return unsigned;
    function calc_y_tile_start return y_tile_array_t;
    --==================================================================================

    -- ======================================= COSTANTE DIFFERITA (DEFERRED CONSTANT) ==
    constant Y_TILE_START : y_tile_array_t;
    -- =================================================================================

end package;

-- =============
-- PACKAGE BODY 
-- =============

package body spPKG is

	function max_val(a, b : unsigned) return unsigned is
	begin
    	if a > b then return a; else return b; end if;
	end function;

	function min_val(a, b : unsigned) return unsigned is
	begin
    	if a < b then return a; else return b; end if;
	end function;

    function calc_y_tile_start return y_tile_array_t is
        variable v_array : y_tile_array_t;
        constant TILE_H  : integer := VIDEO_Y / N_cores;
    begin
        for i in 0 to N_cores - 1 loop
            v_array(i) := i * TILE_H;
        end loop;
        return v_array;
    end function;

    constant Y_TILE_START : y_tile_array_t := calc_y_tile_start;

end package body;
