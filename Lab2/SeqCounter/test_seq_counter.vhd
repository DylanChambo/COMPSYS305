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
        rst <= '0', '1' after 2 ns, '0' after 7 ns;
        enable <= '1', '1' after 255 ns, '1' after 610 ns;
        mode <= "00", "01" after 300 ns, "10" after 600 ns, "11" after 900 ns;
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