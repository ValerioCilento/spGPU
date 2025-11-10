library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spGPU is
	generic (
		INSTR_LENGTH   : integer := 64; --#Istruction bits
		FIFO_DEPTH     : integer := 12; --#Fifo available instruction locations
		N_opcode       : integer := 4; --#Opcode bits
		N_color        : integer := 24; --#RGB bits
		N_pixel        : integer := 8; --#Pixel coordinates bits
		N_Accelerators : integer := 6 --#Accelerators
	);
	port (
		clk, rst        : in std_logic;
		core_halt       : in std_logic;
		instr_word_axi  : in std_logic_vector(INSTR_LENGTH-1 downto 0);
		instr_valid_axi : in std_logic;
		swapped         : in std_logic;
		instr_req_sc    : out std_logic;
		finish_exec	    : out std_logic;
		pixel_valid_o   : out std_logic;
		fb_swap 	    : out std_logic;
		pixel_x_o       : out std_logic_vector(N_pixel-1 downto 0);
		pixel_y_o       : out std_logic_vector(N_pixel-1 downto 0);
		pixel_color_o   : out std_logic_vector(N_color-1 downto 0)
	);
end entity spGPU;

architecture RTL of spGPU is

	component spScheduler is
	generic(
		INSTR_LENGTH   : integer;
		FIFO_DEPTH     : integer
	);
	port(
		clk, rst        : in std_logic;
		core_halt       : in std_logic;
		instr_word_axi  : in std_logic_vector(INSTR_LENGTH-1 downto 0);
		instr_req_core  : in std_logic;
		instr_valid_axi : in std_logic;
		fifo_out_core   : out std_logic_vector(INSTR_LENGTH-1 downto 0);
		fifo_valid_core : out std_logic;
		instr_req_sc    : out std_logic
	);
	end component spScheduler;

	component spCORE is
	generic (
		INSTR_LENGTH   : integer;
		N_opcode       : integer;     
		N_color        : integer;      
		N_pixel        : integer;       
		N_Accelerators : integer
	);
	Port(
		clk, rst      : in std_logic;
		instr_valid   : in std_logic;
		instr_word    : in std_logic_vector(INSTR_LENGTH-1 downto 0);
		core_halt     : in std_logic;
		swapped		  : in std_logic;
		instr_req     : out std_logic;
		fb_swap 	  : out std_logic;
		pixel_valid_o : out std_logic;
		pixel_x_o     : out std_logic_vector(N_pixel-1 downto 0);
		pixel_y_o     : out std_logic_vector(N_pixel-1 downto 0);
		pixel_color_o : out std_logic_vector(N_color-1 downto 0)
	);
	end component spCORE;

	signal instr_req_core_wire  : std_logic;
	signal fifo_valid_core_wire : std_logic;
	signal fifo_out_core_wire   : std_logic_vector(INSTR_LENGTH-1 downto 0);

begin

	SCHEDULER : spScheduler
	generic map (
		INSTR_LENGTH => INSTR_LENGTH,
		FIFO_DEPTH   => FIFO_DEPTH
	)
	port map (
		clk             => clk,
		rst             => rst,
		core_halt       => core_halt,
		instr_word_axi  => instr_word_axi,
		instr_req_core  => instr_req_core_wire,
		instr_valid_axi => instr_valid_axi,
		fifo_out_core   => fifo_out_core_wire,
		fifo_valid_core => fifo_valid_core_wire,
		instr_req_sc    => instr_req_sc
	);

	CORE : spCORE
	generic map (
		INSTR_LENGTH   => INSTR_LENGTH,
		N_opcode       => N_opcode,     
		N_color        => N_color, 
		N_pixel        => N_pixel,  
		N_Accelerators => N_Accelerators
	)
	port map (
		clk           => clk,
		rst           => rst,      
		instr_valid   => fifo_valid_core_wire,
		instr_word    => fifo_out_core_wire,
		core_halt     => core_halt,  
		swapped	      => swapped,  
		instr_req     => instr_req_core_wire, 
		fb_swap       => fb_swap,	  
		pixel_valid_o => pixel_valid_o,
		pixel_x_o     => pixel_x_o,    
		pixel_y_o     => pixel_y_o,   
		pixel_color_o => pixel_color_o
	);
	
end architecture RTL;