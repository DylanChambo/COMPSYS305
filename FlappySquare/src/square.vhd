library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity square is
	port (
		I_PB1, I_PB2, I_V_SYNC, I_CLICK : in std_logic;
		I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
		O_RED, O_GREEN, O_BLUE : out std_logic);
end square;

architecture behavior of square is
	constant GRAVITY : std_logic_vector(9 downto 0) := "0000000001";

	signal L_ON : std_logic;
	signal L_SIZE : std_logic_vector(9 downto 0);

	signal L_Y_POS : std_logic_vector(9 downto 0);
	signal L_X_POS : std_logic_vector(10 downto 0);

begin
	Move_Ball : process (I_V_SYNC)
		variable Y_VELCITY : std_logic_vector(9 downto 0);
	begin
		-- Move square once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (I_CLICK = '1' and Y_VELCITY <= 0) then
				Y_VELCITY := - CONV_STD_LOGIC_VECTOR(4, 10);
			else
				Y_VELCITY := Y_VELCITY + GRAVITY;
			end if;
			-- Bounce off top or bottom of the screen
			if (('0' & L_Y_POS < CONV_STD_LOGIC_VECTOR(479, 10) - L_SIZE)) then
				L_Y_POS <= L_Y_POS + Y_VELCITY;
			end if;

		end if;
	end process Move_Ball;

	L_SIZE <= CONV_STD_LOGIC_VECTOR(8, 10);
	-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
	L_X_POS <= CONV_STD_LOGIC_VECTOR(590, 11);

	L_ON <= '1' when (('0' & L_X_POS <= '0' & I_PIXEL_COL + L_SIZE) and ('0' & I_PIXEL_COL <= '0' & L_X_POS + L_SIZE) -- x_pos - size <= pixel_column <= x_pos + size
		and ('0' & L_Y_POS <= I_PIXEL_ROW + L_SIZE) and ('0' & I_PIXEL_ROW <= L_Y_POS + L_SIZE)) else -- y_pos - size <= pixel_row <= y_pos + size
		'0';
	-- Colours for pixel data on video signal
	-- Changing the background and ball colour by pushbuttons
	O_RED <= I_PB1;
	O_GREEN <= (not I_PB2) and (not L_ON);
	O_BLUE <= not L_ON;

end behavior;