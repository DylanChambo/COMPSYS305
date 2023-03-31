library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bcd_counter is
    port (
        clk : in std_logic;
        direction : in std_logic;
        init : in std_logic;
        enable : in std_logic;
        Q : out std_logic_vector(3 downto 0)
    );
end bcd_counter;

architecture behaviour of bcd_counter is

begin
    process (clk)
        variable v_Q : std_logic_vector(3 downto 0) := "0000";
    begin
        if (Clk'event and Clk = '1') then
            if (init = '1') then
                case direction is
                    when '0' => v_Q := "1001";
                    when others => v_Q := "0000";
                end case;
            elsif (enable = '1') then
                if (v_Q = "0000" and direction = '0') then
                    v_Q := "1001";
                elsif (v_Q = "1001" and direction = '1') then
                    v_Q := "0000";
                elsif (direction = '1') then
                    v_Q := v_Q + '1';
                else
                    v_Q := v_Q - '1';
                end if;
            end if;
            Q <= v_Q;
        end if;
    end process;
end architecture;