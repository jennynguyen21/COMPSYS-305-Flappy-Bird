LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity pipes is
    port (
        vert_sync : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        pipes_rgb: OUT std_logic_vector(2 downto 0);
        pipe_on: OUT std_logic
    );
end pipes;

architecture Behavioral of pipes is

    component lfsr is
    port (
        clock: in std_logic;
        lfsr_out: out std_logic_vector(7 downto 0)
    );
    end component;


    constant pipe_width: integer := 60;
    constant pipe_height: integer := 150;
    constant pipe_spacing: integer := 140;

    signal pipe_x: std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(400, 10));
    signal pipe_x_motion: std_logic_vector(9 downto 0);
    signal pipe_gap: std_logic_vector(7 downto 0);

    signal lfsr_clk: std_logic;

    signal pipe_on_temp: std_logic;

begin

    random_number: lfsr 
    port map (
        clock => lfsr_clk,
        lfsr_out => pipe_gap
    );


    -- pipe_on_temp <= '1' when (
    --     unsigned(pixel_column) >= unsigned(pipe_x) and
    --     unsigned(pixel_column) < unsigned(pipe_x) + to_unsigned(pipe_width, 10) and
    --     (unsigned(pixel_row) < to_unsigned(240 - pipe_gap / 2, 10) or
    --      unsigned(pixel_row) > to_unsigned(240 + pipe_gap / 2, 10))
    -- ) else '0';

        pipe_on_temp <= '1' when (
        unsigned(pixel_column) >= unsigned(pipe_x) and
        unsigned(pixel_column) < unsigned(pipe_x) + to_unsigned(pipe_width, 10) and
        (unsigned(pixel_row) < to_unsigned(240 - (to_integer(unsigned(pipe_gap)) / 2), 10) or
        unsigned(pixel_row) > to_unsigned(240 + (to_integer(unsigned(pipe_gap)) / 2), 10))
    ) else '0';

    pipes_rgb <= "010" when pipe_on_temp = '1' else "000";
    pipe_on <= pipe_on_temp;

    move_pipe: process(vert_sync)
    begin
        if rising_edge(vert_sync) then

            if to_integer(unsigned(pipe_x)) > 0 then
                pipe_x_motion <= std_logic_vector(to_unsigned(4, 10)); 
                pipe_x <= std_logic_vector(unsigned(pipe_x) - unsigned(pipe_x_motion));
                lfsr_clk <= '0';
            else
                pipe_x <= std_logic_vector(to_unsigned(640, 10)); 
                lfsr_clk <= '1';
            end if;
        end if;
    end process;

end Behavioral;