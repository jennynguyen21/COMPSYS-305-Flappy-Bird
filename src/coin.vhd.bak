LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity coin is
    port (
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        start_x_pos: in std_logic_vector(9 downto 0);
        score : in integer range 0 to 99;
        lfsr_seed: in std_logic_vector(7 downto 0);
        start : in std_logic;
        reset : in std_logic;
        ball_y_pos: in std_logic_vector(9 downto 0);
        state: in std_logic_vector(1 downto 0);
        coin_rgb: OUT std_logic_vector(2 downto 0);
        coin_on: OUT std_logic;
        coin_collision : OUT std_logic
    );
end coin;

architecture Behavioral of coin is

    component lfsr is
    port (
        clock: in std_logic;
        seed: in std_logic_vector(7 downto 0);
        lfsr_out: out std_logic_vector(7 downto 0)
    );
    end component;

    constant coin_size: integer := 12; -- Assuming the coin size is 10x10 pixels

    signal coin_x_position: std_logic_vector(9 downto 0);
    signal coin_y_position: std_logic_vector(9 downto 0);
    signal coin_on_temp: std_logic;

    signal lfsr_clk: std_logic;
    signal lfsr_out: std_logic_vector(7 downto 0);

    signal coin_x_motion: std_logic_vector(9 downto 0);
    signal collision_detected : std_logic;
	signal collision_flag : std_logic := '0';
	
    -- Coin pattern as a 2D array of std_logic
    TYPE coin_pattern_type IS ARRAY(0 TO 11) OF std_logic_vector(11 DOWNTO 0);
    CONSTANT coin_pattern : coin_pattern_type := (
        "000011110000",
        "001111111100",
        "011111111110",
        "011111111110",
        "111111111111",
        "111111111111",
        "111111111111",
        "111111111111",
        "011111111110",
        "011111111110",
        "001111111100",
        "000011110000"
    );
begin

    random_number: lfsr 
    port map (
        clock => lfsr_clk,
        seed => lfsr_seed,
        lfsr_out => lfsr_out
    );

    -- Determine coin position
	-- Determine coin's vertical position using LFSR and ensure it remains within a valid range
    coin_y_position <= std_logic_vector(to_unsigned(16, 10) + (unsigned(lfsr_out) mod to_unsigned(464 - coin_size, 10)));

    coin_on_temp <= '1' when (
        unsigned(pixel_column) >= unsigned(coin_x_position) - to_unsigned(coin_size, 10) and
        unsigned(pixel_column) < unsigned(coin_x_position) and
        unsigned(pixel_row) >= unsigned(coin_y_position) and
        unsigned(pixel_row) < unsigned(coin_y_position) + to_unsigned(coin_size, 10) and
        coin_pattern(to_integer(unsigned(pixel_row) - unsigned(coin_y_position)))(to_integer(unsigned(pixel_column) - (unsigned(coin_x_position) - to_unsigned(coin_size, 10)))) = '1' 
        and collision_flag = '0'
    ) else '0';

    coin_rgb <= "110" when coin_on_temp = '1' else "000";
    coin_on <= coin_on_temp;

    -- Determine the speed of the pipes based on the score
    coin_x_motion <= std_logic_vector(to_unsigned(2, 10)) when state = "01" else
                     std_logic_vector(to_unsigned(2, 10)) when score <= 10 and state = "10" else
                     std_logic_vector(to_unsigned(4, 10)) when score > 10 and score <= 20 and state = "10" else
                     std_logic_vector(to_unsigned(6, 10)) when score > 20 and state = "10" else
                     std_logic_vector(to_unsigned(2, 10)); 

    move_coin: process(vert_sync, reset)
    begin
        if reset = '1' then
            coin_x_position <= start_x_pos;
            lfsr_clk <= '1';
            collision_detected <= '0';
			collision_flag <= '0';

        elsif rising_edge(vert_sync) then

            if start = '1' and state /= "11" and state /= "00" then
                -- Move the coin to the left
                if to_integer(unsigned(coin_x_position)) - coin_size <= 0 then
                    coin_x_position <= std_logic_vector(to_unsigned(652, 10)); -- reset the coin position
                    lfsr_clk <= '1';
					collision_detected <= '0';
					collision_flag <= '0';
                else
                    coin_x_position <= std_logic_vector(unsigned(coin_x_position) - unsigned(coin_x_motion)); -- Move the coin
                    lfsr_clk <= '0';
                end if;

                -- Check for collision with coin
                if (unsigned(coin_x_position) <= to_unsigned(328, 10) and
                    unsigned(coin_x_position) + to_unsigned(coin_size, 10) >= to_unsigned(312, 10)) then
                    -- Check for y-coordinate collision
                    if (unsigned(ball_y_pos) + to_unsigned(8, 10) >= unsigned(coin_y_position) and
                        unsigned(ball_y_pos) - to_unsigned(8, 10) <= unsigned(coin_y_position) + to_unsigned(coin_size, 10)) then
						if (collision_flag = '0') then
							collision_detected <= '1';  -- collision with coin
							collision_flag <= '1';
						else
							collision_detected <= '0';
						end if;
                    else
                        collision_detected <= '0';  -- no collision
                    end if;

                else
                    collision_detected <= '0';  -- no collision
                end if;
            end if;
        end if;
    end process;

    coin_collision <= collision_flag;

end Behavioral;
