----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:20:12 10/18/2018 
-- Design Name: 
-- Module Name:    CtrlUnit - Behavioral 
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

entity CtrlUnit is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           NegF : in  STD_LOGIC;
           ZeroF : in  STD_LOGIC;
           opCode : in  STD_LOGIC_VECTOR (3 downto 0);
           PCload : out  STD_LOGIC;
           PCinc : out  STD_LOGIC;
           remMuxSel : out  STD_LOGIC;
           remLoad : out  STD_LOGIC;
           readCtrl : out  STD_LOGIC;
           writeCtrl : out  STD_LOGIC_VECTOR (0 downto 0);
           rdmLoad : out  STD_LOGIC;
           accLoad : out  STD_LOGIC;
           selALU : out  STD_LOGIC_VECTOR (2 downto 0);
           nzLoad : out  STD_LOGIC;
           riLoad : out  STD_LOGIC;
            setDsp : out  STD_LOGIC;
            dataMuxSel : OUT std_logic); -- Reset display
end CtrlUnit;

architecture Behavioral of CtrlUnit is


type state_type is (IDLE,Busca_Instrucao,IdleMem1,Ler_Instrucao,Carrega_RI,Busca_Dados,
                    IdleMem2,Busca_Endereco,Busca_Endereco2,Trata_STA,IdleMem3,Trata_HLT);
signal presentState, nextState : state_type;

constant NOP  : std_logic_vector := "0000";
constant STA  : std_logic_vector := "0001";
constant LDA  : std_logic_vector:= "0010";
constant ADD  : std_logic_vector := "0011";
constant opOR   : std_logic_vector := "0100";
constant opAND  : std_logic_vector := "0101";
constant opNOT  : std_logic_vector := "0110";
constant JMP  : std_logic_vector := "1000";
constant JN   : std_logic_vector := "1001";
constant JZ   : std_logic_vector := "1010";
constant HLT  : std_logic_vector := "1111";

constant MUL : std_logic_vector := "1100";
constant SUB : std_logic_vector := "1101";

begin

