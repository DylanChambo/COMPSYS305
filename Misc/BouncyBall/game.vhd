library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port (
        I_CLK : in std_logic;
        I_PB1 : in std_logic;
        I_PB2 : in std_logic;

        Q_RED : out std_logic;
        Q_GREEN : out std_logic;
        Q_BLUE : out std_logic;
        Q_H_SYNC : out std_logic;
        Q_V_SYNC : out std_logic
    );
end game;

architecture behavior of game is
    signal B_RED : std_logic;
    signal B_GREEN : std_logic;
    signal B_BLUE : std_logic;

    signal V_V_SYNC : std_logic;
    signal V_PIXEL_ROW : std_logic_vector(9 downto 0);
    signal V_PIXEL_COL : std_logic_vector(9 downto 0);

begin
    ball : entity work.bouncy_ball
        port map(
            PB1 => I_PB1,
            PB2 => I_PB2,
            vert_sync => V_V_SYNC,
            pixel_row => V_PIXEL_ROW,
            pixel_column => V_PIXEL_COL,

            RED => B_RED,
            GREEN => B_GREEN,
            BLUE => B_BLUE
        );

    video : entity work.VGA_SYNC
        port map(
            clock_25Mhz => I_CLK,
            RED => B_RED,
            GREEN => B_GREEN,
            BLUE => B_BLUE,

            red_out => Q_RED,
            green_out => Q_GREEN,
            blue_out => Q_BLUE,
            vert_sync_out => V_V_SYNC,
            horiz_sync_out => Q_H_SYNC,
            pixel_row => V_PIXEL_ROW,
            pixel_column => V_PIXEL_COL
        );

    Q_V_SYNC <= V_V_SYNC;
end architecture;