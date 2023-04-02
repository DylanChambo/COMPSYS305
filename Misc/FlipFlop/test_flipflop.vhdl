library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_flipflop is
end test_flipflop;

architecture test of test_flipflop is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal L_CLK : std_logic := '1';
    signal L_RST : std_logic := '0';
    signal L_IN : std_logic := '0';

    signal D_OUT : std_logic;
begin
    DUT : entity work.flipflop(rtl)
        port map(
            I_CLK => L_CLK,
            I_RST => L_RST,
            I_IN => L_IN,
            Q_OUt => D_OUT
        );

    process
    begin
        L_RST <= '1';
        wait for 20 ns;
        L_IN <= '1';
        wait for 22 ns;
        L_IN <= '0';
        wait for 6 ns;
        L_IN <= '1';
        wait for 20 ns;

        L_RST <= '0';

        wait;
    end process;

    L_CLK <= not L_CLK after clk_period / 2;
end architecture;