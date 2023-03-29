library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_bcd_counter is
end test_bcd_counter;

architecture test of test_bcd_counter is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal direction : std_logic;
    signal init : std_logic;
    signal enable : std_logic;
    signal Q : std_logic_vector(3 downto 0);

    component bcd_counter is
        port (
            clk : in std_logic;
            direction : in std_logic;
            init : in std_logic;
            enable : in std_logic;
            Q : out std_logic_vector(3 downto 0)
        );
    end component bcd_counter;
begin
    -- Initialise Signals 
    initialise : process
    begin
        init <= '0', '1' after 2 ns, '0' after 7 ns,
            '1' after 720 ns, '0' after 730 ns;
        enable <= '1', '0' after 255 ns, '1' after 610 ns;
        direction <= '0', '1' after 300 ns, '0' after 600 ns, '1' after 900 ns;
        wait;
    end process initialise;

    -- Generate Clock
    clock_gen : process
    begin
        clk <= not clk;
        wait for clk_period / 2;
    end process clock_gen;

    DUT : bcd_counter port map(
        clk => clk,
        direction => direction,
        init => init,
        enable => enable,
        Q => Q
    );

end architecture;