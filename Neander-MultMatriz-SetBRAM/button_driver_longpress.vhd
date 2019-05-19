library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_driver_longpress is
    Port ( clk, rst	: in  STD_LOGIC;
           btn_in 	: in  STD_LOGIC;
           btn_out 	: out  STD_LOGIC);
end button_driver_longpress;

architecture Behavioral of button_driver_longpress is
	constant DB_MAX   : integer := 50;
	constant LOOP_MAX : integer := 10000000;
	constant LP_MAX   : integer := 50000000;

	type state_type is (idle, debounce, long_press, press_loop);
	signal state, next_state 				: state_type;
	signal db_count, lp_count, loop_count 	: unsigned (31 downto 0) := (others => '0');
begin
	process (clk, rst)
	begin
		if (rst='1') then
			state <= idle;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;

	process (state, btn_in, db_count, lp_count, loop_count)
	begin
		case state is
			when idle =>
				if (btn_in = '0') then
					btn_out <= '0';
					next_state <= idle;
				else
					btn_out <= '1';
					next_state <= debounce;
				end if;
			when debounce =>
				if (not (db_count = 0)) then
					btn_out <= '0';
					next_state <= debounce;
				elsif ((db_count = 0) and (btn_in = '1')) then
					btn_out <= '0';
					next_state <= long_press;
				else
					btn_out <= '0';
					next_state <= idle;
				end if;
			when long_press =>
				if (btn_in = '1' and lp_count /= 0) then
					btn_out <= '0';
					next_state <= long_press;
				elsif (btn_in = '1' and lp_count = 0) then
					btn_out <= '1';
					next_state <= press_loop;
				else -- btn_in = '0'
					btn_out <= '0';
					next_state <= idle;
				end if;
			when press_loop =>
				if (btn_in = '1' and loop_count /= 0) then
					btn_out <= '0';
					next_state <= press_loop;
				elsif (btn_in = '1' and loop_count = 0) then
					btn_out <= '1';
					next_state <= press_loop;
				else -- btn_in = '0'
					btn_out <= '0';
					next_state <= idle;
				end if;
		end case;
	end process;

	process(clk, rst)
	begin
		if (rst = '1') then
			db_count <= to_unsigned(DB_MAX, 32);
			lp_count <= to_unsigned(LP_MAX, 32);
			loop_count <= to_unsigned(LOOP_MAX, 32);
		elsif (rising_edge(clk)) then
			case state is
				when idle =>
					if (btn_in = '0') then
						db_count <= db_count;
						lp_count <= to_unsigned(LP_MAX, 32);
						loop_count <= to_unsigned(LOOP_MAX, 32);
					else
						db_count <= to_unsigned(DB_MAX, 32);
						lp_count <= to_unsigned(LP_MAX, 32);
						loop_count <= to_unsigned(LOOP_MAX, 32);
					end if;
				when debounce =>
					if (not (db_count = 0)) then
						db_count <= db_count - 1;
						lp_count <= lp_count;
						loop_count <= loop_count;
					elsif ((db_count = 0) and (btn_in = '1')) then
						db_count <= db_count;
						lp_count <= to_unsigned(LP_MAX, 32);
						loop_count <= loop_count;
					else
						db_count <= db_count;
						lp_count <= lp_count;
						loop_count <= loop_count;
					end if;
				when long_press =>
					if (btn_in = '1' and lp_count /= 0) then
						db_count <= db_count;
						lp_count <= lp_count - 1;
						loop_count <= loop_count;
					elsif (btn_in = '1' and lp_count = 0) then
						db_count <= db_count;
						lp_count <= lp_count;
						loop_count <= to_unsigned(LOOP_MAX, 32);
					else -- btn_in = '0'
						db_count <= db_count;
						lp_count <= lp_count;
						loop_count <= loop_count;
					end if;
				when press_loop =>
					if (btn_in = '1' and loop_count /= 0) then
						db_count <= db_count;
						lp_count <= lp_count;
						loop_count <= loop_count - 1;
					elsif (btn_in = '1' and loop_count = 0) then
						db_count <= db_count;
						lp_count <= lp_count;
						loop_count <= to_unsigned(LOOP_MAX, 32);
					else -- btn_in = '0'
						db_count <= db_count;
						lp_count <= lp_count;
						loop_count <= loop_count;
					end if;
			end case;
		end if;
	end process;
end Behavioral;

