library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spPKG is 
	
	constant INSTR_LENGTH   : integer := 64; --#Istruction bits
	constant N_opcode       : integer := 8; --#Opcode bits
	constant N_color        : integer := 24; --#RGB bits
	constant N_pixel        : integer := 8; --#Pixel coordinates bits
	constant N_Accelerators : integer := 8; --#Accelerators
	constant FIFO_DEPTH     : integer := 12; --#Fifo available instruction locations
	constant N_cores        : integer := 10; --#Cores/Tiles

	type instr_isa is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F, NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR, SWAP_BUFFERS);
	type fsm_state is (normal, drawing, halt);
	type sch_state is (request, schedule);
	type pixel_array is array(0 to N_Accelerators-1) of std_logic_vector(N_pixel-1 downto 0);
	type color_array is array(0 to N_Accelerators-1) of std_logic_vector(N_color-1 downto 0);
	type scfifo is array(0 to FIFO_DEPTH-1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	type valid_array is array(0 to N_Accelerators-1) of std_logic;
	type sch_instr is array(0 to N_cores) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	type y_tile_array_t is array (0 to N_cores - 1) of integer;

	constant Y_TILE_START : y_tile_array_t := calc_y_tile_start;

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

end package;