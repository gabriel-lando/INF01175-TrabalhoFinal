--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:40:34 12/19/2018
-- Design Name:   
-- Module Name:   C:/Xilinx/MultMatriz-SetBRAM-Neander/Neander_TB.vhd
-- Project Name:  MultMatriz-SetBRAM-Neander
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Neander
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Neander_TB IS
END Neander_TB;
 
ARCHITECTURE behavior OF Neander_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Neander
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         btn_set : IN  std_logic;
         btn_next : IN  std_logic;
         btn_prev : IN  std_logic;
         swt_val : IN  std_logic_vector(3 downto 0);
         display_out : OUT  std_logic_vector(3 downto 0);
         cath_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal btn_set : std_logic := '0';
   signal btn_next : std_logic := '0';
   signal btn_prev : std_logic := '0';
   signal swt_val : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal display_out : std_logic_vector(3 downto 0);
   signal cath_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Neander PORT MAP (
          clk => clk,
          rst => rst,
          btn_set => btn_set,
          btn_next => btn_next,
          btn_prev => btn_prev,
          swt_val => swt_val,
          display_out => display_out,
          cath_out => cath_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
    rst <= '1';
      wait for 200 ns;    
      wait for clk_period*10; 
    
    rst <= '0';
      wait;
   end process;

END;
