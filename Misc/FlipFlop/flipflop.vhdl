library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflop is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic; -- Negative Reset
        I_IN : in std_logic;
        Q_OUT : out std_logic
    );
end flipflop;

architecture rtl of flipflop is
begin
    process (I_CLK) is
    begin
        if rising_edge (I_CLK) then
            if I_RST = '0' then
                Q_OUT <= '0';
            else
                Q_OUT <= I_IN;
            end if;
        end if;
    end process;
end architecture;