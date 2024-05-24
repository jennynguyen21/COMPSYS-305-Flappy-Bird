library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score is
    port (
        clock: in  std_logic;
        score_track: in std_logic;
        pixel_column, pixel_row: in unsigned (9 downto 0);
        text_enable: out std_logic;
        vga_rgb: out std_logic_vector(2 downto 0);
        score_out: out integer range 0 to 99
    );
end entity score;

architecture behavior of score is
    signal char_address : std_logic_vector(5 downto 0);
    signal font_col, font_row : std_logic_vector(2 downto 0);
    signal rom_output : std_logic;
    signal text_rgb : std_logic_vector(2 downto 0);
    signal text_enable_temp : std_logic;
    signal ones : integer range 0 to 9;
    signal tens: integer range 0 to 9;
    signal score: integer range 0 to 99;
    signal last_score_track : std_logic := '0';
    
    type array_type is array (0 to 9) of std_logic_vector (5 downto 0);
    constant INIT_ARRAY : array_type := (
        "110000", "110001", "110010", "110011",
        "110100", "110101", "110110", "110111",
        "111000", "111001"
    );
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
            if rising_edge(clock) then 

                if (score_track = '1' and last_score_track = '0') then
                    score <= score + 1;
                end if;
                last_score_track <= score_track;  -- Update the last state
           
        
                ones <= (score mod 10);
                tens <= (score / 10);
        
                if ((pixel_column >= 208 and pixel_column < 240) and (pixel_row >= 12 and pixel_row < 44)) then
                    char_address <= MY_ARRAY(ones);
                    font_col <= std_logic_vector(pixel_column - 208)(4 downto 2);  -- Adjusted offset
                    font_row <= std_logic_vector(pixel_row - 12)(4 downto 2);
                elsif ((pixel_column >= 176 and pixel_column < 208) and (pixel_row >= 12 and pixel_row < 44)) then
                    char_address <= MY_ARRAY(tens);
                    font_col <= std_logic_vector(pixel_column - 176)(4 downto 2);  -- Adjusted offset
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

                score_out <= score;
            end if;
        end process;


    -- Output text RGB if enabled, otherwise keep VGA output unchanged
    vga_rgb <= text_rgb when text_enable_temp = '1' else (others => 'Z');
    text_enable <= text_enable_temp;

end architecture behavior;