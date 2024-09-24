----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2024 11:25:58
-- Design Name: 
-- Module Name: MUX - Behavioral
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

entity MUX is
    Port ( AB : in STD_LOGIC_VECTOR (15 downto 0);
           Y : in STD_LOGIC_VECTOR (15 downto 0);
           ABorALU : in STD_LOGIC;
           C : out STD_LOGIC_VECTOR (15 downto 0));
end MUX;

architecture Behavioral of MUX is

begin
    process (AB, Y, ABorALU)
    begin
    case (ABorALU) is
        when '1' => C <= AB;
        when '0' => C <= Y;
        when others => C <= "XXXXXXXXXXXXXXXX";
    end case;
    end process;
end Behavioral;
