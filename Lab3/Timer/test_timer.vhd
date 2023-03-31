library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_timer is
end test_timer;

architecture test of test_timer is

    constant clk_hz : integer := 1;
    constant clk_period : time := 1 sec / clk_hz;

    signal t_clk : std_logic := '1';
    signal t_start : std_logic := '0';
    signal t_data_in : std_logic_vector(9 downto 0) := "0000011001";
    signal t_minutes, t_tenSec, t_oneSec : std_logic_vector(6 downto 0);
    signal t_time_out : std_logic;

    component timer is
        port (
            clk, start : in std_logic;
            data_in : in std_logic_vector(9 downto 0);
            minutes_Dig, tenSec_Dig, oneSec_Dig : out std_logic_vector(6 downto 0);
            time_out : out std_logic
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
        clk => t_clk,
        start => t_start,
        data_in => t_data_in,
        minutes_Dig => t_minutes,
        tenSec_Dig => t_tenSec,
        oneSec_Dig => t_oneSec,
        time_out => t_time_out
    );

end architecture;