library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port (
        clk : in std_logic;
        reset : in std_logic;
        pb2, pb3: in std_logic;
        collision : in std_logic;
        state_out : out std_logic_vector(1 downto 0)
    );
end entity fsm;

architecture Behavioral of fsm is
    type state_type is (start_game, training_mode, normal_mode, game_over);
    signal current_state, next_state : state_type;
begin
    
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= start_game;  -- reset to initial state
        elsif rising_edge(clk) then
            current_state <= next_state; -- transition to next state on clock edge
        end if;
    end process;

    -- next state logic process
    process(current_state, pb2, pb3, collision)
    begin
        case current_state is
            when start_game =>
                if pb3 = '0' then
                    next_state <= training_mode; -- Go to training mode if pb1 is pressed
                               
                elsif pb2 = '0' then
                    next_state <= normal_mode;   -- Go to normal mode if pb2 is pressed
                    
                else
                    next_state <= start_game;    -- Stay in start_game if no button is pressed
                end if;
            
            when training_mode =>
                if collision = '1' then
                    next_state <= game_over;       -- Go to game over if collision is detected
                else
                    next_state <= training_mode;  -- stay in training mode
                end if;

            when normal_mode =>
                if collision = '1' then
                    next_state <= game_over;       -- Go to game over if collision is detected
                else
                    next_state <= normal_mode;     -- stay in normal mode
                end if;
        
            when game_over =>
                next_state <= game_over;       -- stay in game over
                
            when others =>
                next_state <= start_game;      -- default to start game 
            
        end case;
    end process;

    with current_state select
        state_out <= "00" when start_game,
                     "01" when training_mode,
                     "10" when normal_mode,
                     "11" when game_over,
                     "00" when others;

end architecture Behavioral;