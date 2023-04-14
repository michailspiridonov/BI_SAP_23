library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity C_out_vhdl is
   port (
      a :  in  std_logic;
      b :  in  std_logic;
      C :  out std_logic
   );
end entity C_out_vhdl;

architecture Behavioral of C_out_vhdl is


      signal I0_0_1 :    std_logic;
      signal I1_0_1 :    std_logic;
      signal or_0_O :    std_logic;
begin
	I1_0_1 <= a;
	I0_0_1 <= b;
	C <= or_0_O;


	-- or_0
	or_0_O <= I0_0_1 or I1_0_1;

end Behavioral;
