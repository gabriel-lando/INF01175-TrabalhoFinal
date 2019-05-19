library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity somador_serial is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clear, add : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           sum_out : out  STD_LOGIC_VECTOR (9 downto 0));
end somador_serial;

architecture Behavioral of somador_serial is
	signal acum : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
begin
	process(clk, rst)
	begin
		if (rst='1') then
			acum <= "0000000000";
		elsif (rising_edge(clk)) then
			if (add='1') then
				acum <= STD_LOGIC_VECTOR(unsigned(acum) + unsigned(data_in));
			elsif (clear='1') then
				acum <= "0000000000";
			end if;
		end if;
	end process;
	sum_out <= acum;
end Behavioral;

