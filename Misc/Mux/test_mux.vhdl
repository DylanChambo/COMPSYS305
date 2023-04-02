library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_mux is
end test_mux;

architecture test of test_mux is

    constant DataWidth : integer := 8;

    signal L_SEL : unsigned(1 downto 0) := (others => '0');

    signal L_SIG1 : unsigned(DataWidth - 1 downto 0) := x"AA";
    signal L_SIG2 : unsigned(DataWidth - 1 downto 0) := x"BB";
    signal L_SIG3 : unsigned(DataWidth - 1 downto 0) := x"CC";
    signal L_SIG4 : unsigned(DataWidth - 1 downto 0) := x"DD";

    signal D_SIG : unsigned(DataWidth - 1 downto 0);
begin
    DUT : entity work.mux(rtl)
        generic map(DataWidth => DataWidth)
        port map(
            I_SEL => L_SEL,
            I_SIG1 => L_SIG1,
            I_SIG2 => L_SIG2,
            I_SIG3 => L_SIG3,
            I_SIG4 => L_SIG4,
            Q_SIG => D_SIG
        );

    sel : process is
    begin
        wait for 10 ns;
        L_SEL <= L_SEL + 1;
    end process;
end architecture;