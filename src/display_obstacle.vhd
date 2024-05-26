LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

ENTITY display_obstacle is
    port(
        clock : in std_logic;
        vert_sync : in std_logic;
        pixel_row, pixel_column: in std_logic_vector(9 downto 0);
        start : in std_logic;
        reset : in std_logic;
        ball_y_pos: in std_logic_vector(9 downto 0);
        state: in std_logic_vector(1 downto 0);
        score_in : in integer range 0 to 99;
        rgb_output : out std_logic_vector(2 downto 0);
        pipe_on: out std_logic;
        score_track: out std_logic;
        collision: out std_logic;
        coin_collision: OUT std_logic
    );
END display_obstacle;

architecture Behavioral of display_obstacle is

    component pipes
        port(
            vert_sync : in std_logic;
            pixel_row, pixel_column : in std_logic_vector(9 downto 0);
            start_x_pos: in std_logic_vector(9 downto 0);
            score: in integer range 0 to 99;
            lfsr_seed: in std_logic_vector(7 downto 0);
            start : in std_logic;
            reset : in std_logic;
            ball_y_pos: in std_logic_vector(9 downto 0);
            state: in std_logic_vector(1 downto 0);
            pipes_rgb: OUT std_logic_vector(2 downto 0);
            pipe_on: OUT std_logic;
            score_track: OUT std_logic;
            collision: OUT std_logic
        );
    end component;

    component coin
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
    end component;


    signal pipe_on_1, pipe_on_2: std_logic;
    signal pipe_1_rgb, pipe_2_rgb: std_logic_vector(2 downto 0);
    signal pipes_detected: std_logic;
    signal score_track_1, score_track_2: std_logic;
    signal collision_1, collision_2: std_logic;
    signal coin_on: std_logic;
    signal coin_rgb: std_logic_vector(2 downto 0);
    signal coin_hit: std_logic;

    begin

    pipes1: pipes
    port map(
        vert_sync => vert_sync,
        pixel_row => pixel_row,
        pixel_column => pixel_column,
        start_x_pos => std_logic_vector(to_unsigned(700, 10)),
        score => score_in,
        lfsr_seed => "10101010",
        start => start,
        reset => reset,
        ball_y_pos => ball_y_pos,
        state => state,
        pipes_rgb => pipe_1_rgb,
        pipe_on => pipe_on_1,
        score_track => score_track_1,
        collision => collision_1
    );

    pipes2: pipes
    port map(
        vert_sync => vert_sync,
        pixel_row => pixel_row,
        pixel_column => pixel_column,
        start_x_pos => std_logic_vector(to_unsigned(1020, 10)),
        score => score_in,
        lfsr_seed => "01010101",
        start => start,
        reset => reset,
        ball_y_pos => ball_y_pos,
        state => state,
        pipes_rgb => pipe_2_rgb,
        pipe_on => pipe_on_2,
        score_track => score_track_2,
        collision => collision_2
    );

    shiny_coin: coin
    port map(
        vert_sync => vert_sync,
        pixel_row => pixel_row,
        pixel_column => pixel_column,
        start_x_pos => std_logic_vector(to_unsigned(830, 10)),
        lfsr_seed => "11001100",
        start => start,
        reset => reset,
        ball_y_pos => ball_y_pos,
        state => state,
        coin_rgb => coin_rgb,
        coin_on => coin_on,
        coin_collision => coin_hit
    );

    pipes_detected <= pipe_on_1 or pipe_on_2;
    score_track <= score_track_1 or score_track_2;
    coin_collision <= coin_hit;
    collision <= collision_1 or collision_2;

    process(clock)
    begin
        if rising_edge(clock) then
            if coin_on = '1' then
                rgb_output <= coin_rgb;
                pipe_on <= '1';
            elsif pipes_detected = '1' then
                rgb_output <= pipe_1_rgb or pipe_2_rgb; 
                pipe_on <= '1';
            else
                rgb_output <= "000";  
                pipe_on <= '0';
            end if;
        end if;

 end process;

end Behavioral;
