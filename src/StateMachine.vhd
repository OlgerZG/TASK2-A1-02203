----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2024 14:49:07
-- Design Name: 
-- Module Name: StateMachine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity StateMachine is
    Port ( Req : in STD_LOGIC;
           Reset : in STD_LOGIC;
           N : in STD_LOGIC;
           Z : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Ack : out STD_LOGIC;
           ABorALU : out STD_LOGIC;
           LDA : out STD_LOGIC;
           LDB : out STD_LOGIC;
           reset_int: out STD_LOGIC;
           FN : out STD_LOGIC_VECTOR (1 downto 0));
end StateMachine;

architecture Behavioral of StateMachine is

type state_type is (INIT, ACK_A, STORE_B, LOOP_NODE, CALC_A, CALC_B, ACK_OUT);
signal state, next_state : state_type;
signal ack_internal : std_logic;  -- Internal signal for ack

begin

    process (Req, state, N, Z)
    begin
        ack <= '0';
	
    case state is
        WHEN INIT =>
	          ack <= '0';
		      ABorALU <= '0';
		      LDA <= '1';
		  IF req='0' THEN
			  next_state <= INIT;
		  ELSIF req='1' THEN
		      ack <= '1';
			  next_state <= ACK_A;
		  END IF;
		  
	   WHEN ACK_A =>
	      IF req='0' THEN
			  next_state <= STORE_B;
	      END IF;
	      
	   WHEN STORE_B =>
		  ack <= '0';
		  LDB <= '1';
		  IF req='1' THEN
			  next_state <= LOOP_NODE;
		  END IF;
		  
	   WHEN LOOP_NODE =>
		  if Z = '1' then   
            next_state <= ACK_OUT;
          elsif N = '1' then 
            FN <= "01"; 
            next_state <= CALC_B;
          else
            FN <= "00"; 
            next_state <= CALC_A;
          end if;
		  
	   WHEN CALC_A =>
		  FN <= "10";
		  next_state <= LOOP_NODE;
		  
	   WHEN CALC_B =>
		  FN <= "11";
		  next_state <= LOOP_NODE;
		  
	   WHEN ACK_OUT => 
		  ack <= '1';
		  ABorALU <= '1';		  
		  IF req='1' THEN
			 next_state <= INIT;
	   	  END IF;
	   	
	   	WHEN others  =>
	   	   next_state <= INIT;
        end case;

    end process;
    
    process (Reset, CLK)
    begin
        if reset = '1' then
            state <= INIT;
            reset_int <= '1';
        elsif rising_edge(clk) then
            state <= next_state;   
        end if;
    end process;
end Behavioral;
