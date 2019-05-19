library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------
-- Contador Bidirecional de 8 bits --
--             0 - 255              --
-------------------------------------

entity updown_counter_8bits is
    Port ( up_down, enable, clk, reset : in  STD_LOGIC;
           count : out  std_logic_vector(7 downto 0));
end updown_counter_8bits;

architecture Behavioral of updown_counter_8bits is
	signal temp_count : unsigned(7 downto 0); 
begin
	process (clk, reset, up_down, enable)
	begin
		if (reset = '1') then
			temp_count <= "00000000";
		elsif (rising_edge(clk) and enable='1') then
			if(up_down = '1') then
				temp_count <= temp_count + 1;
			else
				temp_count <= temp_count - 1;
			end if;
		else
			temp_count <= temp_count;
		end if;
	end process;
	count <= std_logic_vector(temp_count);
end Behavioral;

