----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:16 10/18/2018 
-- Design Name: 
-- Module Name:    Neander - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Neander is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
  			btn_set     : in  STD_LOGIC;
           btn_next     : in  STD_LOGIC;
           btn_prev     : in  STD_LOGIC;
           swt_val     	: in  STD_LOGIC_VECTOR(3 downto 0);
           display_out  : out STD_LOGIC_VECTOR(3 downto 0);
           cath_out     : OUT std_logic_vector(7 downto 0));
end Neander;

architecture Behavioral of Neander is
	
	signal dataMuxSel : STD_LOGIC;
	signal BRAM_IN : std_logic_vector(7 downto 0);
	signal writeDisplay : std_logic_vector(0 to 0);
	signal writeBRAM : std_logic_vector(0 to 0);
	signal dispCount : std_logic_vector(7 downto 0);
	signal remOutBRAM : std_logic_vector(7 downto 0);
	signal rstDsp : STD_LOGIC;
	signal loadPC : STD_LOGIC;
	signal incPC : STD_LOGIC;
	signal remMuxSel : STD_LOGIC;
	signal remLoad : STD_LOGIC;
	signal readCtrl : STD_LOGIC;
	signal writeCtrl : STD_LOGIC_VECTOR(0 downto 0);
	signal rdmLoad : STD_LOGIC;
	signal accLoad : STD_LOGIC;
	signal selALU : STD_LOGIC_VECTOR(2 downto 0);
	signal nzLoad : STD_LOGIC;
	signal riLoad : STD_LOGIC;
	signal PCout : std_logic_vector(7 downto 0);
	signal remMuxOut : std_logic_vector(7 downto 0);
	signal remOut : std_logic_vector(7 downto 0);
	signal rdmMuxOut : std_logic_vector(7 downto 0);
	signal rdmOut : std_logic_vector(7 downto 0);
	signal ramOut : std_logic_vector(7 downto 0);
	signal accOut : std_logic_vector(7 downto 0);
	signal ALUresult : std_logic_vector(7 downto 0);
	signal ALUnFlag : std_logic;
	signal ALUzFlag : std_logic;
	signal nFFOut : std_logic;
	signal zFFOut : std_logic;
	signal riOut : std_logic_vector(7 downto 0);
	----
	signal newValue         	: STD_LOGIC_VECTOR(7 downto 0);
	signal pulse_set           : STD_LOGIC;
   signal pulse_prev           : STD_LOGIC;
   signal pulse_next           : STD_LOGIC;
   signal up_down, c_enable    : STD_LOGIC := '0';
   signal display_data         : STD_LOGIC_VECTOR(15 downto 0);

	COMPONENT CtrlUnit
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		NegF : IN std_logic;
		ZeroF : IN std_logic;
		opCode : IN std_logic_vector(3 downto 0);          
		PCload : OUT std_logic;
		PCinc : OUT std_logic;
		remMuxSel : OUT std_logic;
		remLoad : OUT std_logic;
		readCtrl : OUT std_logic;
		writeCtrl : OUT std_logic_vector(0 downto 0);
		rdmLoad : OUT std_logic;
		accLoad : OUT std_logic;
		selALU : OUT std_logic_vector(2 downto 0);
		nzLoad : OUT std_logic;
		riLoad : OUT std_logic;
		setDsp : OUT std_logic;
		dataMuxSel : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT FF
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		en : IN std_logic;
		D : IN std_logic;          
		Q : OUT std_logic
		);
	END COMPONENT;

	COMPONENT Mux
	PORT(
		in0 : IN std_logic_vector(7 downto 0);
		in1 : IN std_logic_vector(7 downto 0);
		sel : IN std_logic;          
		dataOut : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT PC
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		inc : IN std_logic;
		load : IN std_logic;
		D : IN std_logic_vector(7 downto 0);          
		Q : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Reg8bits
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		en : IN std_logic;
		D : IN std_logic_vector(7 downto 0);          
		Q : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ULA
	PORT(
		X : IN std_logic_vector(7 downto 0);
		Y : IN std_logic_vector(7 downto 0);
		selALU : IN std_logic_vector(2 downto 0);          
		NegF : OUT std_logic;
		ZeroF : OUT std_logic;
		result : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Programa
	PORT (
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	
	-----------

	COMPONENT Mux_1B_Vec
	PORT(
		in0 : IN std_logic_vector(0 to 0);
		in1 : IN std_logic_vector(0 to 0);
		sel : IN std_logic;          
		dataOut : OUT std_logic_vector(0 to 0)
		);
	END COMPONENT;
	
	COMPONENT button_driver_longpress
  PORT(
    clk : IN std_logic;
    rst : IN std_logic;
    btn_in : IN std_logic;          
    btn_out : OUT std_logic
    );
  END COMPONENT;
 
	COMPONENT button_driver
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		btn_in : IN std_logic;          
		btn_out : OUT std_logic
		);
	END COMPONENT;
  
  COMPONENT updown_counter_8bits
  PORT(
    up_down : IN std_logic;
    enable : IN std_logic;
    clk : IN std_logic;
    reset : IN std_logic;          
    count : OUT std_logic_vector(7 downto 0)
    );
  END COMPONENT;

  COMPONENT hex_7seg
  PORT(
    bcd_in : IN std_logic_vector(15 downto 0);
    dots : IN std_logic_vector(3 downto 0);
    clk : IN std_logic;
    rst : IN std_logic;          
    display_out : OUT std_logic_vector(3 downto 0);
    cath_out : OUT std_logic_vector(7 downto 0)
    );
  END COMPONENT;

begin

	Memoria : Programa
	PORT MAP (
		clka => clk,
		wea => writeBRAM,
		addra => remOutBRAM,
		dina => BRAM_IN,
		douta => ramOut
	);
  
	UnidadeDeControle: CtrlUnit PORT MAP(
		clk => clk,
		rst => rst,
		NegF => nFFout,
		ZeroF => zFFout,
		opCode => riOut(7 downto 4),
		PCload => loadPC,
		PCinc => incPC,
		remMuxSel => remMuxSel,
		remLoad => remLoad,
		readCtrl => readCtrl,
		writeCtrl => writeCtrl,
		rdmLoad => rdmLoad,
		accLoad => accLoad,
		selALU => selALU,
		nzLoad => nzLoad,
		riLoad => riLoad,
		setDsp => rstDsp,
		dataMuxSel => dataMuxSel
	);

	UAL: ULA PORT MAP(
		X => accOut,
		Y => rdmOut,
		selALU => selALU ,
		NegF => ALUnFlag,
		ZeroF => ALUzFlag,
		result => ALUresult
	);

	Registrador_REM: Reg8bits PORT MAP(
		clk => clk,
		rst => rst,
		en => remLoad,
		D => remMuxOut,
		Q => remOut
	);
	
	Registrador_RDM: Reg8bits PORT MAP(
		clk => clk,
		rst => rst,
		en => rdmLoad,
		D => rdmMuxOut,
		Q => rdmOut
	);
	
	Registrador_RI: Reg8bits PORT MAP(
		clk => clk,
		rst => rst,
		en => riLoad,
		D => rdmOut,
		Q => riOut
	);
	
	Registrador_ACC: Reg8bits PORT MAP(
		clk => clk,
		rst => rst,
		en => accLoad,
		D => ALUresult,
		Q => accOut
	);

	Registrador_PC: PC PORT MAP(
		clk => clk,
		rst => rst,
		inc => incPC,
		load => loadPC,
		D => rdmOut,
		Q => PCout
	);

	Mux_RDM: Mux PORT MAP(
		in0 => accOut,
		in1 => ramOut,
		sel => readCtrl,
		dataOut => rdmMuxOut
	);
	
	Mux_REM: Mux PORT MAP(
		in0 => PCout,
		in1 => rdmOut,
		sel => remMuxSel,
		dataOut => remMuxOut
	);
	
	FlipFlop_Zero: FF PORT MAP(
		clk => clk,
		rst => rst,
		en => nzLoad,
		D => ALUzFlag,
		Q => zFFout
	);
	
	FlipFlop_Neg: FF PORT MAP(
		clk => clk,
		rst => rst,
		en => nzLoad,
		D => ALUnFlag,
		Q => nFFout
	);
	
	--------------

	Mux_Write_Val: Mux PORT MAP(
		in0 => rdmOut,
		in1 => newValue,
		sel => dataMuxSel,
		dataOut => BRAM_IN
	);

	Mux_Write_BRAM: Mux_1B_Vec PORT MAP(
		in0 => writeCtrl,
		in1 => writeDisplay,
		sel => dataMuxSel,
		dataOut => writeBRAM
	);

	Mux_BRAM: Mux PORT MAP(
		in0 => remOut,
		in1 => dispCount,
		sel => dataMuxSel,
		dataOut => remOutBRAM
	);
	
	
	btn_p: button_driver_longpress PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btn_prev,
		btn_out => pulse_prev
	);
  
	btn_n: button_driver_longpress PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btn_next,
		btn_out => pulse_next
	);
  
	btn_s: button_driver_longpress PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btn_set,
		btn_out => pulse_set
	);

  counter: updown_counter_8bits PORT MAP(
    up_down => up_down,
    enable => c_enable,
    clk => clk,
    reset => rst,
    count => dispCount
  );

  display: hex_7seg PORT MAP(
    bcd_in => display_data,
    dots => "0100",
    clk => clk,
    rst => rstDsp,
    display_out => display_out,
    cath_out => cath_out
  );

  process(clk, pulse_prev, pulse_next)
  begin
    if (rising_edge(clk)) then
      if(pulse_prev = '1') then
      	writeDisplay <= "0";
        c_enable <= '1';
        up_down <= '0';
      elsif (pulse_next = '1') then
      	writeDisplay <= "0";
        c_enable <= '1';
        up_down <= '1';
	  elsif (pulse_set = '1') then
		c_enable <= '0';
		newValue <= "0000" & swt_val;
		writeDisplay <= "1";
      else
        c_enable <= '0';
      end if;
		
		display_data <= dispCount & ramOut;
    end if;
  end process;


end Behavioral;

