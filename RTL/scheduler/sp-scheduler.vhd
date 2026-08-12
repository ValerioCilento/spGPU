library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.spPKG.all;

entity spScheduler is
generic(
	INSTR_LENGTH   : integer := 64; --#Istruction bits
	FIFO_DEPTH     : integer := 12; --#Fifo available instruction locations
	N_cores        : integer := 10; --#Cores/Tiles
	N_pixel        : integer := 9;  --#Pixel coordinates bits
	N_opcode       : integer := 8;   --#Opcode bits
	VIDEO_X        : integer := 320;
    VIDEO_Y        : integer := 240
);
port(
	clk, rst        : in std_logic;
	core_halt       : in std_logic;
	instr_word_axi  : in std_logic_vector(INSTR_LENGTH-1 downto 0);
	instr_req_core  : in std_logic_vector(N_cores-1 downto 0);
	instr_valid_axi : in std_logic;
	fifo_out_core   : out sch_instr;
	empty_pin       : out std_logic_vector(N_cores-1 downto 0);
	full_pin        : out std_logic_vector(N_cores-1 downto 0);
	fifo_valid_core : out std_logic_vector(N_cores-1 downto 0);
	instr_req_sc    : out std_logic
);
end entity spScheduler;

architecture RTL of spScheduler is

	--type sch_instr is array(0 to N_cores-1) of std_logic_vector(INSTR_LENGTH-1 downto 0);
	signal sch_instr_vector  : sch_instr;
	signal state             : sch_state;
	signal opcode            : std_logic_vector(N_opcode-1 downto 0);
	signal y1, y2, y3, r     : std_logic_vector(N_pixel-1 downto 0);
	signal y_max, y_min      : std_logic_vector(N_pixel-1 downto 0);
	signal fifo_empty_vector : std_logic_vector(N_cores-1 downto 0);
	signal fifo_full_vector  : std_logic_vector(N_cores-1 downto 0);
	signal fifo_we_vector    : std_logic_vector(N_cores-1 downto 0);
	signal fifo_valid_vector : std_logic_vector(N_cores-1 downto 0);

	--signal fifo_full_wire : std_logic;
	--signal instr_req_sc_int : std_logic; 

	--function max_val(a, b : unsigned) return unsigned is
	--begin
    	--if a > b then return a; else return b; end if;
	--end function;

	--function min_val(a, b : unsigned) return unsigned is
	--begin
    	--if a < b then return a; else return b; end if;
	--end function;

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

    empty_pin <= fifo_empty_vector;
    full_pin <= fifo_full_vector;
    
	fifo_valid_core <= fifo_valid_vector;
	opcode <= instr_word_axi(N_opcode-1 downto 0);

	y1 <= instr_word_axi(((2*N_pixel)+N_opcode)-1 downto (N_pixel+N_opcode));
	y2 <= instr_word_axi(((4*N_pixel)+N_opcode)-1 downto ((3*N_pixel)+N_opcode));
	y3 <= instr_word_axi(((6*N_pixel)+N_opcode)-1 downto ((5*N_pixel)+N_opcode));
	r  <= instr_word_axi(((3*N_pixel)+N_opcode)-1 downto ((2*N_pixel)+N_opcode)); --Radius	(r)
	
	--instr_req_sc <= instr_req_sc_int;
	--fifo_full_wire <= or fifo_full_vector;
    
	instr_req_sc <= '1' when (state = request and unsigned(fifo_full_vector) = 0) else '0';
	
	GEN_FIFO: for i in 0 to N_cores-1 generate
		FIFO : sc_fifo
		generic map(
			INSTR_LENGTH => INSTR_LENGTH,
			FIFO_DEPTH   => FIFO_DEPTH
		)
		port map(
			clk          => clk,
			rst          => rst,
			fifo_wr_en   => fifo_we_vector(i),
			fifo_wr_data => sch_instr_vector(i),
			fifo_rd_en   => instr_req_core(i),
			fifo_rd_data => fifo_out_core(i),
			fifo_valid   => fifo_valid_vector(i),
			fifo_empty   => fifo_empty_vector(i),
			fifo_full    => fifo_full_vector(i)
		);
	end generate GEN_FIFO;

	pre_decode : process(opcode, y1, y2, y3, r)
	begin

	    case opcode is
	        when "0001" => -- DRAWPIXEL
	            y_max <= y1;
	            y_min <= y1;

	        when "0010" => -- DRAWLINE
	            y_max <= std_logic_vector(max_val(unsigned(y1), unsigned(y2)));
	            y_min <= std_logic_vector(min_val(unsigned(y1), unsigned(y2)));

	        when "0011" => -- DRAWTRIANGLE
	            y_max <= std_logic_vector(max_val(max_val(unsigned(y1), unsigned(y2)), unsigned(y3)));
	            y_min <= std_logic_vector(min_val(min_val(unsigned(y1), unsigned(y2)), unsigned(y3)));

	        when "0101" | "0110" => -- DRAWCIRCLE
	        	if unsigned(y1) > (VIDEO_Y - unsigned(r)) then
	        		y_max <= std_logic_vector(to_unsigned(VIDEO_Y, N_pixel) - 1);
	        	else
	            	y_max <= std_logic_vector(unsigned(y1) + unsigned(r));
	            end if;

	            if unsigned(y1) < unsigned(r) then
	                y_min <= (others => '0');
	            else
	                y_min <= std_logic_vector(unsigned(y1) - unsigned(r));
	            end if;

	        when others =>
	            y_max <= (others => '0');
	            y_min <= (others => '0');
	    end case;
	end process pre_decode;

	sch_fsm : process(clk, rst)
	variable v_core_start, v_core_end : integer range 0 to N_cores-1;
	begin
		if rst = '1' then
			--instr_req_sc_int <= '0';
			for i in 0 to N_cores-1 loop
				sch_instr_vector(i) <= (others => '0');
			end loop;
			fifo_we_vector <= (others => '0');
			state <= request;
		elsif rising_edge(clk) then
			case state is
				when request =>

					if unsigned(fifo_full_vector) /= 0 then
						--instr_req_sc_int <= '0';
						state <= request;
					elsif instr_valid_axi = '1' then
						--instr_req_sc_int <= '0';
						state <= schedule;
					else 
						--instr_req_sc_int <= '1';
						state <= request;
					end if;

					fifo_we_vector <= (others => '0');

				when schedule =>

	                v_core_start := 0;
	                v_core_end   := 0;

				    for i in 0 to N_cores-1 loop
				        if unsigned(y_min) >= Y_TILE_START(i) then 
				            v_core_start := i; 
				        end if;
				        if unsigned(y_max) >= Y_TILE_START(i) then 
				            v_core_end := i; 
				        end if;
				    end loop;

	                case opcode is 
	                    when "0000" | "0111" | "1000" => 
	                        for i in 0 to N_cores-1 loop
	                            sch_instr_vector(i) <= instr_word_axi;
	                            fifo_we_vector(i)  <= '1';
	                        end loop;

	                    when "0001" | "0010" | "0011" | "0101" | "0110" =>
	                        for i in 0 to N_cores-1 loop
	                            if i >= v_core_start and i <= v_core_end then
	                                sch_instr_vector(i) <= instr_word_axi;
	                                fifo_we_vector(i)  <= '1';
	                            else 
	                            	sch_instr_vector(i) <= (others => '0');
	                            	fifo_we_vector(i)  <= '0';
	                            end if;
	                        end loop;
	                    when others => NULL;
	                end case;
	                state <= request;
	            when others => NULL;
		    end case;
		end if;
	end process sch_fsm;
end architecture RTL;