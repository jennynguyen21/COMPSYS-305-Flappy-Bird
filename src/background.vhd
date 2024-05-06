LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
USE IEEE.STD_LOGIC_SIGNED.all;

entity background is
    port(
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        background_rgb: OUT std_logic_vector(2 downto 0);
        background_on: OUT std_logic
    );
end background;

architecture Behavioral of background is
begin

    background_rgb <= "011"; --cyan
    background_on <= '1';

end Behavioral;