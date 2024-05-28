# COMPSYS 305 Flappy Bird

> This project is a FPGA implementation of the game 'Flappy Bird' designed to run on the DE0-CV development board. The game can be controlled using a PS/2 mouse, push buttons and DIP switches. <br /> <br />
**Developed by [Jenny Nguyen](https://github.com/jennynguyen21) and [Shriya Singh](https://github.com/Shriya1412)**

**Links**
- [Interim Report](https://github.com/jennynguyen21/COMPSYS-305-Flappy-Bird/blob/main/Reports/Interim%20Report%20305.pdf)
- [Final Report](https://github.com/jennynguyen21/COMPSYS-305-Flappy-Bird/blob/main/Reports/Final%20Report%20Group%2031.pdf)
- [Demo Video (Training Mode)](https://drive.google.com/file/d/1jYVwMOJ9YdlFLSu5h5TBkCPDIYh8WJsR/view?usp=sharing)
- [Demo Video (Normal Mode)](https://drive.google.com/file/d/1jfphk8Mr5JCZgXV5PIauMuIcFl37WOtk/view?usp=sharing)

## Game Description 
The Flappy Bird game is implemented on an Altera Cyclone V FPGA, included with the DE0-CV development board. A PS/2 mouse interfaces with the FPGA to allow user control of the bird. The FPGA generates a 640x480 pixel Video Graphics Array (VGA) output signal for displaying the game. Flappy Bird is rendition of the classic side-scroller video game where the player navigates the bird to fly between the gaps in the pipes, avoiding collisions. 

### Controls
- **PS/2 Mouse:**
  - The `PS/2` mouse is used to control the bird, making it move upwards with every left click
- **Push Buttons:**
  - `KEY3` and `KEY2` are used in the menu selection
  - `KEY1` is used to reset the game
- **DIP Switches:**
  - `SW2`, `SW1` and `SW0` can be used to change the color of the background
  - `SW9` can be used to turn the clouds on/off
- **Seven Segment Display**
  - The score of the game can be seen on the seven segement display (it can also be seen on the display as well)

### Game Modes
- **Training Mode**
  - In TRAINING Mode, the bird has three lives, which are displayed at the top right of the screen. These are decremented each time the bird collides with the pipes until the bird has no remaining lives left, in which case the game is over. In the case it collides with the ground, the game is over regardless of the number of lives the player has
  - In TRAINING Mode, the game remains at `Level 1` for the entire duration and does not progress based on the score
- **Normal Mode**
  - In NORMAL Mode, the user has a traditional flappy bird experience. The player has a single life and the game ends if there is collision between the pipes or the ground
  - NORMAL Mode has 3 levels which increase in proportion to the score accrued. Every 10 points the level of the game increases (up to `Level 3`), the speed of the pipes and coins increase by a constant amount to create difficulty in the game. The level of the game can be seen at the bottom left of the screen. 

 ### Power Ups
 - **Coins**
   - Players can collect coins during the gameplay to increase their score. Each coin collected adds 2 points to the score, compared to the 1 point earned by passing through pipes
## Game Play Images
<br/>
<p float="left">
    <img src="Gameplay Images/Menu_screen.jpg" width="500", height="350">
   <img src="Gameplay Images/Bird_Hovering.jpg" width="500", height="350">
</p>
<p float="left">
    <img src="Gameplay Images/Training_Mode.jpg" width="500", height="350">
   <img src="Gameplay Images/Normal_mode_game_over.jpg" width="500", height="350">
</p>


## Technologies Used 
- `Quartus Prime 18.1` : Used for designing block diagrams and creating custom components using BDFs and BSFs, compling the code and programming the DE0-CV board, among other functions
- `VHDL` : The hardware description language used to code the application
