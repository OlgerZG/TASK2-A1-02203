----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2024 10:49:15
-- Design Name: 
-- Module Name: Reg - Behavioral
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

entity Reg is
    Port ( C : in STD_LOGIC_VECTOR (15 downto 0);
           Selc : in STD_LOGIC;
           clk : in STD_LOGIC;
           Operator : out STD_LOGIC_VECTOR (15 downto 0));
end Reg;

architecture Behavioral of Reg is

begin
    process (Selc, C, clk)
        variable Mem : STD_LOGIC_VECTOR(15 downto 0);
    begin
        if Selc = '1' then
            if rising_edge (clk) then
                Mem := C;
            end if;    
        end if;
        Operator <= Mem;
    end process;
end Behavioral;
