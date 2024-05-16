LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity lfsr is
    port (
        clock: in std_logic;
        seed: in std_logic_vector(7 downto 0);
        lfsr_out: out std_logic_vector(7 downto 0)
    );
end lfsr;

architecture Behavioral of lfsr is
    signal lfsr_reg: std_logic_vector(7 downto 0);
    signal reset: std_logic := '1';

begin

    process(clock)
    begin 
        if rising_edge(clock) then 
            if reset = '1' then
                lfsr_reg <= seed;
                reset <= '0';
            else
                -- shift with taps at 1, 2, 3 and 7
                lfsr_reg(7) <= lfsr_reg(6);
                lfsr_reg(6) <= lfsr_reg(5);
                lfsr_reg(5) <= lfsr_reg(4);
                lfsr_reg(4) <= lfsr_reg(3) xor lfsr_reg(7);
                lfsr_reg(3) <= lfsr_reg(2) xor lfsr_reg(7);
                lfsr_reg(2) <= lfsr_reg(1) xor lfsr_reg(7);
                lfsr_reg(1) <= lfsr_reg(0);
                lfsr_reg(0) <= lfsr_reg(7);
           end if;
        end if;
    end process;

    lfsr_out <= lfsr_reg;

end Behavioral;
    