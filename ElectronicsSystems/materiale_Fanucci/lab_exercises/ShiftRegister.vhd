library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftRegister is
	generic (Nbit : positive := 8);
	port (
		din 	: in	std_logic;
		clk	: in 	std_logic;
		resetn	: in 	std_logic;
		dout	: out 	std_logic
	);
end ShiftRegister;

architecture rtl of ShiftRegister is


component DFC 
	port (
		d 	: in 	std_logic;
	    	clk 	: in 	std_logic;
		resetn  : in 	std_logic;
        	q	: out   std_logic
	);
end component DFC;

signal q_s : std_logic_vector (Nbit-1 downto 1);

begin
	GEN : for i in 1 to Nbit generate
		FIRST : if i = 1 generate
			FF1 : DFC port map (clk, resetn, din, q_s(i));
		end generate FIRST;

		INTERNAL : if i > 1 and i < Nbit generate
			FFI : DFC port map (clk, resetn, q_s(i - 1), q_s(i));
		end generate INTERNAL;

		LAST : if i = Nbit generate
			FFL : DFC port map (clk, resetn, q_s(i - 1), dout);
		end generate LAST;
	end generate GEN;
end rtl;
	