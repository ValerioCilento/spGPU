library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myaxistream_v1_0_S_AXIS is
	generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
	    ready_enb : in std_logic;
	    led : out std_logic;
	    data_o : out std_logic_vector(2 downto 0);
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TVALID	: in std_logic
	);
end myaxistream_v1_0_S_AXIS;

architecture arch_imp of myaxistream_v1_0_S_AXIS is
    component test_design is
    Port (
        data_i : in std_logic_vector(31 downto 0);
        S_AXIS_ACLK : in std_logic;
        S_AXIS_ARESETN : in std_logic;
        led : out std_logic;
        data_o : out std_logic_vector(2 downto 0)
     );
     end component;
    type FSM is (WAIT_S, TX1_S, TX2_S);
    signal state_t, next_state_t : FSM;
    signal tready : std_logic;
begin 
    S_AXIS_TREADY <= tready;
    process(all) 
    begin
        if S_AXIS_ARESETN = '0' then
            next_state_t <= WAIT_S;
        else 
            case state_t is
                when WAIT_S => 
                     if ready_enb = '1' then
                        next_state_t <= TX1_S;
                     else 
                        next_state_t <= WAIT_S;
                     end if;
                when TX1_S =>
                     if S_AXIS_TVALID = '1' then
                        next_state_t <= TX2_S;
                     else 
                        next_state_t <= TX1_S;
                     end if;
               when TX2_S =>
                    next_state_t <= WAIT_S;
               when others => 
                    next_state_t <= WAIT_S;        
            end case;
        end if;        
    end process;
    
    process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                state_t <= WAIT_S;
            else 
                state_t <= next_state_t;
           end if;
        end if;
    end process;
    
    process(S_AXIS_ACLK) 
    begin
           if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                tready <= '0';
            else 
                case state_t is
                    when WAIT_S =>
                        tready <= '0';
                    when TX1_S =>
                        tready <= '1';
                    when TX2_S => 
                        tready <= '0';
                    when others => 
                        tready <= '0';
                end case;
           end if;
        end if;
    end process;
    
    U1 : test_design port map(
        S_AXIS_ACLK => S_AXIS_ACLK,
        led => led, 
        S_AXIS_ARESETN => S_AXIS_ARESETN,
        data_i => S_AXIS_TDATA,
        data_o => data_o
    );
end arch_imp;
