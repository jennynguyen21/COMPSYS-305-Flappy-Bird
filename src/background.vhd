LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
USE IEEE.STD_LOGIC_SIGNED.all;

entity background is
    port(
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        switches : in std_logic_vector(2 downto 0);
        background_rgb: OUT std_logic_vector(2 downto 0);
        background_on: OUT std_logic
    );
end background;

architecture Behavioral of background is
begin
    process(switches)
    begin
        case switches is
            when "000" => background_rgb <= "000"; -- Black
            when "001" => background_rgb <= "001"; -- Blue
            when "010" => background_rgb <= "010"; -- Green
            when "011" => background_rgb <= "011"; -- Cyan
            when "100" => background_rgb <= "100"; -- Red
            when "101" => background_rgb <= "101"; -- Magenta
            when "110" => background_rgb <= "110"; -- Yellow
            when "111" => background_rgb <= "111"; -- White
            when others => background_rgb <= "000"; -- Default Black
        end case;
    end process;
    
    background_on <= '1';

end Behavioral;