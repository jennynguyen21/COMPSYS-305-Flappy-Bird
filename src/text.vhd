LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
use IEEE.NUMERIC_STD.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity text is
    port (
    pixel_row, pixel_column: in std_logic_vector (9 downto 0);
    character_add: out std_logic_vector(5 downto 0);
    font_row_sel, font_col_sel : out std_logic_vector (2 downto 0);
    text_rgb: out std_logic_vector(2 downto 0));
end entity text;

architecture behaivour of text is
begin
    character_add <= "001100" when ((pixel_column <= std_logic_vector(to_unsigned(16,10)))AND(pixel_row >= std_logic_vector(to_unsigned(462,10))))--L
            else "000101" when ((pixel_column <= std_logic_vector(to_unsigned(32,10)))AND(pixel_row >= std_logic_vector(to_unsigned(462,10))))--E
            else "010110" when ((pixel_column <= std_logic_vector(to_unsigned(48,10)))AND(pixel_row >= std_logic_vector(to_unsigned(462,10))))--V
            else "000101" when ((pixel_column <= std_logic_vector(to_unsigned(64,10)))AND(pixel_row >= std_logic_vector(to_unsigned(462,10))))--E
            else "001100" when ((pixel_column <= std_logic_vector(to_unsigned(80,10)))AND(pixel_row >= std_logic_vector(to_unsigned(462,10))))--L
            else "110010" when ((pixel_column <= std_logic_vector(to_unsigned(96,10)))AND(pixel_row >= std_logic_vector(to_unsigned(462,10))))--1
            else "100000"; --creates a blank space

    font_row_sel<=pixel_row(3 downto 1);
    font_col_sel<=pixel_column (3 downto 1);

    text_rgb <= "111";

end architecture behaivour;