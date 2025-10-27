library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.spPKG.all;

entity spEXEC is
generic(
	INSTR_LENGTH : integer   := 64; --#Istruction bits
	N_opcode : integer       := 4; --#Opcode bits
	N_color : integer        := 24; --#RGB bits
	N_pixel : integer        := 8; --#Pixel coordinates bits
	N_Accelerators : integer := 6 --#Accelerators
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
end entity;

architecture RTL of spEXEC is
	signal swap_state : integer := 0;
	signal acc_finish_vec : std_logic_vector(N_Accelerators-1 downto 0); --1Pixel|2Line|3Triangle|4Filled Triangle|5Circle|6Filled Circle
	signal pixel_wire_x : pixel_array; 
	signal pixel_wire_y : pixel_array;  
	signal pixel_color_wire : color_array;
	signal pixel_valid_wire : valid_array;
	signal finish_swap : std_logic;
	component LINE_ACC is --Line accelerator
		generic(
		    N_pixel : integer
		);
		Port ( 
		    clk, rst, start : in std_logic;
		    x1, x2, y1, y2 : in std_logic_vector(N_pixel-1 downto 0);
		    color : in std_logic_vector(23 downto 0);
		    --z_in : in std_logic; 
		    --z_out : out std_logic;
		    pixel_x, pixel_y : out std_logic_vector(N_pixel-1 downto 0);
		    pixel_color : out std_logic_vector(23 downto 0);
		    finish, pixel_valid : out std_logic
		);
	end component;

    component EDGE_FILL_TOP_V2 is --Triangle accelerator
    generic(
        N_pixel : integer
    );
	Port ( 
	    x1, y1, x2, y2, x3, y3 : in std_logic_vector(N_pixel-1 downto 0);
	    clk, rst, start : in std_logic;
	    finish : out std_logic;
	    color : in std_logic_vector(23 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    pixel_valid : out std_logic;
	    pixel_x, pixel_y : out std_logic_vector(N_pixel-1 downto 0)
	);
	end component;

	component CIRCLE_ACC is --Empty circle accelerator
	generic(
	    N_pixel : integer
	);
	Port ( 
	    clk, rst, start : in std_logic;
	    xc, yc, r: in std_logic_vector(N_pixel-1 downto 0);
	    color : in std_logic_vector(23 downto 0);
	    --z_in : in std_logic; 
	    --z_out : out std_logic;
	    pixel_valid : out std_logic;
	    pixel_x, pixel_y : out std_logic_vector(N_pixel-1 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    finish : out std_logic
	);
	end component;

	component F_CIRCLE_ACC is --Filled circle accelerator
	generic(
	    N_pixel : integer
	);
	Port ( 
	    clk, rst, start : in std_logic;
	    xc, yc, r: in std_logic_vector(N_pixel-1 downto 0);
	    color : in std_logic_vector(23 downto 0);
	    --z_in : in std_logic; 
	    --z_out : out std_logic;
	    pixel_x, pixel_y : out std_logic_vector(N_pixel-1 downto 0);
	    pixel_color : out std_logic_vector(23 downto 0);
	    pixel_valid : out std_logic;
	    finish : out std_logic
	);
	end component;
	signal resetn : std_logic;
begin
	acc_finish_vec(2) <= '0';
	acc_finish_vec(0) <= '0';
	pixel_valid_wire(0) <= '0';
	pixel_valid_wire(2) <= '0';

	finish_exec <= acc_finish_vec(1) or acc_finish_vec(3) or acc_finish_vec(4) or acc_finish_vec(5) or finish_swap;
	pixel_valid_o <= pixel_valid_wire(0) or pixel_valid_wire(1) or pixel_valid_wire(2) or pixel_valid_wire(3) or pixel_valid_wire(4) or pixel_valid_wire(5);
	resetn <= not rst;

	swap_instr : process(clk) 
	begin
		if rising_edge(clk) then
			case swap_state is 
				when 0 =>  --Waiting SWAP Instrunction
					finish_swap <= '0';
					if swap = '1' then
						swap_state <= 1;
					else 
						swap_state <= 0;
					end if;
				when 1 => --Swap until it's finished
					finish_swap <= '0';
					fb_swap <= '1';
					if swapped = '1' then
						swap_state <= 2;
					else 
						swap_state <= 1;
					end if;
				when 2 => --Swap finished
					finish_swap <= '1';
					fb_swap <= '0';
					swap_state <= 0;
				when others => 
					finish_swap <= '1';
					fb_swap <= '0';
					swap_state <= 0;
			end case;
		end if;
	end process;
	
	pixel_out_proc : process(acc_busy_vec, pixel_wire_x, pixel_wire_y)
	begin
		case acc_busy_vec is
			when "000010" => --Line
				pixel_x_o <= pixel_wire_x(1);
				pixel_y_o <= pixel_wire_y(1);
				pixel_color_o <= pixel_color_wire(1);
			when "001000" => --Filled Triangle
				pixel_x_o <= pixel_wire_x(3);
				pixel_y_o <= pixel_wire_y(3);
				pixel_color_o <= pixel_color_wire(3);
			when "010000" => --Circle
				pixel_x_o <= pixel_wire_x(4);
				pixel_y_o <= pixel_wire_y(4);
				pixel_color_o <= pixel_color_wire(4);
			when "100000" => --Filled Circle
				pixel_x_o <= pixel_wire_x(5);
				pixel_y_o <= pixel_wire_y(5);
				pixel_color_o <= pixel_color_wire(5);
			when others   => 
				pixel_x_o <= (others => '0');
				pixel_y_o <= (others => '0');
				pixel_color_o <= (others => '0');
		end case;
	end process pixel_out_proc;								

	LINE : LINE_ACC
	generic map(
		N_pixel => N_pixel
	)
	port map(
		clk   		=> clk,
		rst   		=> resetn,
		start 		=> acc_enable_vec(1),
		x1    		=> x1,
		y1   		=> y1,
		x2          => x2,
		y2          => y2,
		color       => color,
		pixel_x     => pixel_wire_x(1),
		pixel_y     => pixel_wire_y(1),
		pixel_color => pixel_color_wire(1),
		finish 		=> acc_finish_vec(1),
		pixel_valid => pixel_valid_wire(1)
	);

	TRIANGLE : EDGE_FILL_TOP_V2
	generic map(
		N_pixel => N_pixel
	)
	port map(
		clk   		=> clk,
		rst   		=> resetn,
		start 		=> acc_enable_vec(3),
		x1    		=> x1,
		y1   		=> y1,
		x2          => x2,
		y2          => y2,
		x3          => x3,
		y3          => y3,
		color       => color,
		pixel_x     => pixel_wire_x(3),
		pixel_y     => pixel_wire_y(3),
		pixel_color => pixel_color_wire(3),
		pixel_valid => pixel_valid_wire(3),
		finish 		=> acc_finish_vec(3)
	);

	CIRCLE : CIRCLE_ACC
	generic map(
		N_pixel => N_pixel
	)
	port map(
		clk   		=> clk,
		rst   		=> resetn,
		start 		=> acc_enable_vec(4),
		xc    		=> x1,
		yc   		=> y1,
		r           => x2,
		color       => color,
		pixel_valid => pixel_valid_wire(4),
		pixel_x     => pixel_wire_x(4),
		pixel_y     => pixel_wire_y(4),
		pixel_color => pixel_color_wire(4),
		finish 		=> acc_finish_vec(4)
	);

	FCIRCLE : F_CIRCLE_ACC
	generic map(
		N_pixel => N_pixel
	)
	port map(
		clk   		=> clk,
		rst   		=> resetn,
		start 		=> acc_enable_vec(5),
		xc    		=> x1,
		yc   		=> y1,
		r           => x2,
		color       => color,
		pixel_valid => pixel_valid_wire(5),
		pixel_x     => pixel_wire_x(5),
		pixel_y     => pixel_wire_y(5),
		pixel_color => pixel_color_wire(5),
		finish 		=> acc_finish_vec(5)
	);

end RTL;

