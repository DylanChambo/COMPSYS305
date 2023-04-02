library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    generic (DataWidth : integer);
    port (
        I_SEL : in unsigned(1 downto 0);
        I_SIG1 : in unsigned(DataWidth - 1 downto 0);
        I_SIG2 : in unsigned(DataWidth - 1 downto 0);
        I_SIG3 : in unsigned(DataWidth - 1 downto 0);
        I_SIG4 : in unsigned(DataWidth - 1 downto 0);

        Q_SIG : out unsigned(DataWidth - 1 downto 0)
    );
end entity;

architecture rtl of mux is
begin
    process (I_SEL, I_SIG1, I_SIG2, I_SIG3, I_SIG4)
    begin
        case I_SEL is
            when "00" => Q_SIG <= I_SIG1;
            when "01" => Q_SIG <= I_SIG2;
            when "10" => Q_SIG <= I_SIG3;
            when "11" => Q_SIG <= I_SIG4;
            when others => Q_SIG <= (others => 'X');
        end case;
    end process;
end architecture;