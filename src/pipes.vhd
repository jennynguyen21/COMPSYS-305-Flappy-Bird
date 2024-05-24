LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity pipes is
    port (
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        start_x_pos: in std_logic_vector(9 downto 0);
        score: in integer range 0 to 99;
        --x_speed: in std_logic_vector(9 downto 0);
        lfsr_seed: in std_logic_vector(7 downto 0);
        start : in std_logic;
        reset : in std_logic;
        ball_y_pos: in std_logic_vector(9 downto 0);
        state: in std_logic_vector(1 downto 0);
        pipes_rgb: OUT std_logic_vector(2 downto 0);
        pipe_on: OUT std_logic;
        score_track: OUT std_logic;
        collision : OUT std_logic
    );
end pipes;

architecture Behavioral of pipes is

    component lfsr is
    port (
        clock: in std_logic;
        seed: in std_logic_vector(7 downto 0);
        lfsr_out: out std_logic_vector(7 downto 0)
    );
    end component;


    constant pipe_width: integer := 60;
    constant pipe_gap: integer := 140;

    signal pipe_x_position: std_logic_vector(9 downto 0);
    signal pipe_x_motion: std_logic_vector(9 downto 0);
    signal pipe_gap_center: std_logic_vector(9 downto 0);
    signal pipe_on_temp: std_logic;

    signal lfsr_clk: std_logic;
    signal lfsr_out: std_logic_vector(7 downto 0);

    signal top_pipe_end : std_logic_vector(9 downto 0);
    signal bottom_pipe_start : std_logic_vector(9 downto 0);

    signal collision_detected : std_logic;
    

begin

    random_number: lfsr 
    port map (
        clock => lfsr_clk,
        seed => lfsr_seed,
        lfsr_out => lfsr_out
    );

    pipe_gap_center <= std_logic_vector(to_signed(248, 10) + signed(lfsr_out));

        pipe_on_temp <= '1' when (
        unsigned(pixel_column) > unsigned(pipe_x_position) - to_unsigned(pipe_width, 10)and
        unsigned(pixel_column) < unsigned(pipe_x_position) and
        (unsigned(pixel_row) < unsigned(pipe_gap_center) - to_unsigned((pipe_gap / 2), 10) or
        unsigned(pixel_row) >  unsigned(pipe_gap_center) + to_unsigned((pipe_gap / 2), 10))
    ) else '0';

    -- Determine the top and bottom boundaries of the pipes
    top_pipe_end <= std_logic_vector(unsigned(pipe_gap_center) - to_unsigned((pipe_gap / 2), 10));
    bottom_pipe_start <= std_logic_vector(unsigned(pipe_gap_center) + to_unsigned((pipe_gap / 2), 10));

    score_track <= '1' when ((unsigned(pipe_x_position) <= 310) and (unsigned(pipe_x_position) >= 250)) else '0';

    pipes_rgb <= "010" when pipe_on_temp = '1' else "000";
    pipe_on <= pipe_on_temp;

    -- determine the speed of the pipes based on the score
    pipe_x_motion <= std_logic_vector(to_unsigned(2, 10)) when state = "01" else
                     std_logic_vector(to_unsigned(2, 10)) when score <= 10 and state = "10" else
                     std_logic_vector(to_unsigned(4, 10)) when score > 10 and score <= 20 and state = "10" else
                     std_logic_vector(to_unsigned(6, 10)) when score > 20 and state = "10" else
                     std_logic_vector(to_unsigned(2, 10)); 

    move_pipe: process(vert_sync, reset)
    begin
        if reset = '1' then
            pipe_x_position <= start_x_pos;
            lfsr_clk <= '1';
            collision_detected <= '0';

        elsif rising_edge(vert_sync) then

            if start = '1' and state /= "11" and state /= "00" then

                if to_integer(unsigned(pipe_x_position)) - to_integer(unsigned(pipe_x_motion)) <= 0 then
                    pipe_x_position <= std_logic_vector(to_unsigned(700, 10)); -- reset the pipe
                    lfsr_clk <= '1';
                else
                    pipe_x_position <= std_logic_vector(unsigned(pipe_x_position) - unsigned(pipe_x_motion)); -- move the pipe
                    lfsr_clk <= '0';
                end if;

               -- check for x-coordinate collision
                if (unsigned(pipe_x_position) - to_unsigned(pipe_width, 10) <= to_unsigned(328, 10) and
                unsigned(pipe_x_position) >= to_unsigned(312, 10)) then

                    -- check for y-coordinate collision
                    if (unsigned(ball_y_pos) + to_unsigned(8, 10) >= unsigned(pipe_gap_center) - to_unsigned((pipe_gap / 2), 10) and
                        unsigned(ball_y_pos) - to_unsigned(8, 10) <= unsigned(pipe_gap_center) + to_unsigned((pipe_gap / 2), 10)) then
                        collision_detected <= '0';  -- no collision when the bird is within the gap
                    else
                        collision_detected <= '0';  -- collision if outside the gap
                    end if;

                else
                    collision_detected <= '0';  -- no collision if the pipe is outside the x range of the bird
                end if;
            end if;
        end if;
    end process;

    collision <= collision_detected;

end Behavioral;