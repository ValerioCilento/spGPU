library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stream_tx is 
Port(
    enb_rd : out std_logic;
    data : in std_logic_vector(63 downto 0);
    valid_rx : in std_logic;
    M_AXIS_ACLK : in std_logic;
    M_AXIS_ARESETN : in std_logic;
    M_AXIS_TREADY   : in std_logic;
    M_AXIS_TDATA    : out std_logic_vector(63 downto 0);
    M_AXIS_TVALID   : out std_logic;
    addr : out std_logic_vector(12 downto 0)
);
end stream_tx;

architecture RTL of stream_tx is 
    signal state, next_state : integer;
    signal data_int : std_logic_vector(63 downto 0);
    signal addr_int : std_logic_vector(12 downto 0);


begin

    process(state, M_AXIS_TREADY, M_AXIS_ARESETN)
    begin
        if M_AXIS_ARESETN = '0' then
            next_state <= 0;
        else 
            case state is 
                when 0 => --State in wich it prepares the TDATA, being reaad synchronous
                    next_state <= 1;
                when 1 =>  
                    if valid_rx = '1' then 
                        next_state <= 2;
                    else 
                        next_state <= 1;
                    end if;
                when 2 => 
                    next_state <= 0;
                when others => 
                    next_state <= 0;
            end case;
        end if;
    end process;

    process(M_AXIS_ACLK, M_AXIS_ARESETN)
    begin
        if M_AXIS_ARESETN = '0' then
            state <= 0;
        elsif rising_edge(M_AXIS_ACLK) then
            state <= next_state;
        end if;
    end process;

    process(M_AXIS_ACLK, M_AXIS_ARESETN)
    begin 
        if M_AXIS_ARESETN = '0' then
            addr_int <= (others => '0');
            data_int <= (others => '0');
        elsif rising_edge(M_AXIS_ACLK) then
            case state is 
                when 0 => 
                    enb_rd <= '1';
                    M_AXIS_TVALID <= '0';
                when 1 => 
                    enb_rd <= '0';
                    data_int <= data;
                    M_AXIS_TVALID <= '1';
                when 2 =>
                    addr_int  <= std_logic_vector(unsigned(addr_int) + 1);
                    M_AXIS_TVALID <= '0';
                when others =>
                    M_AXIS_TVALID <= '0';
                    addr_int <= (others => '0');
                    enb_rd <= '0';
            end case;
        end if;
    end process;

    addr <= addr_int;
    M_AXIS_TDATA <= data_int;
end RTL;