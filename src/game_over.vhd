library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_over is
    port (
        clock: in  std_logic;
        pixel_column, pixel_row: in unsigned (9 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0)
    );
end entity game_over;

architecture behavior of game_over is
    signal char_address : std_logic_vector(5 downto 0);
    signal font_col, font_row : std_logic_vector(2 downto 0);
    signal rom_output : std_logic;
    signal text_rgb : std_logic_vector(2 downto 0);
    signal text_enable_temp : std_logic;

    -- Component declaration for char_rom
    component char_rom
        port (
            character_address : in  std_logic_vector(5 downto 0);
            font_col, font_row: in  std_logic_vector(2 downto 0);
            clock       : in  std_logic;
            rom_mux_output : out std_logic
        );
    end component;

begin
    -- Instantiate char_rom component
    char_rom_inst : char_rom
        port map (
            character_address => char_address,
            font_col => font_col,
				font_row => font_row,
            clock => clock,
            rom_mux_output => rom_output
        );
    get_characters : process (clock)
        begin
            if (rising_edge(clock)) then
				--Print out GAME OVER in large font size
				if ((pixel_column >= 176 and pixel_column < 208) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000111"; -- G
					font_col <= std_logic_vector(pixel_column - 176)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 208 and pixel_column < 240) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000001"; -- A 
					font_col <= std_logic_vector(pixel_column - 208)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 240 and pixel_column < 272) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "001101"; -- M
					font_col <= std_logic_vector(pixel_column - 240)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 272 and pixel_column < 304) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000101"; -- E
					font_col <= std_logic_vector(pixel_column - 272)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 304 and pixel_column < 336) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "100000"; -- SPACE
					font_col <= std_logic_vector(pixel_column - 304)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 336 and pixel_column < 368) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "001111"; -- O
					font_col <= std_logic_vector(pixel_column - 336)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2);
				elsif ((pixel_column >= 368 and pixel_column < 400) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "010110"; -- V
					font_col <= std_logic_vector(pixel_column - 368)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 400 and pixel_column < 432) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000101"; -- E
					font_col <= std_logic_vector(pixel_column - 400)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 432 and pixel_column < 464) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "010010"; -- R 
					font_col <= std_logic_vector(pixel_column - 432)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2);
				else
					char_address <= "100000"; -- Space
                    font_col <= std_logic_vector(pixel_column)(3 downto 1);
					font_row <= std_logic_vector(pixel_row)(3 downto 1);
				end if;
				
				if rom_output = '1' then
                    text_rgb <= "111"; -- White text
                    text_enable_temp <= '1'; -- Enable text
                else
                    text_enable_temp <= '0'; -- Disable text
                end if;
			end if;
		end process;
		
	-- Output text RGB if enabled, otherwise keep VGA output unchanged
    vga_rgb <= text_rgb when text_enable_temp = '1' else (others => 'Z');
    text_enable <= text_enable_temp;
end architecture behavior;