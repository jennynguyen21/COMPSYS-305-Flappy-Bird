library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity menu is
    port (
        clock: in  std_logic;
        pixel_column, pixel_row: in unsigned (9 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0)
    );
end entity menu;

architecture behavior of menu is
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
				--Print out FLAPPY BIRD in large font size
				if ((pixel_column >= 144 and pixel_column < 176) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000110"; -- F (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 144)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 176 and pixel_column < 208) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "001100"; -- L (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 176)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 208 and pixel_column < 240) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000001"; -- A (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 208)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 240 and pixel_column < 272) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "010000"; -- P (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 240)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 272 and pixel_column < 304) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "010000"; -- P (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 272)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 304 and pixel_column < 336) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "011001"; -- Y (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 304)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 336 and pixel_column < 368) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "100000"; -- Space (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 336)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2);
				elsif ((pixel_column >= 368 and pixel_column < 400) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000010"; -- B (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 368)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 400 and pixel_column < 432) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "001001"; -- I (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 400)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2); 
				elsif ((pixel_column >= 432 and pixel_column < 464) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "010010"; -- R (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 432)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2);
				elsif ((pixel_column >= 464 and pixel_column < 496) and (pixel_row >= 120 and pixel_row < 152)) then 
					char_address <= "000100"; -- D (FLAPPY BIRD)
					font_col <= std_logic_vector(pixel_column - 464)(4 downto 2);
					font_row <= std_logic_vector(pixel_row - 120)(4 downto 2);
				
				-- Print out Modes for mode selection
				
				elsif ((pixel_column >= 280 and pixel_column < 296) and (pixel_row >= 168 and pixel_row < 184)) then 
					char_address <= "001101"; -- M (MODES)
					font_col <= std_logic_vector(pixel_column - 280)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 168)(3 downto 1);
				elsif ((pixel_column >= 296 and pixel_column < 312) and (pixel_row >= 168 and pixel_row < 184)) then 
					char_address <= "001111"; -- O (MODES)
					font_col <= std_logic_vector(pixel_column - 296)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 168)(3 downto 1);
				elsif ((pixel_column >= 312 and pixel_column < 328) and (pixel_row >= 168 and pixel_row < 184)) then 
					char_address <= "000100"; -- D (MODES)
					font_col <= std_logic_vector(pixel_column - 312)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 168)(3 downto 1);
				elsif ((pixel_column >= 328 and pixel_column < 344) and (pixel_row >= 168 and pixel_row < 184)) then 
					char_address <= "000101"; -- E (MODES)
					font_col <= std_logic_vector(pixel_column - 328)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 168)(3 downto 1);
				elsif ((pixel_column >= 344 and pixel_column < 360) and (pixel_row >= 168 and pixel_row < 184)) then 
					char_address <= "010011"; -- S (MODES)
					font_col <= std_logic_vector(pixel_column - 344)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 168)(3 downto 1);
					
				--Print out Train Key 2
				
				elsif ((pixel_column >= 224 and pixel_column < 240) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "010100"; -- T (TRAIN)
					font_col <= std_logic_vector(pixel_column - 224)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 240 and pixel_column < 256) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "010010"; -- R (TRAIN)
					font_col <= std_logic_vector(pixel_column - 240)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 256 and pixel_column < 272) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "000001"; -- A (TRAIN)
					font_col <= std_logic_vector(pixel_column - 256)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 272 and pixel_column < 288) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "001001"; -- I (TRAIN)
					font_col <= std_logic_vector(pixel_column - 272)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 288 and pixel_column < 304) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "001110"; -- N (TRAIN)
					font_col <= std_logic_vector(pixel_column - 288)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 304 and pixel_column < 320) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "100000"; -- Space (TRAIN)
					font_col <= std_logic_vector(pixel_column - 304)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 320 and pixel_column < 336) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "100000"; -- Space (TRAIN)
					font_col <= std_logic_vector(pixel_column - 320)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 336 and pixel_column < 352) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "001011"; -- K (KEY 2)
					font_col <= std_logic_vector(pixel_column - 336)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 352 and pixel_column < 368) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "000101"; -- E (KEY 2)
					font_col <= std_logic_vector(pixel_column - 352)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 368 and pixel_column < 384) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "011001"; -- Y (KEY 2)
					font_col <= std_logic_vector(pixel_column - 368)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 384 and pixel_column < 400) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "100000"; -- Space (KEY 2)
					font_col <= std_logic_vector(pixel_column - 384)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
				elsif ((pixel_column >= 400 and pixel_column < 416) and (pixel_row >= 200 and pixel_row < 216)) then 
					char_address <= "110010"; -- 2 (KEY 2)
					font_col <= std_logic_vector(pixel_column - 400)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 200)(3 downto 1);
					
				-- Print Normal Key 3
				
				--Print out Train Key 2
				
				elsif ((pixel_column >= 224 and pixel_column < 240) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "001110"; -- N (NORMAL)
					font_col <= std_logic_vector(pixel_column - 224)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 240 and pixel_column < 256) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "001111"; -- O (NORMAL)
					font_col <= std_logic_vector(pixel_column - 240)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 256 and pixel_column < 272) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "010010"; -- R (NORMAL)
					font_col <= std_logic_vector(pixel_column - 256)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 272 and pixel_column < 288) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "001101"; -- M (NORMAL)
					font_col <= std_logic_vector(pixel_column - 272)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 288 and pixel_column < 304) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "000001"; -- A (NORMAL)
					font_col <= std_logic_vector(pixel_column - 288)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 304 and pixel_column < 320) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "001100"; -- L(NORMAL)
					font_col <= std_logic_vector(pixel_column - 304)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 320 and pixel_column < 336) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "100000"; -- Space (NORMAL)
					font_col <= std_logic_vector(pixel_column - 320)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 336 and pixel_column < 352) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "001011"; -- K (KEY 3)
					font_col <= std_logic_vector(pixel_column - 336)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 352 and pixel_column < 368) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "000101"; -- E (KEY 3)
					font_col <= std_logic_vector(pixel_column - 352)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 368 and pixel_column < 384) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "011001"; -- Y (KEY 3)
					font_col <= std_logic_vector(pixel_column - 368)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 384 and pixel_column < 400) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "100000"; -- Space (KEY 3)
					font_col <= std_logic_vector(pixel_column - 384)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
				elsif ((pixel_column >= 400 and pixel_column < 416) and (pixel_row >= 224 and pixel_row < 240)) then 
					char_address <= "110011"; -- 3 (KEY 3)
					font_col <= std_logic_vector(pixel_column - 400)(3 downto 1);
					font_row <= std_logic_vector(pixel_row - 224)(3 downto 1);
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
					

				