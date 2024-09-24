----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2024 10:49:15
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR(15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           Y : out STD_LOGIC_VECTOR (15 downto 0);
           N : out STD_LOGIC;
           Z : out STD_LOGIC;
           FN : in STD_LOGIC_VECTOR (1 downto 0));
end ALU;

architecture Behavioral of ALU is
     signal result : STD_LOGIC_VECTOR(15 downto 0);
begin
    process (A, B, FN)
    begin
    case (FN) is
        when "00" => result <= std_logic_vector(unsigned(A) - unsigned(B));
        when "01" => result <= std_logic_vector(unsigned(B) - unsigned(A));
        when "10" => result <= A;
        when "11" => result <= B;
        when others  => result <= (others => '0');
    end case;
    
    if result = "0000000000000000" then
        Z <= '1';
    else
        Z <= '0';
    end if;
    
    if result(15) = '1' then
         N <= '1';
    else
         N <= '0';
    end if;
    
    Y <= result;
    
end process;
end Behavioral;

