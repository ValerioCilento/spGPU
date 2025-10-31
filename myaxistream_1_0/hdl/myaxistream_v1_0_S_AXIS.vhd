library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myaxistream_v1_0_S_AXIS is
    generic (
        C_S_AXIS_TDATA_WIDTH    : integer   := 64
    );
    port (
        ready_enb : in std_logic;
        instr_valid : out std_logic;
        instr_word : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        S_AXIS_ACLK : in std_logic;
        S_AXIS_ARESETN  : in std_logic;
        S_AXIS_TREADY   : out std_logic;
        S_AXIS_TDATA    : in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        S_AXIS_TVALID   : in std_logic
    );
end myaxistream_v1_0_S_AXIS;

architecture arch_imp of myaxistream_v1_0_S_AXIS is

    type FSM is (WAIT_S, TX1_S, TX2_S);
    signal state_t, next_state_t : FSM;
    signal tready : std_logic;
    signal fsm_start_edge, fsm_start_prev : std_logic;

begin 
    -- Processo per rilevamento fronte di salita di fsm_start
    process(S_AXIS_ACLK, S_AXIS_ARESETN)
    begin
        if S_AXIS_ARESETN = '0' then
            fsm_start_prev  <= '0';
            fsm_start_edge  <= '0';
        elsif rising_edge(S_AXIS_ACLK) then
            fsm_start_edge <= '1' when (ready_enb = '1' and fsm_start_prev = '0') else '0';
            fsm_start_prev <= ready_enb;
        end if;
    end process;

    S_AXIS_TREADY <= tready;
    process(all) 
    begin
        if S_AXIS_ARESETN = '0' then
            next_state_t <= WAIT_S;
        else 
            case state_t is
                when WAIT_S => 
                     if fsm_start_edge = '1' then
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
                    instr_valid <= '0';
                    instr_word <= (others => '0');
                else 
                    case state_t is
                        when WAIT_S =>
                            tready <= '0';
                            instr_valid <= '0';
                        when TX1_S =>
                            tready <= '1';
                            instr_valid <= '1';
                        when TX2_S => 
                            instr_word <= S_AXIS_TDATA;
                            instr_valid <= '0';
                            tready <= '0';
                        when others => 
                            tready <= '0';
                            instr_valid <= '0';
                    end case;
               end if;
        end if;
    end process;
   
end arch_imp;
