library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;


entity spEXEC is
generic(
	INSTR_LENGTH : integer   := 64; --Number of bits of the instruction
	N_opcode : integer       := 4;
	N_color : integer        := 24; --Number of bits of color vector
	N_pixel : integer        := 8; --Number of bits of every coordinate
	N_Accelerators : integer := 6 --Number of accelerators in the Execution Unit
);
port(
	clk, rst 				: in std_logic;
	core_halt               : in std_logic;
	dec_inst_i              : in instr_isa;
	inst_i                  : in std_logic_vector(INSTR_LENGTH-1 downto 0)

);
end entity;

architecture RTL of spEXEC is

	type instr_isa is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR);
	signal x1, y1, x2, y2, x3, y3 : std_logic_vector(N_pixel-1 downto 0);
	signal color                  : std_logic_vector(N_color-1 downto 0);
	signal acc_enable_vec         : std_logic_vector(N_Accelerators-1 downto 0);

	component LINE_ACC is --Line accelerator
	port ( 
	    clk, rst, start : in std_logic;
	    x1, x2, y1, y2 : in std_logic_vector(7 downto 0);
	    color : in std_logic_vector(23 downto 0);
	    --z_in : in std_logic; 
	    --z_out : out std_logic;
	    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    finish, pixel_valid : out std_logic
    );
    end component;

    component EDGE_FILL_TOP_V2 is --Triangle accelerator
    Port ( 
	    x1, y1, x2, y2, x3, y3 : in std_logic_vector(7 downto 0);
	    clk, rst, start : in std_logic;
	    finish : out std_logic;
	    color : in std_logic_vector(23 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    pixel_x, pixel_y : out std_logic_vector(7 downto 0)
	);
	end component;

	component CIRCLE_ACC is --Empty circle accelerator
	Port ( 
	    clk, rst, start : in std_logic;
	    xc, yc, r: in std_logic_vector(7 downto 0);
	    color : in std_logic_vector(23 downto 0);
	    --z_in : in std_logic; 
	    --z_out : out std_logic;
	    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    finish : out std_logic
	);
	end component;

		component F_CIRCLE_ACC is --Filled circle accelerator
	Port ( 
	    clk, rst, start : in std_logic;
	    xc, yc, r: in std_logic_vector(7 downto 0);
	    color : in std_logic_vector(23 downto 0);
	    --z_in : in std_logic; 
	    --z_out : out std_logic;
	    pixel_x, pixel_y : out std_logic_vector(7 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    finish : out std_logic
	);
	end component;
	
begin

	mapper_proc : process(clk, rst)
	begin
		if rst = '1' then
			x1             <= (others => '0');
			y1             <= (others => '0');
			x2             <= (others => '0');
			y2             <= (others => '0');
			x3             <= (others => '0');
			y3             <= (others => '0');
			color          <= (others => '0');
			acc_enable_vec <= (others => '0');
		elsif rising_edge(clk) then
			case dec_inst_i is 
				when NOP => 
					x1             <= (others => '0');
					y1             <= (others => '0');
					x2             <= (others => '0');
					y2             <= (others => '0');
					x3             <= (others => '0');
					y3             <= (others => '0');
					color          <= (others => '0');
					acc_enable_vec <= (others => '0');
				when DRAWPIXEL =>
					x1             <= instr_i((N_pixel+N_opcode)-1 downto N_opcode);
					y1             <= instr_i(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode);
					acc_enable_vec <= "000001";			
				when DRAWLINE =>
					x1             <= instr_i((N_pixel+N_opcode)-1 downto N_opcode);
					y1             <= instr_i(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
					x2             <= instr_i(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
					y2             <= instr_i(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
					acc_enable_vec <= "000010";
				when DRAWTRIANGLE  =>
					x1             <= instr_i((N_pixel+N_opcode)-1 downto N_opcode);
					y1             <= instr_i(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
					x2             <= instr_i(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
					y2             <= instr_i(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
					x3             <= instr_i(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
					y3             <= instr_i(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));
					acc_enable_vec <= "000100";
				when DRAWTRIANGLE_F =>	
					x1             <= instr_i((N_pixel+N_opcode)-1 downto N_opcode);
					y1             <= instr_i(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
					x2             <= instr_i(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
					y2             <= instr_i(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
					x3             <= instr_i(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
					y3             <= instr_i(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));
					acc_enable_vec <= "001000";
				when DRAWCIRCLE =>
					x1             <= instr_i((N_pixel+N_opcode)-1 downto N_opcode); --Center x coord (xc)
					y1             <= instr_i(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode)); --Center y coord (yc)
					x2             <= instr_i(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode)); --Radius	(r)	
					acc_enable_vec <= "010000";					
				when DRAWCIRCLE_F =>
					x1             <= instr_i((N_pixel+N_opcode)-1 downto N_opcode); --Center x coord (xc)
					y1             <= instr_i(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode)); --Center y coord (yc)
					x2             <= instr_i(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode)); --Radius	(r)	
					acc_enable_vec <= "100000";
				when SETCOLOR =>
					color          <= instr_i((N_color+N_opcode)-1 downto N_opcode); --Color of the next figure (rgb 24bit)
				when others =>
					x1             <= (others => '0');
					y1             <= (others => '0');
					x2             <= (others => '0');
					y2             <= (others => '0');
					x3             <= (others => '0');
					y3             <= (others => '0');
					color          <= (others => '0');
					acc_enable_vec <= (others => '0');
			end case;
		end if;	
	end process;

	LINE_ : LINE_ACC
	port map(
		clk   		=> clk;
		rst   		=> rst;
		start 		=> acc_enable_vec(1);
		x1    		=> x1;
		y1   		=> y1;
		x2          => x2;
		y2          => y2;
		color       => color;
		pixel_x     =>
		pixel_y     =>
		pixel_color =>
		finish 		=>
		pixel_valid =>
	);

	TRIANGLE_ : EDGE_FILL_TOP_V2
	port map(
		clk   		=> clk;
		rst   		=> rst;
		start 		=> acc_enable_vec(2);
		x1    		=> x1;
		y1   		=> y1;
		x2          => x2;
		y2          => y2;
		x3          => x3;
		y3          => y3;
		color       => color;
		pixel_x     =>
		pixel_y     =>
		pixel_color =>
		finish 		=>
	);

	CIRCLE_ : CIRCLE_ACC
	port map(
		clk   		=> clk;
		rst   		=> rst;
		start 		=> acc_enable_vec(4);
		xc    		=> x1;
		yc   		=> y1;
		r           => x2;
		color       => color;
		pixel_x     =>
		pixel_y     =>
		pixel_color =>
		finish 		=>
	);

	FCIRCLE_ : F_CIRCLE_ACC
	port map(
		clk   		=> clk;
		rst   		=> rst;
		start 		=> acc_enable_vec(5);
		xc    		=> x1;
		yc   		=> y1;
		r           => x2;
		color       => color;
		pixel_x     =>
		pixel_y     =>
		pixel_color =>
		finish 		=>
	);

end RTL;

