-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
--           :
--  Purpose    :  This is a FSMD (finite state machine with datapath) 
--             :  implementation the GCD circuit
--             :
--  Revision   :  02203 fall 2019 v.5.0
--
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
  port (clk : in std_logic;             -- The clock signal.
    reset : in  std_logic;              -- Reset the module.
    req   : in  std_logic;              -- Input operand / start computation.
    AB    : in  unsigned(15 downto 0);  -- The two operands.
    teststate : out unsigned(3 downto 0);
    Reg_A_test : out unsigned(15 downto 0);
    Reg_B_test : out unsigned(15 downto 0);
    ack   : out std_logic;              -- Computation is complete.
    C     : out unsigned(15 downto 0)); -- The result.
end gcd;

architecture fsmd of gcd is

  type state_type is (INIT, ACK_A, STORE_B, LOOP_NODE, CALC_A, CALC_B, ACK_OUT ); -- Input your own state names

  signal reg_a, next_reg_a, next_reg_b, reg_b : unsigned(15 downto 0);

  signal state, next_state : state_type;


begin

  -- Combinatoriel logic

  cl : process (req,ab,state,reset) --, reg_a,reg_b)
  begin
  
    reg_a <= "0000000000000000";
	reg_b <= "0000000000000000";
	ack <= '0';
	
    case (state) is

        WHEN INIT =>
	          ack <= '0';
	          reg_a <= AB;
	          Reg_A_test <= AB;
	          --Reg_A_test <= reg_a;
		      teststate <= "0000";
		  IF req='0' THEN
			  next_state <= INIT;
		  ELSIF req='1' THEN
		      ack <= '1';
			  next_state <= ACK_A;
		  END IF;
	   WHEN ACK_A =>
		  teststate <= "0001";
	      Reg_A_test <= reg_a;
	      IF req='0' THEN
			  next_state <= STORE_B;
	      END IF;
	   WHEN STORE_B =>
		  ack <= '0';
		  reg_B <= AB;
	      Reg_B_test <= reg_b;
		  teststate <= "0010";
		  IF req='1' THEN
			  next_state <= LOOP_NODE;
		  END IF;
	   WHEN LOOP_NODE =>
		  teststate <= "0011";
		  IF reg_b < reg_a THEN
			 next_state <= CALC_A;
		  ELSIF reg_a < reg_b THEN
			 next_state <= CALC_B; 
	          ELSE
			 next_state <= ACK_OUT;
		  END IF;
	   WHEN CALC_A =>
		  teststate <= "0100";
		  reg_a <= reg_a - reg_b;
		  next_state <= LOOP_NODE;
	   WHEN CALC_B =>
		  teststate <= "0101";
		  reg_b <= reg_b - reg_a;
		  next_state <= LOOP_NODE;
	   WHEN ACK_OUT => 
		  teststate <= "0110";
		  C <= reg_a;
		  ack <= '1';
		  IF req='0' THEN
			 next_state <= INIT;
	   	  END IF;
        end case;
  end process cl;

  -- Registers

  seq : process (clk, reset)
  begin

    IF reset='1' THEN
	-- Need to reset the state and the registers
	state <= INIT;
    ELSIF rising_edge(clk) THEN
	state <= next_state;
	--reg_a <= next_reg_a;
	--reg_b <= next_reg_b;
    END IF;
	

  end process seq;


end fsmd;
