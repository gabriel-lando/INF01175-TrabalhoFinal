----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:22:35 10/18/2018 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           inc : in  STD_LOGIC;
           load : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (7 downto 0);
           Q : out  STD_LOGIC_VECTOR (7 downto 0));
end PC;

architecture Behavioral of PC is

signal tmpCount : std_logic_vector(7 downto 0);

begin
	
	process(clk,rst)
	begin
		if (rst = '1') then
			tmpCount <= (others => '0');
		elsif (rising_edge(clk)) then
			if (load = '1') then
				tmpCount <= D;
			elsif (inc = '1') then
				tmpCount <= std_logic_vector(unsigned(tmpCount) + 1);
			end if;
		end if;
	end process;
	
	Q <= tmpCount;


end Behavioral;

