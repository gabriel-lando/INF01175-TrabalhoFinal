----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:24:55 10/18/2018 
-- Design Name: 
-- Module Name:    ULA - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ULA is
    Port ( X : in  STD_LOGIC_VECTOR (7 downto 0);
           Y : in  STD_LOGIC_VECTOR (7 downto 0);
           selALU : in  STD_LOGIC_VECTOR (2 downto 0);
           NegF : out  STD_LOGIC;
           ZeroF : out  STD_LOGIC;
           result : out  STD_LOGIC_VECTOR (7 downto 0));
end ULA;

architecture Behavioral of ULA is

signal tmpResult : std_logic_vector(7 downto 0);
signal tmpMul : std_logic_vector(7 downto 0);

begin

	operations:	process(selALU,X,Y)
	begin
		tmpResult <= (others => '0');
		tmpMul <= (others => '0');
		--
		case selALU is
			-- ADD
			when "000" =>
				tmpResult <= std_logic_vector(signed(X) + signed(Y));
			-- AND 
			when "001" =>
				tmpResult <= X and Y;
			-- OR
			when "010" =>
				tmpResult <= X or Y;
			-- NOT
			when "011" =>
				tmpResult <= not(X);
			-- Y
			when "100" =>
				tmpResult <= Y;
			when "101" =>
				tmpResult <= std_logic_vector(signed(X) - signed(Y));
			when "110" =>
				tmpResult <= std_logic_vector(signed(X(3 downto 0)) * signed(Y(3 downto 0)));
			-- catch-all
			when others =>
				tmpResult <= "00001111";
		end case;
		
		if (tmpResult = "00000000") then
			ZeroF <= '1';
		else
			ZeroF <= '0';
		end if;
			
		NegF <= tmpResult(7);
		
	end process operations;
	
	
	result <= tmpResult;


end Behavioral;

