library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity ShiftReg_vhdl is
   port (
      clk        :  in  std_logic;
      Count      :  in  std_logic;
      reset      :  in  std_logic;
      Shift_Init :  in  std_logic;
      A          :  out std_logic;
      B          :  out std_logic;
      C          :  out std_logic;
      D          :  out std_logic
   );
end entity ShiftReg_vhdl;

architecture Behavioral of ShiftReg_vhdl is


      signal ce_0_1     :    std_logic;
      signal clk_0_1    :    std_logic;
      signal dff_0_q    :    std_logic;
      signal dff_1_q    :    std_logic;
      signal dff_2_q    :    std_logic;
      signal dff_3_q    :    std_logic;
      signal I0_0_1     :    std_logic;
      signal or_0_O     :    std_logic;
      signal reset_0_1  :    std_logic;
      signal xor_0_O    :    std_logic;
begin
	clk_0_1 <= clk;
	ce_0_1 <= Count;
	reset_0_1 <= reset;
	I0_0_1 <= Shift_Init;
	A <= dff_0_q;
	B <= dff_1_q;
	C <= dff_2_q;
	D <= dff_3_q;


	-- dff_0
	process (clk_0_1)
	begin
		if rising_edge(clk_0_1) then
			if reset_0_1 = '1' then
				dff_0_q <= '0';
			elsif ce_0_1 = '1' then
				dff_0_q <= or_0_O;
			end if;
		end if;
	end process;

	-- dff_1
	process (clk_0_1)
	begin
		if rising_edge(clk_0_1) then
			if reset_0_1 = '1' then
				dff_1_q <= '0';
			elsif ce_0_1 = '1' then
				dff_1_q <= dff_0_q;
			end if;
		end if;
	end process;

	-- dff_2
	process (clk_0_1)
	begin
		if rising_edge(clk_0_1) then
			if reset_0_1 = '1' then
				dff_2_q <= '0';
			elsif ce_0_1 = '1' then
				dff_2_q <= dff_1_q;
			end if;
		end if;
	end process;

	-- dff_3
	process (clk_0_1)
	begin
		if rising_edge(clk_0_1) then
			if reset_0_1 = '1' then
				dff_3_q <= '0';
			elsif ce_0_1 = '1' then
				dff_3_q <= dff_2_q;
			end if;
		end if;
	end process;

	-- or_0
	or_0_O <= I0_0_1 or xor_0_O;

	-- xor_0
	xor_0_O <= dff_2_q xor dff_3_q;

end Behavioral;
