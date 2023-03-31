library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer is
    port (
        clk, start : in std_logic;
        data_in : in std_logic_vector(9 downto 0);
        minutes_Dig, tenSec_Dig, oneSec_Dig : out std_logic_vector(6 downto 0);
        time_out : out std_logic
    );
end timer;

architecture behaviour of timer is

    signal min_enable, ten_enable, one_enable : std_logic;
    signal seconds_overflow : std_logic;
    signal minutes, tenSec, oneSec : std_logic_vector(3 downto 0);
    signal top : std_logic_vector(9 downto 0);

    component bcd_counter is
        port (
            clk : in std_logic;
            direction : in std_logic;
            init : in std_logic;
            enable : in std_logic;
            Q : out std_logic_vector(3 downto 0)
        );
    end component bcd_counter;
begin
    process (clk)
    begin
        if (Clk'event and Clk = '1') then
            if (start = '1') then
                top <= data_in;
                time_out <= '0';
                seconds_overflow <= start;
                one_enable <= '1';
            elsif (minutes(1 downto 0) & tenSec & oneSec = top) then
                time_out <= '1';
                one_enable <= '0';
                ten_enable <= '0';
                min_enable <= '0';
            else
                if (oneSec = "1001") then
                    ten_enable <= '1';
                    if (tenSec = "0101") then
                        min_enable <= '1';
                        seconds_overflow <= '1';
                    else
                        min_enable <= '0';
                        seconds_overflow <= start;
                    end if;
                else
                    ten_enable <= '0';
                    min_enable <= '0';
                end if;
            end if;
        end if;
    end process;

    min_BCD : bcd_counter port map(
        clk => clk,
        direction => '1',
        init => start,
        enable => min_enable,
        Q => minutes
    );

    tenSec_BCD : bcd_counter port map(
        clk => clk,
        direction => '1',
        init => seconds_overflow,
        enable => ten_enable,
        Q => tenSec
    );

    oneSec_BCD : bcd_counter port map(
        clk => clk,
        direction => '1',
        init => start,
        enable => one_enable,
        Q => oneSec
    );
end architecture;