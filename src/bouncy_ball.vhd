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

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(320,11); -- 320 is the centre of the screen

ball_on_temp <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) and (state = "01" or state ="10" or state = "11" ))  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';

ball_rgb(2) <= pb1;
ball_rgb(1) <= '1';
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
		if left_click = '1' and left_click_prev = '0' then
			start_game <= '1';

			-- check if ball is not at the top of the screen
			if (ball_y_pos >= size) then
				-- move ball upwards
				ball_y_motion <= - CONV_STD_LOGIC_VECTOR(40,10);
			else
				-- don't move 
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			end if;

		else -- if left click is not pressed
			if (start_game = '1') then -- game must be started for the ball to fall
			
				-- check if ball is not at the bottom of the screen
				if ( ball_y_pos <= CONV_STD_LOGIC_VECTOR(479,10) - size) then
					-- move ball downwards (apply gravity)
					ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
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

