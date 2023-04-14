library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity S_out_vhdl is
   port (
      a :  in  std_logic;
      b :  in  std_logic;
      S :  out std_logic
   );
end entity S_out_vhdl;

architecture Behavioral of S_out_vhdl is


      signal and_0_O :    std_logic;
      signal I0_0_1  :    std_logic;
      signal I1_0_1  :    std_logic;
begin
	I1_0_1 <= a;
	I0_0_1 <= b;
	S <= and_0_O;


	-- and_0
	and_0_O <= not(I0_0_1) and I1_0_1;

end Behavioral;
