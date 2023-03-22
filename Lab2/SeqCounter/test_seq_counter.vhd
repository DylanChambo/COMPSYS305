library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_seq_counter is
end test_seq_counter;

architecture test of test_seq_counter is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic;
    signal enable : std_logic;
    signal mode : std_logic_vector(1 downto 0);
    signal Q : std_logic_vector(4 downto 0);

    component seq_counter is
        port (
            clk : in std_logic;
            rst : in std_logic;
            enable : in std_logic;
            mode : in std_logic_vector(1 downto 0);
            Q : out std_logic_vector(4 downto 0)
        );
    end component seq_counter;
begin
    -- Initialise Signals 
    init : process
    begin
        rst <= '0', '1' after 2 ns, '0' after 7 ns,
            '1' after 450 ns, '0' after 460 ns,
            '1' after 750 ns, '0' after 760 ns,
            '1' after 1650 ns, '0' after 1660 ns,
            '1' after 2250 ns, '0' after 2260 ns;
        enable <= '1', '0' after 300 ns, '1' after 400 ns,
            '0' after 900 ns, '1' after 1000 ns,
            '0' after 1500 ns, '1' after 1600 ns,
            '0' after 2100 ns, '1' after 2200 ns;
        mode <= "00", "01" after 600 ns, "10" after 1200 ns, "11" after 1800 ns;
        wait;
    end process init;

    -- Generate Clock
    clock_gen : process
    begin
        clk <= not clk;
        wait for clk_period / 2;
    end process clock_gen;

    DUT : seq_counter port map(
        clk => clk,
        rst => rst,
        mode => mode,
        enable => enable,
        Q => Q
    );

end architecture;