library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port (
        clk : in std_logic;
        reset : in std_logic;
        pb2, pb3: in std_logic;
        collision : in std_logic;
        state_out : out std_logic_vector(1 downto 0);
        reset_out : out std_logic;
        lives: out integer range 0 to 3
    );
end entity fsm;

architecture Behavioral of fsm is
    type state_type is (start_game, training_mode, normal_mode, game_over);
    signal current_state, next_state : state_type;
    signal life: integer range 0 to 3 := 3;
    signal collision_buffer: std_logic := '0';

begin

    lives <= life;
    
    -- sync_proc
    process(clk)
    begin
      if rising_edge(clk) then
        if reset = '0' then
            current_state <= start_game;
        else
            current_state <= next_state;
        end if;
      end if;
    end process;

    calculate_lives: process(clk, collision)
    begin
        if rising_edge(clk) then
            if reset = '0' then 
                life <= 3;
            elsif collision = '1' and collision_buffer = '0' then
                if life >= 1 then
                    life <= life - 1;
                end if;
            end if;
            collision_buffer <= collision;
        end if;
    end process calculate_lives;

    -- next_state_decode
    process(current_state, pb2, pb3, collision)
    begin
        case current_state is
			--Start Game mode
            when start_game =>

                next_state <= start_game;    -- Stay in start_game if no button is pressed

                if pb2 = '0' then
                    next_state <= training_mode; -- Go to training mode if pb1 is pressed
                               
                elsif pb3 = '0' then
                    next_state <= normal_mode;   -- Go to normal mode if pb2 is pressed
                end if;

			--Training Mode
            when training_mode =>
                    next_state <= training_mode;

                    if life = 0 then
                        next_state <= game_over;
                    end if;

			--Normal Game Mode
            when normal_mode =>
                next_state <= normal_mode;

                if collision = '1' then
                    next_state <= game_over;
                end if;

			--Game over Mode
            when game_over =>
                next_state <= game_over;      -- stay in game over
                
            when others =>
                next_state <= start_game;      -- default to start game 
            
        end case;
    end process;

    -- output_decode
    process(current_state)
    begin
        case(current_state) is
            when start_game =>
                reset_out <= '1';
                state_out <= "00";

            when training_mode =>
                reset_out <= '0';
                state_out <= "01";

            when normal_mode =>
                reset_out <= '0';
                state_out <= "10";

            when game_over =>
                state_out <= "11";
                reset_out <= '0';

            when others =>
                state_out <= "00";
                reset_out <= '1';
        end case;
    end process;

end architecture Behavioral;