library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clouds is
    port (
        clock: in  std_logic;
        pixel_column, pixel_row: in unsigned (9 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0)
    );
end entity clouds;

architecture behavior of clouds is
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
				if ((pixel_column >= 60 and pixel_column < 124) and (pixel_row >= 114 and pixel_row < 178)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 60)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 114)(5 downto 3);
				elsif ((pixel_column >= 80 and pixel_column < 144) and (pixel_row >= 394 and pixel_row < 458)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 80)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 394)(5 downto 3);
				elsif ((pixel_column >= 448 and pixel_column < 512) and (pixel_row >= 384 and pixel_row < 448)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 448)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 384)(5 downto 3);
				
				
				elsif ((pixel_column >= 366 and pixel_column < 430) and (pixel_row >= 50 and pixel_row < 114)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 366)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 50)(5 downto 3);
				
				

				elsif ((pixel_column >= 512 and pixel_column < 576) and (pixel_row >= 194 and pixel_row < 258)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 512)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 194)(5 downto 3);
				
				
				
				elsif ((pixel_column >= 192 and pixel_column < 256) and (pixel_row >= 300 and pixel_row < 364)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 192)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 300)(5 downto 3);
				elsif ((pixel_column >= 320 and pixel_column < 384) and (pixel_row >= 256 and pixel_row < 320)) then
					char_address <= "101100";
					font_col <= std_logic_vector(pixel_column - 320)(5 downto 3);
					font_row <= std_logic_vector(pixel_row - 256)(5 downto 3);

					
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