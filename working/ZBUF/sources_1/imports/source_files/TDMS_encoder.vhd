


--	9 cycle latency TDMS encoder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TMDS_encoder is
	Port(
	
		clock, reset, enable: in std_logic;
		control: in std_logic_vector(1 downto 0);
	
		din: in std_logic_vector(7 downto 0);	
		dout: out std_logic_vector(9 downto 0)
);
end TMDS_encoder;

architecture encoder of TMDS_encoder is

	-----	encoding pipeline -----
	type encoding_type is array (7 downto 0) of std_logic_vector(8 downto 0);
	signal q_m_xor		:	encoding_type;
	signal q_m_xnor	:	encoding_type;
	signal en			:	std_logic_vector(7 downto 0);		-- propagated enable signal
	type ctrl_type is array (7 downto 0) of std_logic_vector(1 downto 0);	-- propagated control signal
	signal ctrl			:	ctrl_type;
	
	type sum_type is array (7 downto 0) of integer;
	signal N_1, N_0				: sum_type;		-- sums of 1s and 0s of input data
	signal N_1_xor, N_0_xor		: sum_type;		-- sums of 1s and 0s of xor encoded data
	signal N_1_xnor, N_0_xnor	: sum_type;		-- sums of 1s and 0s of xnor encoded data
	
	----- second phase ----
	signal q_m						:	std_logic_vector(8 downto 0); 
	signal q_m_delayed			:	std_logic_vector(8 downto 0);	-- just to delay it for 1 cycle to let the calculations finish (N_1_xor, ...)
	signal final_enable			: std_logic;
	signal final_enable_delayed	: std_logic;
	signal N_1_final, N_0_final	:	integer;
	signal ctrl_final					:	std_logic_vector(1 downto 0);
	signal ctrl_final_delayed		:	std_logic_vector(1 downto 0);
	
	-----	final stage -----
	signal Cnt:	signed(7 downto 0);
	
begin

	------ encoding pipeline ------
	encoding:	process(clock, reset)
	begin
		if reset = '1' then
			q_m_xor	<=	(others => (others => '0'));
			q_m_xnor	<=	(others => (others => '0'));
			N_1		<=	(others => 0);
			N_0		<=	(others => 0);
			en			<=	(others => '0');
			
		elsif rising_edge(clock) then
			q_m_xor(0)(8 downto 0)	<=	'1' & din;
			q_m_xnor(0)(8 downto 0)	<=	'0' & din;
			en(0)		<=	enable;
			ctrl(0)	<=	control;
			
			if din(0) = '1' then
				N_1(0)	<=	1;
				N_0(0)	<= 0;
			else
				N_1(0)	<=	0;
				N_0(0)	<=	1;
			end if;
			
			for i in 1 to 7 loop
				--	encodings
				q_m_xor(i)	<=	q_m_xor(i-1);
				q_m_xnor(i)	<=	q_m_xnor(i-1);
				q_m_xor(i)(i)	<=	q_m_xor(i-1)(i-1) xor q_m_xor(i-1)(i);
				q_m_xnor(i)(i)	<=	q_m_xnor(i-1)(i-1) xnor q_m_xnor(i-1)(i);
				q_m_xor(i)(8)	<=	'1';
				q_m_xnor(i)(8)	<=	'0';
				
				--	1s and 0s of input data
				if q_m_xor(i-1)(i) = '1' then
					N_1(i)	<=	N_1(i-1) + 1;
					N_0(i)	<=	N_0(i-1);
				else
					N_1(i)	<=	N_1(i-1);
					N_0(i)	<=	N_0(i-1) + 1;
				end if;
				
				--	1s and 0s of xor encoded data
				if q_m_xor(0)(0) = '1' then
					N_1_xor(0)	<=	1;
					N_0_xor(0)	<=	0;
				else
					N_1_xor(0)	<=	0;
					N_0_xor(0)	<=	1;
				end if;
				
				if q_m_xor(i)(i) = '1' then
					N_1_xor(i)	<=	N_1_xor(i-1) + 1;
					N_0_xor(i)	<=	N_0_xor(i-1);
				else
					N_1_xor(i)	<=	N_1_xor(i-1);
					N_0_xor(i)	<=	N_0_xor(i-1) + 1;
				end if;

				--	1s and 0s of xnor encoded data
				if q_m_xnor(0)(0) = '1' then
					N_1_xnor(0)	<=	1;
					N_0_xnor(0)	<=	0;
				else
					N_1_xnor(0)	<=	0;
					N_0_xnor(0)	<=	1;
				end if;
				
				if q_m_xnor(i)(i) = '1' then
					N_1_xnor(i)	<=	N_1_xnor(i-1) + 1;
					N_0_xnor(i)	<=	N_0_xnor(i-1);
				else
					N_1_xnor(i)	<=	N_1_xnor(i-1);
					N_0_xnor(i)	<=	N_0_xnor(i-1) + 1;
				end if;

				-- enable & control
				en(i)		<=	en(i-1);
				ctrl(i)	<=	ctrl(i-1);
			end loop;
		end if;
	end process;
	
	q_m_decision:	process(clock, reset)
	begin
		if reset = '1' then
			q_m	<=	(others => '0');
			final_enable <= '0';
			
		elsif rising_edge(clock) then
			if ((N_1(7) > 4) or ((N_1(7) = 4) and (q_m_xor(7)(0) = '0'))) then
				q_m_delayed 			<= q_m_xnor(7);
				N_1_final	<=	N_1_xnor(7);
				N_0_final	<=	N_0_xnor(7);
			else
				q_m_delayed 			<= q_m_xor(7);
				N_1_final	<=	N_1_xor(7);
				N_0_final	<=	N_0_xor(7);
			end if;
			
			q_m				<=	q_m_delayed;
			final_enable 	<= final_enable_delayed;
			ctrl_final		<=	ctrl_final_delayed;

			final_enable_delayed 	<= en(7);
			ctrl_final_delayed		<=	ctrl(7);
		end if;
	end process;

	final_stage:	process(clock, reset)
		variable diff: signed(7 downto 0);
	begin
		diff:= to_signed(N_1_final - N_0_final, 8);
		if reset = '1' then
			Cnt 	<= "00000000";
			dout	<=	"0000000000";
			
		elsif rising_edge(clock) then
			if final_enable = '0' then
				case ctrl_final is
					when "00" => 
						dout <= "1101010100";
					when "01" => 
						dout <= "0010101011";
					when "10" => 
						dout <= "0101010100";
					when others => 
						dout <= "1010101011";
				end case;
				
				Cnt <= (others => '0');
				
			elsif (Cnt = 0 or diff = 0) then
			
				dout(9)	<=	not q_m(8);
				dout(8)	<=	q_m(8);
				
				if q_m(8) = '0' then
					dout(7 downto 0)	<=	 not q_m(7 downto 0);
					Cnt <= Cnt - diff;
				else
					dout(7 downto 0)	<=	q_m(7 downto 0);
					Cnt <= Cnt + diff;
				end if;
				
			elsif ((Cnt > 0 and diff > 0) or (Cnt < 0 and diff < 0)) then
				dout	<=	'1' & q_m(8) & not q_m(7 downto 0);
				if q_m(8) = '1' then
					Cnt <= Cnt + 2 - diff;
				else
					Cnt <= Cnt - diff;
				end if;
				
			else 
				dout <= '0' & q_m(8 downto 0);
				if q_m(8) = '1' then
					Cnt <= Cnt + diff;
				else
					Cnt <= Cnt - 2 + diff;
				end if;
				
			end if;
		end if;
	end process;

end encoder;




