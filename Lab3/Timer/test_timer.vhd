library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_timer is
end test_timer;

architecture test of test_timer is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal t_clk : std_logic := '1';
    signal t_start : std_logic := '0';
    signal t_data_in : std_logic_vector(9 downto 0) := "0000011001";
    signal t_minutes, t_tenSec, t_oneSec : std_logic_vector(6 downto 0);
    signal t_time_out : std_logic;

    component timer is
        port (
            I_CLK, I_START : in std_logic;
            I_DATA_IN : in std_logic_vector(9 downto 0);
            Q_MIN, Q_TEN, Q_ONE : out std_logic_vector(6 downto 0);
            Q_TIME_OUT : out std_logic
        );
    end component timer;
begin
    -- Initialise Signals 
    initialise : process
    begin
        t_start <= '0', '1' after 0.4 sec, '0' after 0.6 sec, '1' after 70 sec, '0' after 70.6 sec;
        wait;
    end process initialise;

    -- Generate Clock
    clock_gen : process
    begin
        t_clk <= not t_clk;
        wait for clk_period / 2;
    end process clock_gen;

    DUT : timer port map(
        I_CLK => t_clk,
        I_START => t_start,
        I_DATA_IN => t_data_in,
        Q_MIN => t_minutes,
        Q_TEN => t_tenSec,
        Q_ONE => t_oneSec,
        Q_TIME_OUT => t_time_out
    );

end architecture;