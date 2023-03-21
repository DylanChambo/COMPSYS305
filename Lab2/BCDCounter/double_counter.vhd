library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity double_counter is
    port (
        clk : in std_logic;
        direction : in std_logic;
        init : in std_logic;
        enable : in std_logic;
        Q0, Q1 : out std_logic_vector(3 downto 0)
    );
end double_counter;

architecture behaviour of double_counter is
    component bcd_counter is
        port (
            clk : in std_logic;
            direction : in std_logic;
            init : in std_logic;
            enable : in std_logic;
            Q : out std_logic_vector(3 downto 0)
        );
    end component bcd_counter;

    signal clk2 : std_logic;
    signal v_Q0 : std_logic_vector(3 downto 0);
begin
    digit0 : bcd_counter port map(
        clk => clk,
        direction => direction,
        init => init,
        enable => enable,
        Q => v_Q0
    );

    digit1 : bcd_counter port map(
        clk => clk2,
        direction => direction,
        init => init,
        enable => enable,
        Q => Q1
    );

    process (v_Q0) is
    begin
        if (v_Q0 = "1001" and direction = '0') then
            clk2 <= '1';
        elsif (v_Q0 = "0000" and direction = '1') then
            clk2 <= '1';
        else
            clk2 <= '0';
        end if;
        Q0 <= v_Q0;
    end process;
end architecture;