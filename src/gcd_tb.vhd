-- -----------------------------------------------------------------------------
--
--  Title      :  Testbench for the GCD module
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
--             :
--  Purpose    :  A testbench for the gcd_top module providing a simulated clock
--             :  and a sequence of test data. This module is written using
--             :  imperative VHDL and is only used for testing (can not be
--             :  synthesised)
--             :
--  Revision   : 02203 fall 2022 v.7.0
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- The testbench entity is an completely isolated entity with no input/output
entity gcd_tb is
end gcd_tb;

-- LoRa has been here
-- Architecture of the testbench. Instantiates the gcd_top entity and provides it
-- with test data. The result is then compared to the actual result for verification.
architecture testbench of gcd_tb is

	component gcd is 
		port (clk : in std_logic;             -- The clock signal.
			reset : in  std_logic;              -- Reset the module.
			req   : in  std_logic;              -- Start computation.
			AB    : in  STD_LOGIC_VECTOR(15 downto 0);  -- The two operands.
			teststate : out STD_LOGIC_VECTOR(3 downto 0);
			Reg_A_test : out STD_LOGIC_VECTOR(15 downto 0);
            Reg_B_test : out STD_LOGIC_VECTOR(15 downto 0);
			ack   : out std_logic;              -- Computation is complete.
			C     : out STD_LOGIC_VECTOR(15 downto 0)); -- The result.
	end component;

	-- Internal signals
	signal clk, reset : std_logic;
	signal req, ack   : std_logic;
	signal AB, C, Reg_A_test, Reg_B_test  : STD_LOGIC_VECTOR(15 downto 0);
	signal teststate : STD_LOGIC_VECTOR(3 downto 0);

begin

		-- Instantiate gcd_top module and wire it up to internal signals used for testing
		fa_inst: gcd port map(
			clk   => clk,
			reset => reset,
			req   => req,
			AB    => AB,
			ack   => ack,
			C     => C,
			teststate => teststate
		);

	-- Clock generation (simulation use only)
	proc_test: process
	begin
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --open the state machine (state 0)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000000110"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000000110"; wait for 15 ns; --register a (state 1)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns; --register b (state 2)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns; --go to the loop state (a<b) (state 3)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --give the answer (state 6)
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --go back to init (state 0)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns; --register a (state 1)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000110"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000110"; wait for 15 ns; --register b (state 2)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns; --go to the loop state (a>b)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --(state 5)(state 4)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --give the answer (state 6)
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --go back to init (state 0)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns; --register a (state 1)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns; --register b (state 2)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns; --go to the loop state (a=b)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --give the answer (state 6)
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --go back to init (state 0)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns; --register a (state 1)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns; --register b (state 2)
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --go back to init (state 0)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns; --register a (state 1)
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --go back to init (state 0)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000010000"; wait for 15 ns; --register a (state 1)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000010000"; wait for 15 ns; --register b (state 2)
		clk <= '0'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '1'; AB <= "0000000000000000"; wait for 15 ns; --go to the loop state (a<b)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '0'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '1'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns; --go back to init (state 0)
		clk <= '0'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;
		clk <= '1'; reset <= '0'; req <= '0'; AB <= "0000000000000000"; wait for 15 ns;


	end process;

end testbench;
