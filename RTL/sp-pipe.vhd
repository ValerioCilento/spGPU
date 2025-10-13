library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.spPKG.all;

entity spPIPE is 
generic(
	INSTR_LENGTH : integer   := 64; --#Istruction bits
	N_opcode : integer       := 4; --#Opcode bits
	N_color : integer        := 24; --#RGB bits
	N_pixel : integer        := 8; --#Pixel coordinates bits
	N_Accelerators : integer := 6 --#Accelerators
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
	acc_enable_vec          : out std_logic_vector(N_Accelerators-1 downto 0); --1Pixel|2Line|3Triangle|4Filled Triangle|5Circle|6Filled Circle
	instr_o                 : out std_logic_vector(INSTR_LENGTH-1 downto 0)
);
end entity;

architecture RTL of spPIPE is 
	signal state : fsm_state;
	signal dec_instr    : instr_isa;
	signal color_reg_en : std_logic;
	signal instr        : std_logic_vector(INSTR_LENGTH-1 downto 0);
	signal opcode       : std_logic_vector(N_opcode-1 downto 0);

begin

	instr  <= instr_word when instr_req = '1' else (others => '0');
	opcode <= instr(N_opcode-1 downto 0); 

	fetch_proc : process(clk, rst)
	begin 
		if rst = '1' then
			instr     <= (others => '0');
			instr_req <= '0';
			state <= normal;
		elsif rising_edge(clk) then
			case state is 
				when normal =>
					instr_req <= '1';

					if core_halt = '1' then
						state <= halt;
					elsif instr_valid = '1' then
						instr_o <= instr;
						case opcode is 
							when "0000" => 
								dec_instr      <= NOP;
								x1             <= (others => '0');
								y1             <= (others => '0');
								x2             <= (others => '0');
								y2             <= (others => '0');
								x3             <= (others => '0');
								y3             <= (others => '0');
								acc_enable_vec <= "000000";
							when "0001" =>
								dec_instr      <= DRAWPIXEL;
								x1             <= instr((N_pixel+N_opcode)-1 downto N_opcode);
								y1             <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
							    x2             <= (others => '0');
								y2             <= (others => '0');
								x3             <= (others => '0');
								y3             <= (others => '0');
								state 		   <= drawing;							
								acc_enable_vec <= "000001";
							when "0010" =>
								dec_instr      <= DRAWLINE;
								x1             <= instr((N_pixel+N_opcode)-1 downto N_opcode);
								y1             <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
								x2             <= instr(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
								y2             <= instr(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
								x3             <= (others => '0');
								y3             <= (others => '0');	
								state 		   <= drawing;							
								acc_enable_vec <= "000010";
							when "0011" => 
								dec_instr      <= DRAWTRIANGLE;
								x1             <= instr((N_pixel+N_opcode)-1 downto N_opcode);
								y1             <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
								x2             <= instr(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
								y2             <= instr(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
								x3             <= instr(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
								y3             <= instr(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));
								state 		   <= drawing;								
								acc_enable_vec <= "000010";
							when "0100" =>
								dec_instr      <= DRAWTRIANGLE_F;
								x1             <= instr((N_pixel+N_opcode)-1 downto N_opcode);
								y1             <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
								x2             <= instr(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
								y2             <= instr(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
								x3             <= instr(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
								y3             <= instr(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));	
								state 		   <= drawing;							
								acc_enable_vec <= "000100";
							when "0101" => 
								dec_instr      <= DRAWCIRCLE;
								x1             <= instr((N_pixel+N_opcode)-1 downto N_opcode); --Center x coord (xc)
								y1             <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode)); --Center y coord (yc)
								x2             <= instr(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode)); --Radius	(r)	
								y2             <= instr(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
								x3             <= instr(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
								y3             <= instr(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));							
								acc_enable_vec <= "010000";
							when "0110" => 
								dec_instr      <= DRAWCIRCLE_F;
								x1             <= instr((N_pixel+N_opcode)-1 downto N_opcode); --Center x coord (xc)
								y1             <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode)); --Center y coord (yc)
								x2             <= instr(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode)); --Radius	(r)	
								y2             <= instr(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
								x3             <= instr(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
								y3             <= instr(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));
								state 		   <= drawing;								
								acc_enable_vec <= "100000";
							when "0111" => 
								dec_instr      <= SETCOLOR;
								x1             <= (others => '0');
								y1             <= (others => '0');
								x2             <= (others => '0');
								y2             <= (others => '0');
								x3             <= (others => '0');
								y3             <= (others => '0');
								state 		   <= normal;	
								color          <= instr((N_color+N_opcode)-1 downto N_opcode);
								acc_enable_vec <= "000000";
							when others => 
								dec_instr      <= NOP;
								x1             <= (others => '0');
								y1             <= (others => '0');
								x2             <= (others => '0');
								y2             <= (others => '0');
								x3             <= (others => '0');
								y3             <= (others => '0');
								color  		   <= (others => '0');
								state 		   <= normal;	
								acc_enable_vec <= "000000";
						end case;
					else 
						state <= normal;
					end if;
				when drawing => 
					instr_req <= '0';
					if finish_exec = '1' then
						state <= normal;
					else
						state <= drawing;
					end if;
				when halt =>
					instr_req <= '0';
					if core_halt = '1' then
						state <= halt;
					else 
						state <= normal;
					end if;
				when others =>
					state <= normal;
				end case;
			end if;
	end process;

end RTL;


