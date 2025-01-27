library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hearts is
    port (
        clock: in  std_logic;
        lives: in integer range 1 to 3;
        state: in std_logic_vector(1 downto 0);
        pixel_column, pixel_row: in unsigned (9 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0)
    );
end entity hearts;

architecture behavior of hearts is
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
            if rising_edge(clock) then 

                if (lives = 3) then
					if ((pixel_column >= 560 and pixel_column < 592) and (pixel_row >= 12 and pixel_row < 44)) then
						char_address <= "000000";
						font_col <= std_logic_vector(pixel_column - 560)(4 downto 2);
						font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
					elsif ((pixel_column >= 512 and pixel_column < 544) and (pixel_row >= 12 and pixel_row < 44)) then
						char_address <= "000000";
						font_col <= std_logic_vector(pixel_column - 512)(4 downto 2);
						font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
					elsif ((pixel_column >= 464 and pixel_column < 496) and (pixel_row >= 12 and pixel_row < 44)) then
						char_address <= "000000"; 
						font_col <= std_logic_vector(pixel_column - 464)(4 downto 2);
						font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
					else
						char_address <= "100000"; -- Space
						font_col <= std_logic_vector(pixel_column)(3 downto 1);
						font_row <= std_logic_vector(pixel_row)(3 downto 1);
					end if;
				elsif (lives = 2) then
					if ((pixel_column >= 560 and pixel_column < 592) and (pixel_row >= 12 and pixel_row < 44)) then
						char_address <= "000000";
						font_col <= std_logic_vector(pixel_column - 560)(4 downto 2);
						font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
					elsif ((pixel_column >= 512 and pixel_column < 544) and (pixel_row >= 12 and pixel_row < 44)) then
						char_address <= "000000";
						font_col <= std_logic_vector(pixel_column - 512)(4 downto 2);
						font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
					else
						char_address <= "100000"; -- Space
						font_col <= std_logic_vector(pixel_column)(3 downto 1);
						font_row <= std_logic_vector(pixel_row)(3 downto 1);
					end if;
				elsif (lives = 1) then
					if ((pixel_column >= 560 and pixel_column < 592) and (pixel_row >= 12 and pixel_row < 44)) then
						char_address <= "000000";
						font_col <= std_logic_vector(pixel_column - 560)(4 downto 2);
						font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
					else
						char_address <= "100000"; -- Space
						font_col <= std_logic_vector(pixel_column)(3 downto 1);
						font_row <= std_logic_vector(pixel_row)(3 downto 1);
					end if;
				else
					char_address <= "100000"; -- Space
					font_col <= std_logic_vector(pixel_column)(3 downto 1);
					font_row <= std_logic_vector(pixel_row)(3 downto 1);
                end if;
				-- Set text_rgb only when rom_output is '1'
                if rom_output = '1' then
                    text_rgb <= "100"; -- White text
                    text_enable_temp <= '1'; -- Enable text
                else
                    text_enable_temp <= '0'; -- Disable text
                end if;
            end if;
        end process;

    -- Output text RGB if enabled, otherwise keep VGA output unchanged
    vga_rgb <= text_rgb when text_enable_temp = '1' and state = "01" else (others => 'Z');
    text_enable <= text_enable_temp when state = "01" else '0';

end architecture behavior;