library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity lab_2_bd_vhdl is
   port (
      a :  in  std_logic;
      b :  in  std_logic;
      c :  in  std_logic;
      d :  in  std_logic;
      f :  out std_logic
   );
end entity lab_2_bd_vhdl;

architecture Behavioral of lab_2_bd_vhdl is


      signal and_0_O :    std_logic;
      signal and_1_O :    std_logic;
      signal and_2_O :    std_logic;
      signal and_3_O :    std_logic;
      signal and_4_O :    std_logic;
      signal I0_0_1  :    std_logic;
      signal I0_0_2  :    std_logic;
      signal I0_0_3  :    std_logic;
      signal I_0_1   :    std_logic;
      signal inv_0_O :    std_logic;
      signal or_0_O  :    std_logic;
      signal or_1_O  :    std_logic;
begin
	I_0_1 <= a;
	I0_0_3 <= b;
	I0_0_1 <= c;
	I0_0_2 <= d;
	f <= or_1_O;


	-- and_0
	and_0_O <= I0_0_1 and inv_0_O;

	-- and_1
	and_1_O <= I0_0_2 and I0_0_1;

	-- and_2
	and_2_O <= and_1_O and and_0_O;

	-- and_3
	and_3_O <= I0_0_3 and I_0_1;

	-- and_4
	and_4_O <= I0_0_1 and I0_0_3;

	-- inv_0
	inv_0_O <= not(I_0_1);

	-- or_0
	or_0_O <= and_4_O or and_3_O;

	-- or_1
	or_1_O <= or_0_O or and_2_O;

end Behavioral;
