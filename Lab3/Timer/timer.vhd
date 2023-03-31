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

    component BCD_to_SevenSeg is
        port (
            BCD_digit : in std_logic_vector(3 downto 0);
            SevenSeg_out : out std_logic_vector(6 downto 0));
    end component;
begin
    process (clk)
    begin
        if (Clk'event and Clk = '1') then
            if (start = '1') then
                --If the timer is starting
                top <= data_in;
                time_out <= '0';
                seconds_overflow <= start;
                one_enable <= '1';
            elsif (minutes(1 downto 0) & tenSec & oneSec + '1' >= top) then
                -- If the timer is Finished
                time_out <= '1';
                one_enable <= '0';
            else
                -- If the timer is Counting
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
    -- Minute Counter and Seven Seg Converter
    min_BCD : bcd_counter port map(
        clk => clk,
        direction => '1',
        init => start,
        enable => min_enable,
        Q => minutes
    );

    min_SevenSEG : BCD_to_SevenSeg port map(
        BCD_digit => minutes,
        SevenSeg_out => minutes_Dig
    );
    -- Tens of Seconds Counter and Seven Seg Converter
    tenSec_BCD : bcd_counter port map(
        clk => clk,
        direction => '1',
        init => seconds_overflow,
        enable => ten_enable,
        Q => tenSec
    );

    ten_SevenSEG : BCD_to_SevenSeg port map(
        BCD_digit => tenSec,
        SevenSeg_out => tenSec_Dig
    );
    -- Ones of Seconds Counter and Seven Seg Converter
    oneSec_BCD : bcd_counter port map(
        clk => clk,
        direction => '1',
        init => start,
        enable => one_enable,
        Q => oneSec
    );

    one_SevenSEG : BCD_to_SevenSeg port map(
        BCD_digit => oneSec,
        SevenSeg_out => oneSec_Dig
    );
end architecture;