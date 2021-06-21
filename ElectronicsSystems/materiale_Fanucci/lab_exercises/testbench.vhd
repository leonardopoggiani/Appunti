library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder_tb is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end fullAdder_tb;

architecture bhv of fullAdder_tb is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns; -- Period before the reset deassertion
	-----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
	signal a_tb		: std_logic := '0'; -- first operand 
	signal b_tb		: std_logic := '0'; -- second operand 
	signal c_i_tb	: std_logic := '0'; -- carry in 
	signal o_tb		: std_logic; 		-- sum output 
	signal c_o_tb	: std_logic; 		-- carry out output 
	
	signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '0'; -- reset signal	
	signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
    -----------------------------------------------------------------------------------
    -- Component to test (DUT) declaration
    -----------------------------------------------------------------------------------
    component fullAdder is      -- be careful, it is only a component declaration. The component shall be instantiated after the keyword "begin" by linking the gates with the testbench signals for the test
		port(
                a   : in std_logic;
                b   : in std_logic;
                c_i : in std_logic;
                o   : out std_logic;
                c_o : out std_logic
	       );
	end component;
	
	
	begin
	
	  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	  rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
	  
	  test_fullAdder: fullAdder  -- FullAdder instantiation
	   port map(
			a       => a_tb,
			b       => b_tb,
			c_i     => c_i_tb,
	        o 	=> o_tb,
			c_o		=> c_o_tb
		);
	  
	  -- ******************************************************
	  -- * Even if fullAdder is a pure combinational circuit
	  -- * it is possible to use a clock signal within the tb
	  -- * just for keep trace of the execution time of the 
	  -- * simulation and to provide input vectors to the DUT
	  -- ******************************************************
	  
	  d_process: process(clk_tb, rst_tb) -- process used to make the testbench signals change synchronously with the rising edge of the clock
		variable t : integer := 0; -- variable used to count the clock cycle after the reset
	  begin
	    if(rst_tb = '0') then
		  a_tb 	<= '0';
		  b_tb 	<= '0';
		  c_i_tb 	<= '0';	-- not changed during simulation
		  t := 0;
		elsif(rising_edge(clk_tb)) then
		  case(t) is   -- specifying the input a_tb, b_tb and end_sim depending on the value of t ( and so on the number of the passed clock cycles).
		    when 1 => a_tb <= '0'; b_tb <= '0';
			
			when 2 => a_tb <= '0'; b_tb <= '1';
			
			when 3 => a_tb <= '1'; b_tb <= '0';
			
			when 4 => a_tb <= '1'; b_tb <= '1';
			
			when 10 => end_sim <= '0'; -- This command stops the simulation when t = 10
            when others => null; -- Specifying that nothing happens in the other cases 
			
		  end case;
		  t := t + 1; -- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
		end if;
	  end process;
	
end bhv;