-- FSM
    sync_process: process(clk,rst)
    begin
        if (rst = '1') then
            presentState <= IDLE;
        elsif (rising_edge(clk)) then
            presentState <= nextState;
        end if;
    end process sync_process;
            
    comb_process: process(presentState,opCode,NegF,ZeroF)
    begin
        dataMuxSel <= '0';
        setDsp <= '1';
        PCload <= '0';
        PCinc <= '0';
        remMuxSel <= '0';
        remLoad <= '0';
        readCtrl <= '0';
        writeCtrl <= (others => '0');
        rdmLoad <= '0';
        accLoad <= '0';
        selALU <= (others => '0');
        nzLoad <= '0';
        riLoad <= '0';
        --
        case presentState is
            when IDLE =>
                remMuxSel <= '0';
                remLoad <= '1';
                nextState <= Busca_Instrucao;
            when Busca_Instrucao =>
                readCtrl <= '1';
                rdmLoad <= '1';
                PCinc <= '1';
                nextState <= IdleMem1;
            when IdleMem1 =>
                readCtrl <= '1';
                rdmLoad <= '1';
                PCinc <= '0';
                nextState <= Ler_Instrucao;
            when Ler_Instrucao =>
                riLoad <= '1';
                nextState <= Carrega_RI;
            when Carrega_RI =>
                if (opCode = STA or opCode = LDA or opCode = ADD or opCode = SUB
                    or opCode = opOR or opCode = opAND or opCode = JMP or opCode = MUL)
                then
                    remMuxSel <= '0';
                    remLoad <= '1';
                    nextState <= Busca_Dados;
                elsif (opCode = opNOT) then
                    selALU <= "011";
                    accLoad <= '1';
                    nzLoad <= '1';
                    nextState <= IDLE;
                elsif (opCode = JN) then
                    if (NegF = '1') then
                        remMuxSel <= '0';
                        remLoad <= '1';
                        nextState <= Busca_Dados;
                    elsif (NegF = '0') then
                        PCinc <= '1';
                        nextState <= IDLE;
                    end if;
                elsif (opCode = JZ) then
                    if (ZeroF = '1') then
                        remMuxSel <= '0';
                        remLoad <= '1';
                        nextState <= Busca_Dados;
                    elsif (ZeroF = '0') then
                        PCinc <= '1';
                        nextState <= IDLE;
                    end if;
                elsif (opCode = NOP) then
                    nextState <= IDLE;
                elsif (opCode = HLT) then
                    nextState <= Trata_HLT;
                else
                    nextState <= Trata_HLT;
                end if;
            when Busca_Dados =>
                if (opCode = STA or opCode = LDA or opCode = ADD or opCode = SUB 
                     or opCode = opOR or opCode = opAND or opCode = MUL)
                then
                    readCtrl <= '1';
                    rdmLoad <= '1';
                    PCinc <= '1';
                    nextState <= IdleMem2;
                elsif (opCode = opNOT) then
                    nextState <= Trata_HLT;
                elsif (opCode = JMP) then
                    readCtrl <= '1';
                    rdmLoad <= '1';
                    nextState <= IdleMem2;
                elsif (opCode = JN) then
                    if (NegF = '1') then
                        readCtrl <= '1';
                        rdmLoad <= '1';
                        nextState <= IdleMem2;
                    elsif (NegF = '0') then
                        nextState <= Trata_HLT;
                    end if;
                elsif (opCode = JZ) then
                    if (ZeroF = '1') then
                        readCtrl <= '1';
                        rdmLoad <= '1';
                        nextState <= IdleMem2;
                    elsif (ZeroF = '0') then
                        nextState <= Trata_HLT;
                    end if;
                elsif (opCode = NOP) then
                    nextState <= Trata_HLT;
                elsif (opCode = HLT) then
                    nextState <= Trata_HLT;
                else
                    nextState <= Trata_HLT;
                end if;
            when IdleMem2 =>
                if (opCode = STA or opCode = LDA or opCode = ADD or opCode = MUL 
                     or opCode = opOR or opCode = opAND or opCode = SUB)
                then
                    readCtrl <= '1';
                    rdmLoad <= '1';
                    PCinc <= '0';
                    nextState <= Busca_Endereco;
                elsif (opCode = opNOT) then
                    nextState <= Trata_HLT;
                elsif (opCode = JMP) then
                    readCtrl <= '1';
                    rdmLoad <= '1';
                    nextState <= Busca_Endereco;
                elsif (opCode = JN) then
                    if (NegF = '1') then
                        readCtrl <= '1';
                        rdmLoad <= '1';
                        nextState <= Busca_Endereco;
                    elsif (NegF = '0') then
                        nextState <= Trata_HLT;
                    end if;
                elsif (opCode = JZ) then
                    if (ZeroF = '1') then
                        readCtrl <= '1';
                        rdmLoad <= '1';
                        nextState <= Busca_Endereco;
                    elsif (ZeroF = '0') then
                        nextState <= Trata_HLT;
                    end if;
                elsif (opCode = NOP) then
                    nextState <= Trata_HLT;
                elsif (opCode = HLT) then
                    nextState <= Trata_HLT;
                else
                    nextState <= Trata_HLT;
                end if;
            when Busca_Endereco =>
                if (opCode = STA or opCode = LDA or opCode = ADD or opCode = MUL
                     or opCode = opOR or opCode = opAND or opCode = SUB)
                then
                    remMuxSel <= '1';
                    remLoad <= '1';
                    nextState <= Busca_Endereco2;
                elsif (opCode = opNOT) then
                    nextState <= Trata_HLT;
                elsif (opCode = JMP) then
                    PCload <= '1';
                    nextState <= IDLE;
                elsif (opCode = JN) then
                    if (NegF = '1') then
                        PCload <= '1';
                        nextState <= IDLE;
                    elsif (NegF = '0') then
                        nextState <= Trata_HLT;
                    end if;
                elsif (opCode = JZ) then
                    if (ZeroF = '1') then
                        PCload <= '1';
                        nextState <= IDLE;
                    elsif (ZeroF = '0') then
                        nextState <= Trata_HLT;
                    end if;
                elsif (opCode = NOP) then
                    nextState <= Trata_HLT;
                elsif (opCode = HLT) then
                    nextState <= Trata_HLT;
                else
                    nextState <= Trata_HLT;
                end if;
            when Busca_Endereco2 =>
                if (opCode = LDA or opCode = ADD or opCode = opOR 
                     or opCode = opAND or opCode = SUB or opCode = MUL)
                then
                    readCtrl <= '1';
                    rdmLoad <= '1';
                    nextState <= IdleMem3;
                elsif (opCode = STA) then
                    rdmLoad <= '1';
                    nextState <= Trata_STA;
                else
                    nextState <= Trata_HLT;
                end if;
            when IdleMem3 =>
                if (opCode = LDA or opCode = ADD or opCode = opOR 
                     or opCode = opAND or opCode = SUB or opCode = MUL)
                then
                    readCtrl <= '1';
                    rdmLoad <= '1';
                    nextState <= Trata_STA;
                elsif (opCode = STA) then
                    rdmLoad <= '1';
                    nextState <= Trata_STA;
                else
                    nextState <= Trata_HLT;
                end if;
            when Trata_STA =>
                if (opCode = STA) then
                    writeCtrl <= (others => '1');
                    nextState <= IDLE;
                elsif (opCode = LDA) then
                    selALU <= "100";
                    accLoad <= '1';
                    nzLoad <= '1';
                    nextState <= IDLE;
                elsif (opCode = ADD) then 
                    selALU <= "000";
                    accLoad <= '1';
                    nzLoad <= '1';
                    nextState <= IDLE;
					 elsif (opCode = SUB) then
						  selALU <= "101";
						  accLoad <= '1';
						  nzLoad <= '1';
						  nextState <= IDLE;
					 elsif (opCode = MUL) then
						  selALU <= "110";
						  accLoad <= '1';
						  nzLoad <= '1';
						  nextState <= IDLE;
                elsif (opCode = opOR) then
                    selALU <= "010";
                    accLoad <= '1';
                    nzLoad <= '1';
                    nextState <= IDLE;
                elsif (opCode = opAND) then
                    selALU <= "001";
                    accLoad <= '1';
                    nzLoad <= '1';
                    nextState <= IDLE;                    
                else
                    nextState <= Trata_HLT;
                end if;
            when Trata_HLT =>
                PCinc <= '0';
					 setDsp <= '0';
                     dataMuxSel <= '1';
                nextState <= Trata_HLT;
            when others =>
                nextState <= IDLE;
        end case;
    end process comb_process;


end Behavioral;

