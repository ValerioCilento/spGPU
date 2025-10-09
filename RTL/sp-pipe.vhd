library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;


entity spPIPE is 
generic(
	INSTR_LENGTH : integer   := 64; --Number of bits of the instruction
	N_opcode : integer       := 4;
	N_color : integer        := 24; --Number of bits of color vector
	N_pixel : integer        := 8; --Number of bits of every coordinate
	N_Accelerators : integer := 6 --Number of accelerators in the Execution Unit
);
port(
	clk, rst 				: in std_logic;
	instr_valid 			: in std_logic;
	instr_word      		: in std_logic_vector(INSTR_LENGTH-1 downto 0);
	busy_exec	    		: in std_logic;
	core_halt               : in std_logic;
	instr_req   			: out std_logic;
	--x1, y1, x2, y2, x3, y3  : out std_logic_vector(N_pixel-1 downto 0);
	dec_instr_o             : out instr_isa;
	instr_o                 : out std_logic_vector(INSTR_LENGTH-1 downto 0)
);
end entity;

architecture RTL of spPIPE is 

	type instr_isa is (DRAWPIXEL, DRAWLINE, DRAWTRIANGLE, DRAWTRIANGLE_F NOP, DRAWCIRCLE, DRAWCIRCLE_F, SETCOLOR);
	signal dec_instr : instr_isa;
	signal instr     : std_logic_vector(INSTR_LENGTH-1 downto 0);
	signal opcode    : std_logic_vector(N_opcode-1 downto 0);

begin
	instr  <= instr_word when instr_req = '1' else (others => '0');
	opcode <= instr(N_opcode-1 downto 0); 

	fetch_proc : process(core_halt, busy_exec, rst)
	begin 
		if rst = '1' then
			instr     <= (others => '0');
			instr_req <= '0';
		else 
			if core_halt = '0' and busy_exec = '0' then
				instr_req <= '1';
			else 
				instr_req <= '0';
			end if;
		end if;
	end process;

	decode_proc : process(opcode, instr_valid)
	begin 
		if instr_valid = '1' then
			instr_o <= instr;
			case opcode is 
				when "0000" => 
					dec_instr <= NOP;
				when "0001" =>
					dec_instr <= DRAWPIXEL;
				when "0010" =>
					dec_instr <= DRAWLINE;
				when "0011" => 
					dec_instr <= DRAWTRIANGLE;
				when "0100" =>
					dec_instr <= DRAWTRIANGLE_F;
				when "0101" => 
					dec_instr <= DRAWCIRCLE;
				when "0110" => 
					dec_instr <= DRAWCIRCLE_F;
				when "0111" => 
					dec_instr <= SETCOLOR;
				when others => 
					dec_instr <= NOP;
			end case;
		else 
			instr_o   <= (others => '0');
			dec_instr <= NOP;
		end if;
	end process;
end RTL;


