LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity pipes is
    port (
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        start_x_pos: in std_logic_vector(9 downto 0);
        lfsr_seed: in std_logic_vector(7 downto 0);
        start : in std_logic;
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
    constant pipe_gap: integer := 80;

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

    move_pipe: process(vert_sync)
    begin
        if rising_edge(vert_sync) then

            if start = '0' then
                pipe_x_position <= start_x_pos;
                --start <= '0';
            else
                if state /= "11" then 
                        -- Check for collision based on hardcoded ball x-position range (312 to 328)
                    if (unsigned(pipe_x_position) - to_unsigned(pipe_width, 10) <= to_unsigned(328, 10) and
                    unsigned(pipe_x_position) >= to_unsigned(312, 10)) then
                    
                        -- Check for y-coordinate collision
                        if (unsigned(ball_y_pos) <= unsigned(pipe_gap_center) - to_unsigned((pipe_gap / 2), 10) or
                            unsigned(ball_y_pos) >= unsigned(pipe_gap_center) + to_unsigned((pipe_gap / 2), 10)) then
                            collision_detected <= '1';
                        else
                            collision_detected <= '0';
                        end if;
                    else
                        collision_detected <= '0';
                        
                        if to_integer(unsigned(pipe_x_position)) > 0 then
                            pipe_x_motion <= std_logic_vector(to_unsigned(4, 10)); 
                            pipe_x_position <= std_logic_vector(unsigned(pipe_x_position) - unsigned(pipe_x_motion));
                            lfsr_clk <= '0';
                        else
                            pipe_x_position <= std_logic_vector(to_unsigned(700, 10)); 
                            lfsr_clk <= '1';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    collision <= collision_detected;

end Behavioral;