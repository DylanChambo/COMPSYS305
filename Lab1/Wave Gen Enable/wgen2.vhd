entity wgen2 is
  port (
    X : in bit_vector(2 downto 0);
    Enable : in bit;
    A, B, C, Z : out bit);
end entity wgen2;

architecture behaviour of wgen2 is
  signal v_A, v_B, v_C, v_Z : bit;
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
      when "000" => v_Z <= v_A and v_B;
      when "001" => v_Z <= v_B or v_C;
      when "010" => v_Z <= (v_A or v_B) and v_C;
      when "011" => v_Z <= (v_A xor v_B) or v_C;
      when "100" => v_Z <= v_A;
      when "101" => v_Z <= v_B;
      when "110" => v_Z <= v_C;
      when "111" => v_Z <= '1';
    end case;
  end process;
  A <= v_A and Enable;
  B <= v_B and Enable;
  C <= v_C and Enable;
  Z <= v_Z and Enable;
end architecture behaviour;