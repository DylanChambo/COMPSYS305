library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity seq_counter is
    port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        mode : in std_logic_vector(1 downto 0);
        Q : out std_logic_vector(4 downto 0)
    );
end seq_counter;

architecture behaviour of seq_counter is
    type num_vector is array (0 to 6) of std_logic_vector(4 downto 0);
    constant nums : num_vector := ("00101", "00010", "01101", "11110", "11001", "10000", "10010");
begin
    process (clk, rst)
        variable A, B : std_logic_vector(4 downto 0);
        variable C : integer;
        variable D : std_logic_vector(4 downto 0) := "01101";
        variable old_mode : std_logic_vector(1 downto 0) := "00";
    begin
        if (enable = '1') then
            if ((Clk'event and Clk = '1') or rst = '1') then
                if (old_mode /= mode or rst = '1') then
                    A := "00000";
                    B := "01111";
                    C := 0;
                    old_mode := mode;
                else
                    A := A + "1";
                    if (A > "11000") then
                        A := "00000";
                    end if;

                    if (B = "0") then
                        B := "01111";
                    else
                        B := B - "1";
                    end if;

                    C := (C + 1) mod 7;
                end if;

                case mode is
                    when "00" => Q <= A;
                    when "01" => Q <= B;
                    when "10" => Q <= nums(C);
                    when others => Q <= D;
                end case;
            end if;
        end if;

    end process;
end architecture;