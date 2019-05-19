----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:51:49 12/18/2018 
-- Design Name: 
-- Module Name:    mult_4bits - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mult_4bits is
    Port ( inA : in  STD_LOGIC_VECTOR (3 downto 0);
           inB : in  STD_LOGIC_VECTOR (3 downto 0);
           clk, rst:  in  STD_LOGIC;
           result : out  STD_LOGIC_VECTOR (7 downto 0));
end mult_4bits;

architecture Behavioral of mult_4bits is

begin
	process(clk, rst)
	begin
		if(rst='1') then
			result <= "00000000";
		elsif(rising_edge(clk)) then
			result <= STD_LOGIC_VECTOR(unsigned(inA) * unsigned(inB));
		end if;
	end process;
	
end Behavioral;

