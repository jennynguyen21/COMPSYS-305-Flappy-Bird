LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity coin is
    port (
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        start_x_pos: in std_logic_vector(9 downto 0);
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

    constant coin_size: integer := 10; -- Assuming the coin size is 10x10 pixels

    signal coin_x_position: std_logic_vector(9 downto 0);
    signal coin_y_position: std_logic_vector(9 downto 0);
    signal coin_on_temp: std_logic;

    signal lfsr_clk: std_logic;
    signal lfsr_out: std_logic_vector(7 downto 0);

    signal coin_x_motion: std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(2, 10));
    signal collision_detected : std_logic;
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
        unsigned(pixel_column) >= unsigned(coin_x_position) and
        unsigned(pixel_column) < unsigned(coin_x_position) + to_unsigned(coin_size, 10) and
        unsigned(pixel_row) >= unsigned(coin_y_position) and
        unsigned(pixel_row) < unsigned(coin_y_position) + to_unsigned(coin_size, 10)
    ) else '0';

    coin_rgb <= "100" when coin_on_temp = '1' else "000";
    coin_on <= coin_on_temp;

    move_coin: process(vert_sync, reset)
    begin
        if reset = '1' then
            coin_x_position <= start_x_pos;
            lfsr_clk <= '1';
            collision_detected <= '0';

        elsif rising_edge(vert_sync) then

            if start = '1' and state /= "11" and state /= "00" then
                -- Move the coin to the left
                if to_integer(unsigned(coin_x_position)) - to_integer(unsigned(coin_x_motion)) <= 0 then
                    coin_x_position <= std_logic_vector(to_unsigned(650, 10)); -- reset the coin position
                    lfsr_clk <= '1';
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
                        collision_detected <= '1';  -- collision with coin
								--coin_on_temp <= '0';
                    else
                        collision_detected <= '0';  -- no collision
						--coin_on_temp <= '1';
                    end if;

                else
                    collision_detected <= '0';  -- no collision
					--coin_on_temp <= '1';
                end if;
            end if;
        end if;
    end process;

    coin_collision <= collision_detected;

end Behavioral;