library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity text is
    port (
        clock: in  std_logic;
        pixel_column, pixel_row: in unsigned (9 downto 0);
        score: in integer range 0 to 99;
        state: in std_logic_vector(1 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0)
    );
end entity text;

architecture behavior of text is
    signal char_address : std_logic_vector(5 downto 0);
    signal font_col, font_row : std_logic_vector(2 downto 0);
    signal rom_output : std_logic;
    signal text_rgb : std_logic_vector(2 downto 0);
    signal text_enable_temp : std_logic;
	type array_type is array (0 to 2) of std_logic_vector (5 downto 0);
    constant INIT_ARRAY : array_type := (
        "110001", "110010", "110011"
    );
	signal level: integer range 0 to 3;
    signal MY_ARRAY : array_type := INIT_ARRAY;

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
					-- Print out Level #
				 if state = "01" then 
                    level <= 0;
                 elsif (score <= 10) then 
                    level <= 0;
                elsif (score > 10 and score <= 20) then 
                    level <= 1;
                else
                    level <= 2;
                end if;
				
					-- L of Level #
                if ((pixel_column >= 0 and pixel_column < 16) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "001100"; --- L (Level)
                    font_col <= std_logic_vector(pixel_column - 0)(3 downto 1);
                    font_row <= std_logic_vector(pixel_row - 464)(3 downto 1);
						  
                    -- E of Level #
                elsif ((pixel_column >= 16 and pixel_column < 32) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "000101"; --- E (Level)
                    font_col <= std_logic_vector(pixel_column - 16)(3 downto 1);
                    font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
                    
                    -- V of Level #
                elsif ((pixel_column >= 32 and pixel_column < 48) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "010110"; --- V (Level)
                    font_col <= std_logic_vector(pixel_column - 32)(3 downto 1);
                    font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
                    
                    -- E of Level #
                elsif ((pixel_column >= 48 and pixel_column < 64) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "000101"; --- E (Level)
                    font_col <= std_logic_vector(pixel_column - 48)(3 downto 1);
                    font_row <= std_logic_vector(pixel_row - 464)(3 downto 1);
                    
                    -- L of Level #
                elsif ((pixel_column >= 64 and pixel_column < 80) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "001100"; --- L (Level)
                    font_col <= std_logic_vector(pixel_column - 64)(3 downto 1);
                    font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
                        
                    -- Space of Level #
                elsif ((pixel_column >= 80 and pixel_column < 96) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= "100000"; -- Space
                    font_col <= std_logic_vector(pixel_column - 80)(3 downto 1);
                    font_row <= std_logic_vector(pixel_row - 464)(3 downto 1); 
                
                    -- number of Level #
                elsif ((pixel_column >= 96 and pixel_column < 112) and (pixel_row >= 464 and pixel_row < 480)) then 
                    char_address <= MY_ARRAY(level);
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
    vga_rgb <= text_rgb when text_enable_temp = '1' and state /= "00" else (others => 'Z');
    text_enable <= text_enable_temp when state /= "00" else '0';

end behavior;