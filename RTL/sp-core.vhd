library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.spPKG.all;

entity spCORE is 
generic (
	INSTR_LENGTH : integer   := 64; --#Istruction bits
	N_opcode : integer       := 4; --#Opcode bits
	N_color : integer        := 24; --#RGB bits
	N_pixel : integer        := 10; --#Pixel coordinates bits
	N_Accelerators : integer := 6 --#Accelerators
);
Port(
	clk, rst : in std_logic;
	instr_valid 			: in std_logic;
	instr_word      		: in std_logic_vector(INSTR_LENGTH-1 downto 0);
	core_halt               : in std_logic;
	swapped					: in std_logic;
	instr_req   			: out std_logic;
	fb_swap 				: out std_logic;
	pixel_valid_o           : out std_logic;
	pixel_x_o               : out std_logic_vector(N_pixel-1 downto 0);
	pixel_y_o               : out std_logic_vector(N_pixel-1 downto 0);
	pixel_color_o           : out std_logic_vector(N_color-1 downto 0)
);
end entity;

architecture STRUCTURAL of spCORE is 

	component spPIPE is 
		generic(
			INSTR_LENGTH : integer; --#Istruction bits
			N_opcode : integer; --#Opcode bits
			N_color : integer; --#RGB bits
			N_pixel : integer; --#Pixel coordinates bits
			N_Accelerators : integer --#Accelerators
		);
		port(
			clk, rst 				: in std_logic;
			instr_valid 			: in std_logic;
			instr_word      		: in std_logic_vector(INSTR_LENGTH-1 downto 0);
			finish_exec	    		: in std_logic;
			core_halt               : in std_logic;
			instr_req   			: out std_logic;
			dec_instr_o             : out instr_isa;
			x1, y1, x2, y2, x3, y3  : out std_logic_vector(N_pixel-1 downto 0);
			color                   : out std_logic_vector(N_color-1 downto 0);
			acc_busy_vec            : out std_logic_vector(N_Accelerators-1 downto 0);
			swap 					: out std_logic;
			acc_enable_vec          : out std_logic_vector(N_Accelerators-1 downto 0); --1Pixel|2Line|3Triangle|4Filled Triangle|5Circle|6Filled Circle
			instr_o                 : out std_logic_vector(INSTR_LENGTH-1 downto 0)
		);
	end component;

	component spEXEC is
		generic(
			INSTR_LENGTH : integer; --#Istruction bits
			N_opcode : integer; --#Opcode bits
			N_color : integer; --#RGB bits
			N_pixel : integer; --#Pixel coordinates bits
			N_Accelerators : integer  --#Accelerators
		);
		port(
			clk, rst 				: in std_logic;
			--core_halt               : in std_logic;
			dec_inst_i              : in instr_isa;
			instr_i                 : in std_logic_vector(INSTR_LENGTH-1 downto 0);
			x1, y1, x2, y2, x3, y3  : in std_logic_vector(N_pixel-1 downto 0);
			color                   : in std_logic_vector(N_color-1 downto 0);
			acc_enable_vec          : in std_logic_vector(N_Accelerators-1 downto 0);
			acc_busy_vec            : in std_logic_vector(N_Accelerators-1 downto 0);
			swap 					: in std_logic;
			swapped                 : in std_logic;
			finish_exec	    		: out std_logic;
			pixel_valid_o           : out std_logic;
			fb_swap 				: out std_logic;
			pixel_x_o               : out std_logic_vector(N_pixel-1 downto 0);
			pixel_y_o               : out std_logic_vector(N_pixel-1 downto 0);
			pixel_color_o           : out std_logic_vector(N_color-1 downto 0)
		);
	end component;

	signal finish_exec_wire : std_logic;
	signal dec_instr_wire : instr_isa;
	signal x1_wire, x2_wire, y1_wire, y2_wire, x3_wire, y3_wire : std_logic_vector(N_pixel-1 downto 0);
	signal color_wire : std_logic_vector(N_color-1 downto 0);
	signal acc_enable_wire : std_logic_vector(N_Accelerators-1 downto 0);
	signal acc_busy_wire : std_logic_vector(N_Accelerators-1 downto 0);
	signal instr_wire : std_logic_vector(INSTR_LENGTH-1 downto 0);
	signal swap_wire : std_logic;
begin
	PIPE : spPIPE generic map(
		INSTR_LENGTH 	=> INSTR_LENGTH,
		N_opcode 		=> N_opcode,
		N_color 		=> N_color,
		N_pixel 		=> N_pixel,
		N_Accelerators	=> N_Accelerators
	)
	port map(
		clk 			=> clk,
		rst 			=> rst,
		instr_valid 	=> instr_valid,
		instr_word 		=> instr_word,
		finish_exec 	=> finish_exec_wire,
		core_halt 		=> core_halt,
		instr_req 		=> instr_req,
		dec_instr_o 	=> dec_instr_wire,
		x1 				=> x1_wire,
		x2 				=> x2_wire,
		y1 				=> y1_wire,
		y2 				=> y2_wire,
		x3 				=> x3_wire,
		y3 				=> y3_wire,
		color 			=> color_wire,
		acc_enable_vec 	=> acc_enable_wire,
		acc_busy_vec    => acc_busy_wire,
		swap 			=> swap_wire,
		instr_o 		=> instr_wire
	);

	EXEC : spEXEC generic map(
		INSTR_LENGTH 	=> INSTR_LENGTH,
		N_opcode 		=> N_opcode,
		N_color 		=> N_color,
		N_pixel 		=> N_pixel,
		N_Accelerators	=> N_Accelerators
	)
	port map(
		clk 			=> clk,
		rst 			=> rst,
		dec_inst_i      => dec_instr_wire,
		instr_i			=> instr_wire,
		swap 			=> swap_wire,
		x1 				=> x1_wire,
		x2 				=> x2_wire,
		y1 				=> y1_wire,
		y2 				=> y2_wire,
		x3 				=> x3_wire,
		y3 				=> y3_wire,
		color 			=> color_wire,
		swapped 		=> swapped,
		acc_enable_vec 	=> acc_enable_wire,
		acc_busy_vec    => acc_busy_wire,
		finish_exec 	=> finish_exec_wire,
		fb_swap 		=> fb_swap,
		pixel_valid_o   => pixel_valid_o,
		pixel_x_o		=> pixel_x_o,
		pixel_y_o		=> pixel_y_o,
		pixel_color_o	=> pixel_color_o
	);

end STRUCTURAL;