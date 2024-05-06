LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( pb1, pb2, clk, vert_sync, left_click	: IN std_logic;
          pixel_row, pixel_column				: IN std_logic_vector(9 DOWNTO 0);
		  ball_rgb						        : OUT std_logic_vector(2 DOWNTO 0);	
		  ball_on						        : OUT std_logic);	
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL ball_on_temp				: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(320,11); -- 320 is the centre of the screen

ball_on_temp <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
--Red <=  pb1;
--Green <= (not pb2) and (not ball_on);
--Blue <=  not ball_on;

ball_rgb(2) <= pb1;  -- Red component controlled by pb1
ball_rgb(1) <= (not pb2) and (not ball_on_temp);  -- Green component controlled by pb2 and not ball_on
ball_rgb(0) <= not ball_on_temp;  -- Blue component controlled by not ball_on

ball_on <= ball_on_temp;

Move_Ball: process (vert_sync)  	
begin
	-- Move ball once every vertical sync
	if (rising_edge(vert_sync)) then

		if left_click = '1' then

			-- check if ball is not at the top of the screen
			if (ball_y_pos >= size) then
				-- move ball upwards
				ball_y_motion <= - CONV_STD_LOGIC_VECTOR(10,10);
			else
				-- don't move 
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			end if;

		else
			-- check if ball is not at the bottom of the screen
			if ( ball_y_pos <= CONV_STD_LOGIC_VECTOR(479,10) - size) then
				-- move ball downwards (apply gravity)
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			else 
				-- don't move
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			end if;
			
		end if;	
		
		-- Bounce off top or bottom of the screen
		--if ( ('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size) ) then
			--ball_y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
		--elsif (ball_y_pos <= size) then 
			--ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
		--end if;

		-- Compute next ball Y position
		ball_y_pos <= ball_y_pos + ball_y_motion;
	end if;
end process Move_Ball;

END behavior;

