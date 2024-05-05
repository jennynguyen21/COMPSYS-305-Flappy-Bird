LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity pipes is
    port (
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        red, green, blue : OUT std_logic
    );
end pipes;

architecture Behavioral of pipes is

    constant pipe_width: integer := 60;
    constant pipe_gap : integer := 80;
    constant pipe_height : integer := 150;
    constant pipe_spacing : integer := 140;

    signal pipe_x: std_logic_vector(9 DOWNTO 0);

    signal pipe_on: std_logic;

begin
    -- fixed x position of pipe
    pipe_x <= CONV_STD_LOGIC_VECTOR(400, 10);

    pipe_on <= '1' when (
        ('0' & pixel_column >= '0' & pipe_x) and
        ('0' & pixel_column < '0' & (pipe_x + CONV_STD_LOGIC_VECTOR(pipe_width, 10))) and
        (('0' & pixel_row < CONV_STD_LOGIC_VECTOR(240 - pipe_gap / 2, 10)) or
         ('0' & pixel_row > CONV_STD_LOGIC_VECTOR(240 + pipe_gap / 2, 10)))
    ) else '0';

    red <= '0' when pipe_on = '1' else '0';   -- Red is off
    green <= '1' when pipe_on = '1' else '0'; -- Green is on for the pipe, off otherwise
    blue <= '0' when pipe_on = '1' else '0';  -- Blue is off


end Behavioral;