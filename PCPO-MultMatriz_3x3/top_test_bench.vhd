--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:46:46 12/19/2018
-- Design Name:   
-- Module Name:   C:/VHDL/Trab_Final/top_test_bench.vhd
-- Project Name:  Trab_Final
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TOP_PCPO_v1
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
 
ENTITY top_test_bench IS
END top_test_bench;
 
ARCHITECTURE behavior OF top_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP_PCPO_v1
    PORT(
         start : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP_PCPO_v1 PORT MAP (
          start => start,
          clk => clk,
          rst => rst,
          done => done
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
      wait for 100 ns;	
      rst <= '0';

      wait for clk_period*10;
      start <= '1';
      wait for clk_period;
      start <= '0';

      wait;
   end process;

END;
