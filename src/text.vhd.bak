library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_text is
    port (
        clock: in  std_logic;
        pixel_column, pixel_row: in unsigned (9 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0)
    );
end entity display_text;

architecture behavior of display_text is
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
					-- Print out Level 1
					
					-- L of Level 1
                if ((pixel_column >= 0 and pixel_column < 16) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "001100"; --- L (Level)
                    font_col <= std_logic_vector(pixel_column - 0)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1);
						  
					-- E of Level 1
					 elsif ((pixel_column >= 16 and pixel_column < 32) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "000101"; --- E (Level)
                    font_col <= std_logic_vector(pixel_column - 16)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
						  
					-- V of Level 1
					 elsif ((pixel_column >= 32 and pixel_column < 48) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "010110"; --- V (Level)
                    font_col <= std_logic_vector(pixel_column - 32)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
						  
					-- E of Level 1
					 elsif ((pixel_column >= 48 and pixel_column < 64) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "000101"; --- E (Level)
                    font_col <= std_logic_vector(pixel_column - 48)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1);
						  
					-- L of Level 1
                elsif ((pixel_column >= 64 and pixel_column < 80) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "001100"; --- L (Level)
                    font_col <= std_logic_vector(pixel_column - 64)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
						  
					-- Space of Level 1
                elsif ((pixel_column >= 80 and pixel_column < 96) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "100000"; -- Space
                    font_col <= std_logic_vector(pixel_column - 80)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
						  
					-- 1 of Level 1
                elsif ((pixel_column >= 96 and pixel_column < 112) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "110001"; -- 1
                    font_col <= std_logic_vector(pixel_column - 96)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
						
						
					 --Print out SCORE
					 -- S of Score
					 elsif ((pixel_column >= 0 and pixel_column < 32) and (pixel_row >= 12 and pixel_row < 44)) then 
                    char_address <= "010011"; -- S (Score)
                    font_col <= std_logic_vector(pixel_column - 0)(4 downto 2);
						  font_row <= std_logic_vector(pixel_row - 12)(4 downto 2); 
						  
					-- C of Score
					 elsif ((pixel_column >= 32 and pixel_column < 64) and (pixel_row >= 12 and pixel_row < 44)) then 
                    char_address <= "000011"; -- C (Score)
                    font_col <= std_logic_vector(pixel_column - 32)(4 downto 2);
						  font_row <= std_logic_vector(pixel_row - 12)(4 downto 2); 
						  
					-- O of Score
					 elsif ((pixel_column >= 64 and pixel_column < 96) and (pixel_row >= 12 and pixel_row < 44)) then 
                    char_address <= "001111"; -- O (Score)
                    font_col <= std_logic_vector(pixel_column - 64)(4 downto 2);
						  font_row <= std_logic_vector(pixel_row - 12)(4 downto 2); 
						  
					-- R of Score
					 elsif ((pixel_column >= 96 and pixel_column < 128) and (pixel_row >= 12 and pixel_row < 44)) then 
                    char_address <= "010010"; -- R (Score)
                    font_col <= std_logic_vector(pixel_column - 96)(4 downto 2);
						  font_row <= std_logic_vector(pixel_row - 12)(4 downto 2); 
						  
					-- E of Score
					 elsif ((pixel_column >= 128 and pixel_column < 160) and (pixel_row >= 12 and pixel_row < 44)) then 
                    char_address <= "000101"; -- E (Score)
                    font_col <= std_logic_vector(pixel_column - 128)(4 downto 2);
						  font_row <= std_logic_vector(pixel_row - 12)(4 downto 2); 
                else
                    char_address <= "100000"; -- Space
                    font_col <= std_logic_vector(pixel_column)(3 downto 1);
						  font_row <= std_logic_vector(pixel_row)(3 downto 1);
                end if;

                -- Set text_rgb only when rom_output is '1'
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