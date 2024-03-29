entity wgen1 is
  port (
    X : in bit_vector(2 downto 0);
    A, B, C, Z : out bit);
end entity wgen1;

architecture behaviour of wgen1 is
  signal v_A, v_B, v_C : bit;
begin
  sigGen : process
  begin
    v_A <= '1', '0' after 2 ns, '1' after 3 ns, '0' after 4 ns;
    v_B <= '0', '1' after 1 ns, '0' after 2 ns, '1' after 3 ns, '0' after 4 ns;
    v_C <= '1', '0' after 1 ns, '1' after 2 ns, '0' after 3 ns, '1' after 4 ns;
    wait for 5 ns;
  end process sigGen;
  process (X, v_A, v_B, v_C)
  begin
    case X is
      when "000" => Z <= v_A and v_B;
      when "001" => Z <= v_B or v_C;
      when "010" => Z <= (v_A or v_B) and v_C;
      when "011" => Z <= (v_A xor v_B) or v_C;
      when "100" => Z <= v_A;
      when "101" => Z <= v_B;
      when "110" => Z <= v_C;
      when "111" => Z <= '1';
    end case;
  end process;
  A <= v_A;
  B <= v_B;
  C <= v_C;
end architecture behaviour;