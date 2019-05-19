library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------
--    Registrador Tipo D 8bits     --
-------------------------------------

entity reg_5bits is
    Port ( d : in  STD_LOGIC_VECTOR (4 downto 0);
           q : out  STD_LOGIC_VECTOR (4 downto 0);
           load, incCol, incRow : in  STD_LOGIC;
           clk, reset : in  STD_LOGIC);
end reg_5bits;
architecture Behavioral of reg_5bits is
	signal value : STD_LOGIC_VECTOR(4 downto 0);
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			value <= "00000";
		elsif (rising_edge(clk)) then
			if (load = '1') then
				value <= d;
			elsif (incCol = '1') then
				value <= std_logic_vector(unsigned(value) + 1);
			elsif (incRow = '1') then
				value <= std_logic_vector(unsigned(value) + 3);
			end if;
		end if;
	end process;
	q <= value;
end Behavioral;

