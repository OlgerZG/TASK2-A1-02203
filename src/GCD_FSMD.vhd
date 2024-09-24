----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2024 15:40:33
-- Design Name: 
-- Module Name: GCD_FSMD - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity GCD_FSMD is
    Port (
        Req    : in  STD_LOGIC;
        Reset  : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        AB     : in  STD_LOGIC_VECTOR (15 downto 0);
        C      : out STD_LOGIC_VECTOR (15 downto 0);
        Ack    : out STD_LOGIC
    );
end GCD_FSMD;

architecture Behavioral of GCD_FSMD is
    -- Internal signals
    signal N, Z : STD_LOGIC;  -- Flags from the ALU (negative, zero)
    signal ABorALU, LDA, LDB, reset_int : STD_LOGIC; -- Control signals for the DataPath
    signal FN : STD_LOGIC_VECTOR(1 downto 0); -- ALU function control signal
    signal C_internal : STD_LOGIC_VECTOR(15 downto 0); -- Internal connection for result

    -- Component Declarations
    component DataPath is
        Port (
            ABorALU   : in  STD_LOGIC;
            LDA       : in  STD_LOGIC;
            LDB       : in  STD_LOGIC;
            reset_int : in  STD_LOGIC;
            FN        : in  STD_LOGIC_VECTOR (1 downto 0);
            AB        : in  STD_LOGIC_VECTOR (15 downto 0);
            C         : out STD_LOGIC_VECTOR (15 downto 0);
            N         : out STD_LOGIC;
            Z         : out STD_LOGIC;
            clk       : in  STD_LOGIC
        );
    end component;

    component StateMachine is
        Port (
            Req       : in  STD_LOGIC;
            Reset     : in  STD_LOGIC;
            N         : in  STD_LOGIC;
            Z         : in  STD_LOGIC;
            CLK       : in  STD_LOGIC;
            Ack       : out STD_LOGIC;
            ABorALU   : out STD_LOGIC;
            LDA       : out STD_LOGIC;
            LDB       : out STD_LOGIC;
            reset_int : out STD_LOGIC;
            FN        : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;

begin
    -- Instantiate the DataPath component
    DataPath_inst: DataPath
        port map (
            ABorALU   => ABorALU,   -- Control signal from StateMachine
            LDA       => LDA,       -- Load signal for Register A
            LDB       => LDB,       -- Load signal for Register B
            reset_int => reset_int, -- Reset signal from StateMachine
            FN        => FN,        -- ALU function selection from StateMachine
            AB        => AB,        -- Input data
            C         => C_internal,-- Output data
            N         => N,         -- ALU Negative flag
            Z         => Z,         -- ALU Zero flag
            clk       => CLK        -- Clock signal
        );

    -- Instantiate the StateMachine component
    StateMachine_inst: StateMachine
        port map (
            Req       => Req,       -- External request signal
            Reset     => Reset,     -- External reset signal
            N         => N,         -- Negative flag from DataPath
            Z         => Z,         -- Zero flag from DataPath
            CLK       => CLK,       -- Clock signal
            Ack       => Ack,       -- Acknowledgement signal
            ABorALU   => ABorALU,   -- Control signal for DataPath (selects ALU result or input AB)
            LDA       => LDA,       -- Load control for Register A
            LDB       => LDB,       -- Load control for Register B
            reset_int => reset_int, -- Reset signal for DataPath registers
            FN        => FN         -- ALU function control
        );

    -- Assign final output to C
    C <= C_internal;
    

end Behavioral;
