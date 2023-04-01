library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bcd_counter is
    port (
        I_CLK : in std_logic;
        I_DIRECTION : in std_logic;
        I_INIT : in std_logic;
        I_ENABLE : in std_logic;
        Q_Q : out std_logic_vector(3 downto 0)
    );
end bcd_counter;

architecture behaviour of bcd_counter is
    signal L_Q : std_logic_vector(3 downto 0) := "0000";
begin
    process (I_CLK)
    begin
        if (I_CLK'event and I_CLK = '1') then
            if (I_INIT = '1') then
                case I_DIRECTION is
                    when '0' => L_Q <= "1001";
                    when others => L_Q <= "0000";
                end case;
            elsif (I_ENABLE = '1') then
                if (L_Q = "0000" and I_DIRECTION = '0') then
                    L_Q <= "1001";
                elsif (L_Q = "1001" and I_DIRECTION = '1') then
                    L_Q <= "0000";
                elsif (I_DIRECTION = '1') then
                    L_Q <= L_Q + '1';
                else
                    L_Q <= L_Q - '1';
                end if;
            end if;
        end if;
    end process;

    Q_Q <= L_Q;
end architecture;