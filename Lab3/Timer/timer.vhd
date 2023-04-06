library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer is
    generic (
        CLK_FREQ : integer := 50e6
    );
    port (
        I_CLK, I_START : in std_logic;
        I_DATA_IN : in std_logic_vector(9 downto 0);
        Q_MIN, Q_TEN, Q_ONE : out std_logic_vector(6 downto 0);
        Q_TIME_OUT : out std_logic
    );
end timer;

architecture rtl of timer is

    procedure SetTop(
        signal I_DATA : in std_logic_vector(9 downto 0);
        signal Q_TOP : out std_logic_vector(9 downto 0)
    ) is
    begin
        Q_TOP(9 downto 8) <= I_DATA(9 downto 8);

        if (I_DATA_IN(7 downto 4) > "0101") then
            Q_TOP(7 downto 4) <= "0101";
        else
            Q_TOP(7 downto 4) <= I_DATA(7 downto 4);
        end if;

        if (I_DATA_IN(3 downto 0) > "1001") then
            Q_TOP(3 downto 0) <= "1001";
        else
            Q_TOP(3 downto 0) <= I_DATA(3 downto 0);
        end if;
    end procedure;

    signal M_Q, T_Q, O_Q : std_logic_vector(3 downto 0);

    signal L_MIN_ENABLE, L_TEN_ENABLE, L_ONE_ENABLE : std_logic := '0';
    signal L_SEC_OVERFLOW : std_logic;
    signal L_TOP : std_logic_vector(9 downto 0) := (others => '0');
    signal L_TIME_OUT : std_logic;
    signal L_TICK : integer := 0;
    signal L_START : std_logic;
begin
    -- Minute Counter and Seven Seg Converter
    min_BCD : entity work.bcd_counter port map(
        I_CLK => I_CLK,
        I_DIRECTION => '1',
        I_INIT => L_START,
        I_ENABLE => L_MIN_ENABLE,
        Q_Q => M_Q
        );

    min_SEG : entity work.BCD_to_SevenSeg port map(
        I_BCD_DIGIT => M_Q,
        Q_SEG => Q_MIN
        );
    -- Tens of Seconds Counter and Seven Seg Converter
    ten_BCD : entity work.bcd_counter port map(
        I_CLK => I_CLK,
        I_DIRECTION => '1',
        I_INIT => L_SEC_OVERFLOW,
        I_ENABLE => L_TEN_ENABLE,
        Q_Q => T_Q
        );
    ten_SEG : entity work.BCD_to_SevenSeg port map(
        I_BCD_DIGIT => T_Q,
        Q_SEG => Q_TEN
        );
    -- Ones of Seconds Counter and Seven Seg Converter
    one_BCD : entity work.bcd_counter port map(
        I_CLK => I_CLK,
        I_DIRECTION => '1',
        I_INIT => L_START,
        I_ENABLE => L_ONE_ENABLE,
        Q_Q => O_Q
        );

    one_SEG : entity work.BCD_to_SevenSeg port map(
        I_BCD_DIGIT => O_Q,
        Q_SEG => Q_ONE
        );

    -- Set the top when start is pressed
    process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            if (L_START = '1') then
                SetTop(I_DATA_IN, L_TOP);
                L_TICK <= 0;
            elsif (L_TIME_OUT = '0') then
                if L_TICK = CLK_FREQ - 1 then
                    L_TICK <= 0;
                    L_ONE_ENABLE <= '1';
                    if (O_Q = "1001") then
                        L_TEN_ENABLE <= '1';
                        if (T_Q = "0101") then
                            L_MIN_ENABLE <= '1';
                        end if;
                    end if;
                else
                    L_ONE_ENABLE <= '0';
                    L_TEN_ENABLE <= '0';
                    L_MIN_ENABLE <= '0';
                    L_TICK <= L_TICK + 1;
                end if;
            end if;
        end if;
    end process;

    L_TIME_OUT <= '1' when (M_Q(1 downto 0) & T_Q & O_Q >= L_TOP) else
        '0';
    Q_TIME_OUT <= L_TIME_OUT;
    L_SEC_OVERFLOW <= '1' when (L_MIN_ENABLE = '1' or L_START = '1') else
        '0';
    L_START <= not I_START;
end architecture;