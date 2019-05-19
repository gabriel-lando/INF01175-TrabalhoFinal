
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity TOP_PCPO_v1 is
    Port ( start : in  STD_LOGIC;
    	   clk: in STD_LOGIC;
           rst : in  STD_LOGIC := '0';
           done : out  STD_LOGIC);
end TOP_PCPO_v1;

architecture Behavioral of TOP_PCPO_v1 is
	COMPONENT memoria_input
	  PORT (
	    clka : IN STD_LOGIC;
	    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	    dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	    clkb : IN STD_LOGIC;
	    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	    dinb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	    doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	  );
	END COMPONENT;

	COMPONENT memoria_output
	  PORT (
	    clka : IN STD_LOGIC;
	    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	    dina : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	    douta : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	  );
	END COMPONENT;

	COMPONENT mult_4bits
	  PORT(
		inA : IN std_logic_vector(3 downto 0);
		inB : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;          
		result : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT reg_5bits
	PORT(
		d : IN std_logic_vector(4 downto 0);
		load : IN std_logic;
		incCol : IN std_logic;
		incRow : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic;          
		q : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	COMPONENT somador_serial
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		clear : IN std_logic;
		add : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);          
		sum_out : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;

	signal in_addra, in_addrb : STD_LOGIC_VECTOR(4 downto 0);
	signal addra, addrb, addrout : STD_LOGIC_VECTOR(4 downto 0);
	signal mult_result : STD_LOGIC_VECTOR(7 downto 0);
	signal lda, ldb, incColA, incRowB, incOut : STD_LOGIC;
	signal soma_clear, soma_add : STD_LOGIC;
	signal we_inA, we_inB, we_out : STD_LOGIC_VECTOR(0 downto 0);
	signal din_a, din_b, dout_a, dout_b : STD_LOGIC_VECTOR(3 downto 0);
	signal dout_out : STD_LOGIC_VECTOR(9 downto 0);
	signal soma_out : STD_LOGIC_VECTOR(9 downto 0);

	type t_state is (idle, c1, read_m, wait_m, mult_m, add1, add2, add3, end_state);
	signal state, next_state : t_state;

begin
	-- Parte de Controle
	process (clk, rst)
	begin
		if (rst = '1') then
			state <= idle;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;

	process (state, start, addra, addrb)
	begin
		case state is
			when idle =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '0';
				done <= '0';

				if(start = '1') then
					next_state <= c1;
				else
				 	next_state <= idle;
				end if;
			when c1 =>
				in_addra <= "00000";
				in_addrb <= "01001";
				lda <= '1';
				ldb <= '1';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '0';
				done <= '0';
				next_state <= read_m;
			when read_m =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '0';
				done <= '0';
				next_state <= wait_m;
			when wait_m =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '1';
				incRowB <= '1';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '0';
				done <= '0';
				next_state <= mult_m;
			when mult_m =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '1';
				incRowB <= '1';
				incOut <= '0';
				soma_clear <= '1';
				soma_add <= '0';
				done <= '0';
				next_state <= add1;
			when add1 =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '1';
				done <= '0';
				next_state <= add2;
			when add2 =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '1';
				done <= '0';
				next_state <= add3;
			when add3 =>
				in_addra <= "00000";
				in_addrb <= "00000";
				lda <= '0';
				ldb <= '0';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "0";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '0';
				soma_clear <= '0';
				soma_add <= '1';
				done <= '0';
				next_state <= end_state;
			when end_state =>
				lda <= '1';
				ldb <= '1';
				we_inA <= "0";
				we_inB <= "0";
				we_out <= "1";
				incColA <= '0';
				incRowB <= '0';
				incOut <= '1';
				soma_clear <= '0';
				soma_add <= '0';

				if(addra="00010" and addrb="01111") then
					in_addra <= "00000";
					in_addrb <= "01010";
					done <= '0';
					next_state <= read_m;
				elsif(addra="00010" and addrb="10000") then 
					in_addra <= "00000";
					in_addrb <= "01011";
					done <= '0';
					next_state <= read_m;
				elsif(addra="00010" and addrb="10001") then 
					in_addra <= "00011";
					in_addrb <= "01001";
					done <= '0';
					next_state <= read_m;
				elsif(addra="00101" and addrb="01111") then 
					in_addra <= "00011";
					in_addrb <= "01010";
					done <= '0';
					next_state <= read_m;
				elsif(addra="00101" and addrb="10000") then 
					in_addra <= "00011";
					in_addrb <= "01011";
					done <= '0';
					next_state <= read_m;
				elsif(addra="00101" and addrb="10001") then 
					in_addra <= "00110";
					in_addrb <= "01001";
					done <= '0';
					next_state <= read_m;
				elsif(addra="01000" and addrb="01111") then 
					in_addra <= "00110";
					in_addrb <= "01010";
					done <= '0';
					next_state <= read_m;
				elsif(addra="01000" and addrb="10000") then 
					in_addra <= "00110";
					in_addrb <= "01011";
					done <= '0';
					next_state <= read_m;
				else
					in_addra <= "00000";
					in_addrb <= "00000";
					done <= '1';
					next_state <= idle;
				end if;
		end case;
	end process;
	-- Parte Operativa (PO)
	mem_input : memoria_input
	  PORT MAP (
		clka => clk,
		wea => we_inA,
		addra => addra,
		dina => din_a,
		douta => dout_a,
		clkb => clk,
		web => we_inB,
		addrb => addrb,
		dinb => din_b,
		doutb => dout_b
	);

	mem_output : memoria_output
	  PORT MAP (
	    clka => clk,
	    wea => we_out,
	    addra => addrout(3 downto 0),
	    dina => soma_out,
	    douta => dout_out
	  );

	multiplicador: mult_4bits
	  PORT MAP(
		inA => dout_a,
		inB => dout_b,
		clk => clk,
		rst => rst,
		result => mult_result
	);

	somador: somador_serial PORT MAP(
		clk => clk,
		rst => rst,
		clear => soma_clear,
		add => soma_add,
		data_in => mult_result,  
		sum_out => soma_out
	);

	addressA: reg_5bits PORT MAP(
		d => in_addra,
		q => addra,
		load => lda,
		incCol => incColA,
		incRow => '0',
		clk => clk,
		reset => rst
	);

	addressB: reg_5bits PORT MAP(
		d => in_addrb,
		q => addrb,
		load => ldb,
		incCol => '0',
		incRow => incRowB,
		clk => clk,
		reset => rst
	);

	addressOutput: reg_5bits PORT MAP(
		d => "00000",
		q => addrout,
		load => '0',
		incCol => incOut,
		incRow => '0',
		clk => clk,
		reset => rst
	);

end Behavioral;

