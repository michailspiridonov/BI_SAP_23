library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity D1_vhdl is
   port (
      Qa :  in  std_logic;
      Qb :  in  std_logic;
      R  :  in  std_logic;
      S  :  in  std_logic;
      b  :  out std_logic
   );
end entity D1_vhdl;

architecture Behavioral of D1_vhdl is


      signal and_0_O :    std_logic;
      signal and_1_O :    std_logic;
      signal and_2_O :    std_logic;
      signal I0_0_1  :    std_logic;
      signal I1_0_1  :    std_logic;
      signal I1_0_2  :    std_logic;
      signal I1_0_3  :    std_logic;
      signal or_0_O  :    std_logic;
begin
	I1_0_2 <= Qa;
	I1_0_1 <= Qb;
	I0_0_1 <= R;
	I1_0_3 <= S;
	b <= or_0_O;


	-- and_0
	and_0_O <= I0_0_1 and I1_0_1;

	-- and_1
	and_1_O <= I1_0_1 and not(I1_0_2);

	-- and_2
	and_2_O <= not(I0_0_1) and I1_0_3 and I1_0_2 and not(I1_0_1);

	-- or_0
	or_0_O <= and_0_O or and_1_O or and_2_O;

end Behavioral;
