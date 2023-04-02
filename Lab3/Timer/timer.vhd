library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer is
    port (
        I_CLK, I_START : in std_logic;
        I_DATA_IN : in std_logic_vector(9 downto 0);
        Q_MIN, Q_TEN, Q_ONE : out std_logic_vector(6 downto 0);
        Q_TIME_OUT : out std_logic
    );
end timer;

architecture behaviour of timer is
    component bcd_counter is
        port (
            I_CLK : in std_logic;
            I_DIRECTION : in std_logic;
            I_INIT : in std_logic;
            I_ENABLE : in std_logic;
            Q_Q : out std_logic_vector(3 downto 0)
        );
    end component bcd_counter;

    signal M_Q, T_Q, O_Q : std_logic_vector(3 downto 0);
    component BCD_to_SevenSeg is
        port (
            I_BCD_DIGIT : in std_logic_vector(3 downto 0);
            Q_SEG : out std_logic_vector(6 downto 0)
        );
    end component;

    signal L_MIN_ENABLE, L_TEN_ENABLE, L_ONE_ENABLE : std_logic;
    signal L_SEC_OVERFLOW : std_logic;
    signal L_TOP : std_logic_vector(9 downto 0) := (others => '0');
    signal L_TIME_OUT : std_logic;
    signal L_CLK : std_logic := '0';
    signal L_CLK_COUNT : integer := 0;
begin
    -- Minute Counter and Seven Seg Converter
    min_BCD : bcd_counter port map(
        I_CLK => L_CLK,
        I_DIRECTION => '1',
        I_INIT => I_START,
        I_ENABLE => L_MIN_ENABLE,
        Q_Q => M_Q
    );

    min_SEG : BCD_to_SevenSeg port map(
        I_BCD_DIGIT => M_Q,
        Q_SEG => Q_MIN
    );
    -- Tens of Seconds Counter and Seven Seg Converter
    ten_BCD : bcd_counter port map(
        I_CLK => L_CLK,
        I_DIRECTION => '1',
        I_INIT => L_SEC_OVERFLOW,
        I_ENABLE => L_TEN_ENABLE,
        Q_Q => T_Q
    );
    ten_SEG : BCD_to_SevenSeg port map(
        I_BCD_DIGIT => T_Q,
        Q_SEG => Q_TEN
    );
    -- Ones of Seconds Counter and Seven Seg Converter
    one_BCD : bcd_counter port map(
        I_CLK => L_CLK,
        I_DIRECTION => '1',
        I_INIT => I_START,
        I_ENABLE => L_ONE_ENABLE,
        Q_Q => O_Q
    );

    one_SEG : BCD_to_SevenSeg port map(
        I_BCD_DIGIT => O_Q,
        Q_SEG => Q_ONE
    );

    -- Set the top when start is pressed
    set_top : process (L_CLK)
    begin
        if (L_CLK'event and L_CLK = '1') then
            if (I_START = '1') then
                L_TOP(9 downto 8) <= I_DATA_IN(9 downto 8);

                if (I_DATA_IN(7 downto 4) > "0101") then
                    L_TOP(7 downto 4) <= "0101";
                else
                    L_TOP(7 downto 4) <= I_DATA_IN(7 downto 4);
                end if;

                if (I_DATA_IN(3 downto 0) > "1001") then
                    L_TOP(3 downto 0) <= "1001";
                else
                    L_TOP(3 downto 0) <= I_DATA_IN(3 downto 0);
                end if;
            end if;
        end if;
    end process;

    -- Divide System Clock by 25e6 to get 1Hz clock
    clock_div : process (I_CLK)
    begin
        if (I_CLK'event and I_CLK = '1') then
            L_CLK_COUNT <= L_CLK_COUNT + 1;
            if (L_CLK_COUNT = (25e6)) then
                L_CLK <= not L_CLK;
                L_CLK_COUNT <= 0;
            end if;
        end if;
    end process;

    L_TIME_OUT <= '1' when (M_Q(1 downto 0) & T_Q & O_Q = L_TOP or L_TOP = "0000000000") else
        '0';
    Q_TIME_OUT <= L_TIME_OUT;
    L_ONE_ENABLE <= '0' when (L_TIME_OUT = '1') else
        '1';
    L_TEN_ENABLE <= '1' when (O_Q = "1001" and L_TIME_OUT = '0') else
        '0';
    L_MIN_ENABLE <= '1' when (O_Q = "1001" and T_Q = "0101" and L_TIME_OUT = '0') else
        '0';
    L_SEC_OVERFLOW <= '1' when (L_MIN_ENABLE = '1' or I_START = '1') else
        '0';
end architecture;