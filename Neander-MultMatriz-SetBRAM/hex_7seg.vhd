library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hex_7seg is
    Port ( 	bcd_in				: in  STD_LOGIC_VECTOR (15 downto 0);
				dots			: in  STD_LOGIC_VECTOR (3 downto 0);
				clk, rst		: in  STD_LOGIC;
				display_out		: out  STD_LOGIC_VECTOR (3 downto 0);
				cath_out		: out  STD_LOGIC_VECTOR (7 downto 0)
			);
end hex_7seg;

architecture Behavioral of hex_7seg is
	signal clk_div  	: STD_LOGIC_VECTOR (18 downto 0);
	signal leds_out		: STD_LOGIC_VECTOR (7 downto 0);
	signal number	  	: STD_LOGIC_VECTOR (3 downto 0);

begin

	-- Divisor de CLK
	process (clk, rst)
	begin
		if (rst = '1') then
			clk_div <= (others => '0');
		elsif (rising_edge(clk)) then
			clk_div <= std_logic_vector(unsigned(clk_div) + 1);
		end if;
	end process;

	-- Maq. de Estados
	process (clk_div, dots, bcd_in)
	begin
		case clk_div(18 downto 17) is
			when "00" =>
				leds_out(0) <= not(dots(0));
				display_out <= "1110";
				number <= bcd_in(3 downto 0);
				
			when "01" =>
				leds_out(0) <= not(dots(1));
				display_out <= "1101";
				number <= bcd_in(7 downto 4);
			when "10" =>
				leds_out(0) <= not(dots(2));
				display_out <= "1011";
				number <= bcd_in(11 downto 8);
			when "11" =>
				leds_out(0) <= not(dots(3));
				display_out <= "0111";
				number <= bcd_in(15 downto 12);
			when others =>
				leds_out(0) <= '1';
				display_out <= "1111";
				number <= "0000";
		end case;
	end process;

	process (number)
	begin
		case number is
			when "0000" =>	--0
				leds_out (7 downto 1) <= "0000001";
			when "0001" =>	--1
				leds_out (7 downto 1) <= "1001111";
			when "0010" =>	--2
				leds_out (7 downto 1) <= "0010010";
			when "0011" =>	--3
				leds_out (7 downto 1) <= "0000110";
			when "0100" =>	--4
				leds_out (7 downto 1) <= "1001100";
			when "0101" =>	--5
				leds_out (7 downto 1) <= "0100100";
			when "0110" =>	--6
				leds_out (7 downto 1) <= "0100000";
			when "0111" =>	--7
				leds_out (7 downto 1) <= "0001111";
			when "1000" =>	--8
				leds_out (7 downto 1) <= "0000000";
			when "1001" =>	--9
				leds_out (7 downto 1) <= "0000100";
			when "1010" =>	--A
				leds_out (7 downto 1) <= "0001000";
			when "1011" =>	--B
				leds_out (7 downto 1) <= "1100000";
			when "1100" =>	--C
				leds_out (7 downto 1) <= "0110001";
			when "1101" =>	--D
				leds_out (7 downto 1) <= "1000010";
			when "1110" =>	--E
				leds_out (7 downto 1) <= "0110000";
			when "1111" =>	--F
				leds_out (7 downto 1) <= "0111000";
			when others =>
				leds_out (7 downto 1) <= "1111111";
		end case;
	end process;

	cath_out <= leds_out;

end Behavioral;

