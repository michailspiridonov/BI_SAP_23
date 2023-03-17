library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity gates_vhdl is
   port (
      A :  in  std_logic;
      B :  in  std_logic;
      C :  in  std_logic;
      D :  in  std_logic;
      E :  in  std_logic;
      F :  in  std_logic;
      G :  in  std_logic;
      H :  in  std_logic;
      P :  out std_logic;
      Q :  out std_logic;
      R :  out std_logic;
      S :  out std_logic
   );
end entity gates_vhdl;

architecture Behavioral of gates_vhdl is


      signal and_0_O :    std_logic;
      signal and_1_O :    std_logic;
      signal I0_0_1  :    std_logic;
      signal I0_0_2  :    std_logic;
      signal I0_1_1  :    std_logic;
      signal I0_2_1  :    std_logic;
      signal I1_0_1  :    std_logic;
      signal I1_0_2  :    std_logic;
      signal I1_1_1  :    std_logic;
      signal I1_2_1  :    std_logic;
      signal or_0_O  :    std_logic;
      signal xor_0_O :    std_logic;
begin
	I0_0_1 <= A;
	I1_0_1 <= B;
	I0_0_2 <= C;
	I1_0_2 <= D;
	I0_2_1 <= E;
	I1_2_1 <= F;
	I0_1_1 <= G;
	I1_1_1 <= H;
	P <= and_1_O;
	Q <= and_0_O;
	R <= or_0_O;
	S <= xor_0_O;


	-- and_0
	and_0_O <= I0_0_2 and I1_0_2;

	-- and_1
	and_1_O <= not(I0_0_1 and I1_0_1);

	-- or_0
	or_0_O <= I0_2_1 or I1_2_1;

	-- xor_0
	xor_0_O <= I0_1_1 xor I1_1_1;

end Behavioral;
