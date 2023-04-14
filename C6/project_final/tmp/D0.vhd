library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity D0_vhdl is
   port (
      Qa :  in  std_logic;
      Qb :  in  std_logic;
      R  :  in  std_logic;
      S  :  in  std_logic;
      a  :  out std_logic
   );
end entity D0_vhdl;

architecture Behavioral of D0_vhdl is


      signal and_0_O :    std_logic;
      signal I0_0_1  :    std_logic;
      signal I1_0_1  :    std_logic;
      signal I1_0_2  :    std_logic;
      signal I2_0_1  :    std_logic;
      signal or_0_O  :    std_logic;
begin
	I0_0_1 <= Qa;
	I1_0_1 <= Qb;
	I1_0_2 <= R;
	I2_0_1 <= S;
	a <= or_0_O;


	-- and_0
	and_0_O <= I0_0_1 and not(I1_0_1) and not(I2_0_1);

	-- or_0
	or_0_O <= and_0_O or I1_0_2;

end Behavioral;
