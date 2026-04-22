library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spScheduler is
generic(
	INSTR_LENGTH   : integer := 64; --#Istruction bits
	FIFO_DEPTH     : integer := 12; --#Fifo available instruction locations
	INSTR_LENGTH   : integer := 64; --#Istruction bits
	N_cores        : integer := 10; --#Cores/Tiles
	N_pixel        : integer := 8;  --#Pixel coordinates bits
	N_opcode       : integer := 8   --#Opcode bits
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
end entity spScheduler;

architecture RTL of spScheduler is

	type sch_instr is array(0 to N_cores) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	signal fifo_empty_wire  : std_logic;
	signal fifo_full_wire   : std_logic;
	signal instr_req_sc_int : std_logic; 
	signal opcode           : std_logic_vector(N_opcode-1 downto 0);
	signal scheduled_instr  : sch_instr;
	signal x1, y1, x2, y2, x3, y3  : std_logic_vector(N_pixel-1 downto 0);
	signal xb_1, yb_1, xb_2, yb_2, xb_3, yb_3, xb_4, yb_4  : std_logic_vector(N_pixel-1 downto 0);
	signal state : sch_fsm;
	--signal instr_valid_axi_wire : std_logic;
	--signal instr_word_axi_wire  : std_logic_vector(INSTR_LENGTH-1 downto 0);
	--signal instr_req_core_wire  : std_logic;
	--signal fifo_out_core_wire   : std_logic_vector(INSTR_LENGTH-1 downto 0);
	--signal fifo_valid_core_wire : std_logic;

	function max_val(a, b : unsigned) return unsigned is
	begin
    	if a > b then return a; else return b; end if;
	end function;

	function min_val(a, b : unsigned) return unsigned is
	begin
    	if a < b then return a; else return b; end if;
	end function;

	component sc_fifo is
		generic(
			INSTR_LENGTH : integer;
			FIFO_DEPTH : integer
		);
		port(
			clk, rst     : in std_logic;
			fifo_wr_en   : in std_logic;
			fifo_wr_data : in std_logic_vector(INSTR_LENGTH-1 downto 0);
			fifo_rd_en   : in std_logic;
			fifo_rd_data : out std_logic_vector(INSTR_LENGTH-1 downto 0);
			fifo_valid   : out std_logic;
			fifo_empty   : out std_logic;
			fifo_full    : out std_logic	
		);
	end component;

begin

	opcode <= instr_word_axi(N_opcode-1 downto 0);

	x1 <= instr((N_pixel+N_opcode)-1 downto N_opcode);
	y1 <= instr(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
	x2 <= instr(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode));
	y2 <= instr(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
	x3 <= instr(((5*N_pixel)+N_opcode)-1 downto ((4*N_pixel)+N_opcode));
	y3 <= instr(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));
	
	instr_req_sc <= instr_req_sc_int;
	
	FIFO : sc_fifo
	generic map(
		INSTR_LENGTH => INSTR_LENGTH,
		FIFO_DEPTH   => FIFO_DEPTH
	)
	port map(
		clk          => clk,
		rst          => rst,
		fifo_wr_en   => instr_valid_axi,
		fifo_wr_data => instr_word_axi,
		fifo_rd_en   => instr_req_core,
		fifo_rd_data => fifo_out_core,
		fifo_valid   => fifo_valid_core,
		fifo_empty   => fifo_empty_wire,
		fifo_full    => fifo_full_wire
	);

	sch_fsm : process(clk, rst)
	begin
		if rst = '0' then
			instr_req_sc_int <= '0';
			state <= request;
		elsif rising_edge(clk) then
			case state is
				when request =>
					if fifo_full_wire = '1' then
						instr_req_sc_int <= '0';
						state <= request;
					elsif instr_valid_axi = '1' then
						instr_req_sc_int <= '0';
						state <= bbox;
					else 
						instr_req_sc_int <= '1';
						state <= request;
					end if;
				when bbox =>
					case opcode is 
						when "0001" => -- DRAWPIXEL
							xb_1 <= x1;
							yb_1 <= y1;

							xb_2 <= (others => '0');
							yb_2 <= (others => '0');

							xb_3 <= (others => '0');
							yb_3 <= (others => '0');

							xb_4 <= (others => '0');
							yb_4 <= (others => '0');					 
						when "0010" => -- DRAWLINE
							xb_1 <= x1;
							yb_1 <= y1;

							xb_2 <= std_logic_vector(max_val(unsigned(x1), unsigned(x2))); ---- (max_x ; max_y)
							yb_2 <= std_logic_vector(max_val(unsigned(y1), unsigned(y2))); --

							xb_3 <= x2;
							yb_3 <= y2;

							xb_4 <= std_logic_vector(min_val(unsigned(x1), unsigned(x2))); ---- (min_x ; min_y)
							yb_4 <= std_logic_vector(min_val(unsigned(y1), unsigned(y2))); --
						when "0011" => -- DRAWTRIANGLE
							xb_1 <= std_logic_vector(max_val(max_val(unsigned(x1), unsigned(x2)), unsigned(x3))); ---- (max_x ; max_y)
							yb_1 <= std_logic_vector(max_val(max_val(unsigned(y1), unsigned(y2)), unsigned(y3))); --

							xb_2 <= std_logic_vector(max_val(max_val(unsigned(x1), unsigned(x2)), unsigned(x3))); ---- (max_x ; min_y)
							yb_2 <= std_logic_vector(min_val(min_val(unsigned(y1), unsigned(y2)), unsigned(y3))); --

							xb_3 <= std_logic_vector(min_val(min_val(unsigned(x1), unsigned(x2)), unsigned(x3))); ---- (min_x ; max_y)
							yb_3 <= std_logic_vector(max_val(max_val(unsigned(y1), unsigned(y2)), unsigned(y3))); --

							xb_4 <= std_logic_vector(min_val(min_val(unsigned(x1), unsigned(x2)), unsigned(x3))); ---- (min_x ; min_y)
							yb_4 <= std_logic_vector(min_val(min_val(unsigned(y1), unsigned(y2)), unsigned(y3))); --
						when "0101" | "0110" => -- DRAWCIRCLE/DRAWCIRCLE_F
							xb_1 <= std_logic_vector(unsigned(x1) + unsigned(x2)); ---- (xc + r ; yc + r)
							yb_1 <= std_logic_vector(unsigned(y1) + unsigned(x2)); --

							xb_2 <= std_logic_vector(unsigned(x1) + unsigned(x2)); ---- (xc + r ; yc - r)
							yb_2 <= std_logic_vector(unsigned(y1) - unsigned(x2)); --

							xb_3 <= std_logic_vector(unsigned(x1) - unsigned(x2)); ---- (xc - r ; yc + r)
							yb_3 <= std_logic_vector(unsigned(y1) + unsigned(x2)); --

							xb_4 <= std_logic_vector(unsigned(x1) - unsigned(x2)); ---- (xc - r ; yc - r)
							yb_4 <= std_logic_vector(unsigned(y1) - unsigned(x2)); --
						when others => NULL;
					end case;
					state <= schedule;
				when schedule =>
					case opcode is 
						when "0000" | "0111" | "1000" => -- NOP/SETCOLOR/SWAP
							for i in 0 to N_cores loop
								scheduled_instr(i) <= instr_word_axi;
							end loop;
						when "0001" => -- DRAWPIXEL					 
						when "0010" => -- DRAWLINE
						when "0011" => -- DRAWTRIANGLE
						when "0101" | "0110" => -- DRAWCIRCLE/DRAWCIRCLE_F
						when others => NULL;
					end case;
		    end case;
		end if;
	end process sch_fsm;

end architecture RTL;