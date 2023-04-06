library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_game is
end test_game;

architecture sim of test_game is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal L_CLK : std_logic := '1';
    signal L_LED : std_logic_vector(2 downto 0);
    signal L_RED : std_logic;
    signal L_GREEN : std_logic;
    signal L_BLUE : std_logic;
    signal L_H_SYNC : std_logic;
    signal L_V_SYNC : std_logic;
begin
    DUT : entity work.game
        port map(
            I_CLK => L_CLK,
            I_SWITCH => "111",

            Q_LED => L_LED,
            Q_RED => L_RED,
            Q_GREEN => L_GREEN,
            Q_BLUE => L_BLUE,
            Q_H_SYNC => L_H_SYNC,
            Q_V_SYNC => L_V_SYNC
        );

    L_CLK <= not L_CLK after clk_period / 2;
end architecture;