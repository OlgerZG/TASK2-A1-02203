library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_DataPath is
end tb_DataPath;

architecture behavior of tb_DataPath is
    -- Component declaration of DataPath
    component DataPath is
        Port (
            ABorALU : in  STD_LOGIC;  -- Select between AB or ALU result
            LDA     : in  STD_LOGIC;  -- Load control for Register A
            LDB     : in  STD_LOGIC;  -- Load control for Register B
            FN      : in  STD_LOGIC_VECTOR (1 downto 0);  -- ALU function
            AB      : in  STD_LOGIC_VECTOR (15 downto 0); -- Input data (AB)
            C       : out STD_LOGIC_VECTOR (15 downto 0); -- Output result
            N       : out STD_LOGIC;  -- Negative flag from ALU
            Z       : out STD_LOGIC;  -- Zero flag from ALU
            clk     : in  STD_LOGIC   -- Clock signal
        );
    end component;

    -- Testbench signals
    signal tb_ABorALU : STD_LOGIC := '0';  -- Select between AB or ALU result
    signal tb_LDA     : STD_LOGIC := '0';  -- Load control for Register A
    signal tb_LDB     : STD_LOGIC := '0';  -- Load control for Register B
    signal tb_FN      : STD_LOGIC_VECTOR (1 downto 0) := "00";  -- ALU function
    signal tb_AB      : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');  -- Input data (AB)
    signal tb_C       : STD_LOGIC_VECTOR (15 downto 0); -- Output result
    signal tb_N       : STD_LOGIC;  -- Negative flag from ALU
    signal tb_Z       : STD_LOGIC;  -- Zero flag from ALU
    signal tb_clk     : STD_LOGIC := '0';  -- Clock signal

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the DataPath module
    uut: DataPath
        port map (
            ABorALU => tb_ABorALU,
            LDA     => tb_LDA,
            LDB     => tb_LDB,
            FN      => tb_FN,
            AB      => tb_AB,
            C       => tb_C,
            N       => tb_N,
            Z       => tb_Z,
            clk     => tb_clk
        );

    -- Clock generation process
    clk_process : process
    begin
        tb_clk <= '0';
        wait for clk_period / 2;
        tb_clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Initialize Inputs
        tb_ABorALU <= '0';   -- Select AB as output
        tb_LDA     <= '0';
        tb_LDB     <= '0';
        tb_FN      <= "00";  -- ALU function: A - B
        tb_AB      <= (others => '0');  -- Reset AB input
        
        wait for 20 ns;

        -- Test 1: Load data into Register A and B
        tb_AB <= x"0005";  -- Set AB to 5
        tb_LDA <= '1';     -- Load Register A
        wait for clk_period;
        tb_LDA <= '0';

        tb_AB <= x"0003";  -- Set AB to 3
        tb_LDB <= '1';     -- Load Register B
        wait for clk_period;
        tb_LDB <= '0';

        -- Test 2: Perform ALU operation (A - B)
        tb_ABorALU <= '1';  -- Select ALU output
        tb_FN <= "00";      -- ALU function A - B
        wait for clk_period;
        
        -- Check output
        wait for 20 ns;

        -- Test 3: Perform ALU operation (B - A)
        tb_FN <= "01";      -- ALU function B - A
        wait for clk_period;
        
        -- Check output
        wait for 20 ns;

        -- Test 4: Pass-through A
        tb_FN <= "10";      -- ALU function pass A
        wait for clk_period;
        
        -- Check output
        wait for 20 ns;

        -- Test 5: Pass-through B
        tb_FN <= "11";      -- ALU function pass B
        wait for clk_period;
        
        -- Check output
        wait for 20 ns;

        -- Finish the simulation
        wait;
    end process;
end behavior;
