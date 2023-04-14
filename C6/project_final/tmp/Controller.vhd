library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity Controller_vhdl is
   port (
      clk        :  in  std_logic;
      reset      :  in  std_logic;
      Roll       :  in  std_logic;
      Shift      :  in  std_logic;
      Count_En   :  out std_logic;
      Shift_Init :  out std_logic
   );
end entity Controller_vhdl;

architecture Behavioral of Controller_vhdl is
	component C_out_vhdl
		port (
			a :  in  std_logic;
			b :  in  std_logic;
			C :  out std_logic
		);
	end component;

	component D0_vhdl
		port (
			Qa :  in  std_logic;
			Qb :  in  std_logic;
			R  :  in  std_logic;
			S  :  in  std_logic;
			a  :  out std_logic
		);
	end component;

	component D1_vhdl
		port (
			Qa :  in  std_logic;
			Qb :  in  std_logic;
			R  :  in  std_logic;
			S  :  in  std_logic;
			b  :  out std_logic
		);
	end component;

	component S_out_vhdl
		port (
			a :  in  std_logic;
			b :  in  std_logic;
			S :  out std_logic
		);
	end component;



      signal C_out_vhdl_0_C :    std_logic;  
      signal clk_1          :    std_logic;  
      signal D0_vhdl_0_a    :    std_logic;  
      signal D1_vhdl_0_b    :    std_logic;  
      signal dff_0_q        :    std_logic;  
      signal dff_1_q        :    std_logic;  
      signal reset_1        :    std_logic;  
      signal Roll_1         :    std_logic;  
      signal S_0_1          :    std_logic;  
      signal S_out_vhdl_0_S :    std_logic;  
begin
	clk_1 <= clk;
	reset_1 <= reset;
	Roll_1 <= Roll;
	S_0_1 <= Shift;
	Count_En <= C_out_vhdl_0_C;
	Shift_Init <= S_out_vhdl_0_S;


	-- C_out_vhdl_0
	inst_C_out_vhdl_0 : C_out_vhdl
		port map (
			a =>  dff_0_q,
			b =>  dff_1_q,
			C =>  C_out_vhdl_0_C
		);

	-- D0_vhdl_0
	inst_D0_vhdl_0 : D0_vhdl
		port map (
			Qa =>  dff_0_q,
			Qb =>  dff_1_q,
			R  =>  Roll_1,
			S  =>  S_0_1,
			a  =>  D0_vhdl_0_a
		);

	-- D1_vhdl_0
	inst_D1_vhdl_0 : D1_vhdl
		port map (
			Qa =>  dff_0_q,
			Qb =>  dff_1_q,
			R  =>  Roll_1,
			S  =>  S_0_1,
			b  =>  D1_vhdl_0_b
		);

	-- dff_0
	process (clk_1)
	begin
		if rising_edge(clk_1) then
			if reset_1 = '1' then
				dff_0_q <= '0';
			else
				dff_0_q <= D0_vhdl_0_a;
			end if;
		end if;
	end process;

	-- dff_1
	process (clk_1)
	begin
		if rising_edge(clk_1) then
			if reset_1 = '1' then
				dff_1_q <= '0';
			else
				dff_1_q <= D1_vhdl_0_b;
			end if;
		end if;
	end process;

	-- S_out_vhdl_0
	inst_S_out_vhdl_0 : S_out_vhdl
		port map (
			a =>  dff_0_q,
			b =>  dff_1_q,
			S =>  S_out_vhdl_0_S
		);

end Behavioral;
