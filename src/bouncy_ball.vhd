LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( pb1, clk, vert_sync, left_click	: IN std_logic;
          pixel_row, pixel_column				: IN std_logic_vector(9 DOWNTO 0);
		  state									: IN std_logic_vector(1 DOWNTO 0);	
		  reset									: IN std_logic;
		  ball_rgb						        : OUT std_logic_vector(2 DOWNTO 0);	
		  ball_on						        : OUT std_logic;
		  start									: OUT std_logic;
		  ball_y_pos_out 						: OUT std_logic_vector(9 DOWNTO 0);
		  ground_collision 						: OUT std_logic
		  );
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL ball_on_temp				: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(240,10); -- start at the centre of the screen
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);
SIGNAL left_click_prev 			: std_logic := '0';
SIGNAL start_game 				: std_logic := '0';

-- Coin pattern as a 2D array of std_logic
TYPE bird_pattern_type IS ARRAY(0 TO 19) OF std_logic_vector(19 DOWNTO 0);
CONSTANT bird_pattern : bird_pattern_type := (
	"00000000001111110000", 
	"00000000011111111000", 
	"00000000110000000100", 
	"11111100110001100100", 
	"11111110110001100100", 
	"01111111110000000111", 
	"00111111110000000110", 
	"00011111110000011000", 
	"00011111111111110000", 
	"00001111111111110000", 
	"00000111111111110000", 
	"00000011111111110000", 
	"00000011111111110000", 
	"00000011111111110000", 
	"00000011111111110000", 
	"00000011111111100000", 
	"00001111111111100000", 
	"00001111111111100000", 
	"00001111000000000000", 
	"00001111000000000000"

);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(10,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(320,11); -- 320 is the centre of the screen

ball_on_temp <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size - CONV_STD_LOGIC_VECTOR(1,10)) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) -- y_pos - size <= pixel_row <= y_pos + size
					and (state = "01" or state ="10" or state = "11" ) and 
					bird_pattern(CONV_INTEGER(pixel_row) - (CONV_INTEGER(ball_y_pos) - 10))((CONV_INTEGER(not pixel_column)) - (CONV_INTEGER(ball_x_pos) - 10)) = '1')
					else '0';

ball_rgb(2) <= '0';
ball_rgb(1) <= '0';
ball_rgb(0) <= '0';

ball_on <= ball_on_temp;

Move_Ball: process (vert_sync, reset)  	
begin
	if reset = '1' then
		ball_y_pos <= CONV_STD_LOGIC_VECTOR(240,10);
		ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
		start_game <= '0';
		ground_collision <= '0';
	
	-- Move ball once every vertical sync
	elsif (rising_edge(vert_sync)) then

		-- check if left click is pressed and left click was not pressed in the previous cycle (prevents holding down the button to move the ball continuously)
		if left_click = '1' and left_click_prev = '0' and state /= "11" then
			start_game <= '1';

			-- check if ball is not at the top of the screen
			if (ball_y_pos >= size) then
				-- move ball upwards
				ball_y_motion <= - CONV_STD_LOGIC_VECTOR(60,10);
			else
				-- don't move 
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			end if;

		else -- if left click is not pressed
			if (start_game = '1') then -- game must be started for the ball to fall
			
				-- check if ball is not at the bottom of the screen
				if ( ball_y_pos <= CONV_STD_LOGIC_VECTOR(479,10) - size) then
					-- move ball downwards (apply gravity)
					ball_y_motion <= CONV_STD_LOGIC_VECTOR(4,10);
				else 
					-- don't move
					ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
					ground_collision <= '1';
				end if;
			end if;
		end if;	

		-- update left_click_prev value
		left_click_prev <= left_click;

		-- Compute next ball Y position
		ball_y_pos <= ball_y_pos + ball_y_motion;
		ball_y_pos_out <= ball_y_pos;

	end if;
	start <= start_game;
end process Move_Ball;

END behavior;