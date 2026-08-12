library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;
library work;
use work.spPKG.all;

entity spCORE is 
generic (
	INSTR_LENGTH : integer := 64; --#Istruction bits
	N_opcode : integer:= 4; --#Opcode bits
	N_color : integer := 15; --#RGB bits
	N_pixel : integer := 9; --#Pixel coordinates bits
	N_z     : integer := 4;
	N_Accelerators : integer:= 6; --#Accelerators
	SWAP_CNT : integer := 10; --#bit used to count #swaps per second (#FPS) max 1024 fps
	CLK_CNT : integer := 27; --#bit used to represent #clock cycles per second log2(10^8)
	TC_VALUE : std_logic_vector:= "101111101011110000011111111" --terminal count value for a 100MHz clk (10^8 - 1)
);
Port(
	clk, rst                         : in std_logic;
	instr_valid 			         : in std_logic;
	instr_word                       : in std_logic_vector(INSTR_LENGTH-1 downto 0);
	core_halt                        : in std_logic;
	swapped					         : in std_logic;
	z_out                            : out std_logic_vector(N_z-1 downto 0);
	instr_req   			         : out std_logic;
	fb_swap 				         : out std_logic;
	pixel_valid_o                    : out std_logic;
	pixel_x_o                        : out std_logic_vector(N_pixel-1 downto 0);
	pixel_y_o                        : out std_logic_vector(N_pixel-1 downto 0);
	pixel_color_o                    : out std_logic_vector(N_color-1 downto 0);
	int_pin                          : out std_logic;
	fps                              : out std_logic_vector(SWAP_CNT-1 downto 0)
);
end entity;

architecture STRUCTURAL of spCORE is 

	component spPIPE is 
    generic(
        INSTR_LENGTH : integer   := 64; --#Istruction bits
        N_opcode : integer       := 8; --#Opcode bits
        N_color : integer        := 24; --#RGB bits
        N_pixel : integer        := 8; --#Pixel coordinates bits
        N_z     : integer        := 4;
        N_Accelerators : integer := 6 --#Accelerators
    );
    port(
        clk, rst 				: in std_logic;
        instr_valid 			: in std_logic;
        instr_word      		: in std_logic_vector(INSTR_LENGTH-1 downto 0);
        finish_exec	    		: in std_logic;
        core_halt               : in std_logic;
        z_o                     : out std_logic_vector(N_z-1 downto 0);
        instr_req   			: out std_logic;
        x1, y1, x2, y2, x3, y3  : out std_logic_vector(N_pixel-1 downto 0);
        color                   : out std_logic_vector(N_color-1 downto 0);
        acc_enable_vec          : out std_logic_vector(N_Accelerators-1 downto 0); --1Pixel|2Line|3Triangle|4Filled Triangle|5Circle|6Filled Circle
        acc_busy_vec 			: out std_logic_vector(N_Accelerators-1 downto 0);
        swap 					: out std_logic
            );
	end component;

	component spEXEC is
    generic(
        INSTR_LENGTH : integer   := 64; --#Istruction bits
        N_opcode : integer       := 8; --#Opcode bits
        N_color : integer        := 15; --#RGB bits
        N_pixel : integer        := 8; --#Pixel coordinates bits
        N_z     : integer        := 4;
        N_Accelerators : integer := 6 --#Accelerators
    );
    port(
        clk, rst 				: in std_logic;
        x1, y1, x2, y2, x3, y3  : in std_logic_vector(N_pixel-1 downto 0);
        color                   : in std_logic_vector(N_color-1 downto 0);
        acc_enable_vec          : in std_logic_vector(N_Accelerators-1 downto 0);
        acc_busy_vec            : in std_logic_vector(N_Accelerators-1 downto 0);
        swap 					: in std_logic;
        swapped                 : in std_logic;
        z_in                    : in std_logic_vector(N_z-1 downto 0);
        z_out                   : out std_logic_vector(N_z-1 downto 0);
        finish_exec	    		: out std_logic;
        pixel_valid_o           : out std_logic;
        fb_swap 				: out std_logic;
        pixel_x_o               : out std_logic_vector(N_pixel-1 downto 0);
        pixel_y_o               : out std_logic_vector(N_pixel-1 downto 0);
        pixel_color_o           : out std_logic_vector(N_color-1 downto 0)
    );
	end component;

	component spANALYZER is
		generic(
			CLK_CNT : integer; --#bit used to represent #clock cycles per second log2(10^8)
			SWAP_CNT : integer; --#bit used to count #swaps per second (#FPS) max 1024 fps
			TC_VALUE : std_logic_vector --terminal count value for a 100MHz clk (10^8 - 1)
		);
		port (
			clk, rst : in std_logic;
			swapped  : in std_logic;
		    int_pin  : out std_logic;
			fps      : out std_logic_vector(SWAP_CNT-1 downto 0)
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
    signal z_wire : std_logic_vector(N_z-1 downto 0);
begin

	PIPE : spPIPE generic map(
		INSTR_LENGTH 	=> INSTR_LENGTH,
		N_opcode 		=> N_opcode,
		N_color 		=> N_color,
		N_pixel 		=> N_pixel,
		N_z             => N_z,
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
		z_o             => z_wire,
		x1 				=> x1_wire,
		x2 				=> x2_wire,
		y1 				=> y1_wire,
		y2 				=> y2_wire,
		x3 				=> x3_wire,
		y3 				=> y3_wire,
		color 			=> color_wire,
		acc_enable_vec 	=> acc_enable_wire,
		acc_busy_vec    => acc_busy_wire,
		swap 			=> swap_wire
			);

	EXEC : spEXEC generic map(
		INSTR_LENGTH 	=> INSTR_LENGTH,
		N_opcode 		=> N_opcode,
		N_color 		=> N_color,
		N_pixel 		=> N_pixel,
		N_z             => N_z,
		N_Accelerators	=> N_Accelerators
	)
	port map(
		clk 			=> clk,
		rst 			=> rst,
		swap 			=> swap_wire,
		x1 				=> x1_wire,
		x2 				=> x2_wire,
		y1 				=> y1_wire,
		y2 				=> y2_wire,
		x3 				=> x3_wire,
		y3 				=> y3_wire,
		z_in            => z_wire,
		z_out           => z_out,
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

	ANALYZER : spANALYZER generic map (
		CLK_CNT  => CLK_CNT,
		SWAP_CNT => SWAP_CNT,
		TC_VALUE => TC_VALUE
	)
	port map (
		clk     => clk,
		rst     => rst,
		swapped => swapped,  
		int_pin => int_pin,
		fps     => fps		
	);

end STRUCTURAL;