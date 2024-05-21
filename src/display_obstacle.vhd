LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

ENTITY display_obstacle is
    port(
        clock : in std_logic;
        vert_sync : in std_logic;
        pixel_row, pixel_column: in std_logic_vector(9 downto 0);
        start : in std_logic;
        rgb_output : out std_logic_vector(2 downto 0);
        pipe_on: out std_logic;
        score_track: out std_logic
    );
END display_obstacle;

architecture Behavioral of display_obstacle is

    component pipes
        port(
            vert_sync : in std_logic;
            pixel_row, pixel_column : in std_logic_vector(9 downto 0);
            start_x_pos: in std_logic_vector(9 downto 0);
            lfsr_seed: in std_logic_vector(7 downto 0);
            start : in std_logic;
            pipes_rgb: OUT std_logic_vector(2 downto 0);
            pipe_on: OUT std_logic;
            score_track: OUT std_logic
        );
    end component;


    signal pipe_on_1, pipe_on_2: std_logic;
    signal pipe_1_rgb, pipe_2_rgb: std_logic_vector(2 downto 0);
    signal pipes_detected: std_logic;
    signal score_track_1, score_track_2: std_logic;

    begin

    pipes1: pipes
    port map(
        vert_sync => vert_sync,
        pixel_row => pixel_row,
        pixel_column => pixel_column,
        start_x_pos => std_logic_vector(to_unsigned(700, 10)),
        lfsr_seed => "10101010",
        start => start,
        pipes_rgb => pipe_1_rgb,
        pipe_on => pipe_on_1,
        score_track => score_track_1
        
    );

    pipes2: pipes
    port map(
        vert_sync => vert_sync,
        pixel_row => pixel_row,
        pixel_column => pixel_column,
        start_x_pos => std_logic_vector(to_unsigned(1020, 10)),
        lfsr_seed => "01010101",
        start => start,
        pipes_rgb => pipe_2_rgb,
        pipe_on => pipe_on_2,
        score_track => score_track_2
    );

    pipes_detected <= pipe_on_1 or pipe_on_2;
    score_track <= score_track_1 or score_track_2;

    process(clock)
    begin
        if rising_edge(clock) then
            if pipes_detected = '1' then
                rgb_output <= pipe_1_rgb or pipe_2_rgb; 
                pipe_on <= '1';
            else
                rgb_output <= "000";  
                pipe_on <= '0';
            end if;
        end if;

 end process;

end Behavioral;