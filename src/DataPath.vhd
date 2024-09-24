library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity DataPath is
    Port (
        ABorALU   : in  STD_LOGIC;  -- Select between AB or ALU result
        LDA       : in  STD_LOGIC;  -- Load control for Register A
        LDB       : in  STD_LOGIC;  -- Load control for Register B
        reset_int : in  STD_LOGIC;  -- Select the reset botton
        FN        : in  STD_LOGIC_VECTOR (1 downto 0);  -- ALU function
        AB        : in  STD_LOGIC_VECTOR (15 downto 0); -- Input data (AB)
        C         : out STD_LOGIC_VECTOR (15 downto 0); -- Output result
        N         : out STD_LOGIC;  -- Negative flag from ALU
        Z         : out STD_LOGIC;  -- Zero flag from ALU
        clk       : in  STD_LOGIC   -- Clock signal
    );
end DataPath;

architecture Struct of DataPath is
    -- Component declarations
    component ALU is
        Port (
            A  : in  STD_LOGIC_VECTOR (15 downto 0);
            B  : in  STD_LOGIC_VECTOR (15 downto 0);
            Y  : out STD_LOGIC_VECTOR (15 downto 0);
            N  : out STD_LOGIC;
            Z  : out STD_LOGIC;
            FN : in  STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;

    component MUX is 
        Port (
            AB       : in  STD_LOGIC_VECTOR (15 downto 0);
            Y        : in  STD_LOGIC_VECTOR (15 downto 0);
            ABorALU  : in  STD_LOGIC;
            C        : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    component Reg is
        Port (
            C       : in  STD_LOGIC_VECTOR (15 downto 0);
            Selc    : in  STD_LOGIC;
            clk     : in  STD_LOGIC;
            reset_int : in STD_LOGIC;
            Operator: out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Internal signals
    signal A, B, Y, C_internal : STD_LOGIC_VECTOR (15 downto 0);  -- Signals for ALU inputs and output
    signal OpA, OpB : STD_LOGIC_VECTOR (15 downto 0); -- Outputs from registers A and B

begin
    -- Instantiating the Register A
    Reg_A: Reg
        port map (
            C => C_internal,          -- Input data (AB) to the register
            Selc => LDA,      -- Load signal for Register A
            clk => clk,       -- Clock
            reset_int => reset_int,  -- Reset botton
            Operator => OpA   -- Output from Register A
        );

    -- Instantiating the Register B
    Reg_B: Reg
        port map (
            C => C_internal,          -- Input data (AB) to the register
            Selc => LDB,      -- Load signal for Register B
            clk => clk,       -- Clock
            reset_int => reset_int,  -- Reset botton
            Operator => OpB   -- Output from Register B
        );

    -- Instantiating the ALU
    ALU_Inst: ALU
        port map (
            A => OpA,         -- Input A to ALU from Register A
            B => OpB,         -- Input B to ALU from Register B
            Y => Y,           -- ALU output
            N => N,           -- Negative flag output
            Z => Z,           -- Zero flag output
            FN => FN          -- ALU function selection
        );

    -- Instantiating the MUX (to select between AB and ALU result)
    MUX_Inst: MUX
        port map (
            AB => AB,         -- Input AB to MUX
            Y => Y,           -- ALU output to MUX
            ABorALU => ABorALU, -- Control signal for selecting AB or ALU output
            C => C_internal            -- MUX output (final output)
        );
        
     C <= C_internal;
end Struct;
