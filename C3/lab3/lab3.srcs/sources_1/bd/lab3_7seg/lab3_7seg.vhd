library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity lab3_7seg_vhdl is
   port (
      A0_0   :  in  std_logic;
      A1_0   :  in  std_logic;
      A2_0   :  in  std_logic;
      A3_0   :  in  std_logic;
      B0_0   :  in  std_logic;
      B1_0   :  in  std_logic;
      B2_0   :  in  std_logic;
      B3_0   :  in  std_logic;
      Cin_0  :  in  std_logic;
      an0_0  :  out std_logic;
      Cout_0 :  out std_logic;
      f_a_0  :  out std_logic;
      f_b_0  :  out std_logic;
      f_c_0  :  out std_logic;
      f_d_0  :  out std_logic;
      f_e_0  :  out std_logic;
      f_f_0  :  out std_logic;
      f_g_0  :  out std_logic
   );
end entity lab3_7seg_vhdl;

architecture Behavioral of lab3_7seg_vhdl is
	component adder4_vhdl
		port (
			A0   :  in  std_logic;
			A1   :  in  std_logic;
			A2   :  in  std_logic;
			A3   :  in  std_logic;
			B0   :  in  std_logic;
			B1   :  in  std_logic;
			B2   :  in  std_logic;
			B3   :  in  std_logic;
			Cin  :  in  std_logic;
			Cout :  out std_logic;
			S0   :  out std_logic;
			S1   :  out std_logic;
			S2   :  out std_logic;
			S3   :  out std_logic
		);
	end component;

	component decoder_7seg
		port (
			a   :  in  std_logic;
			b   :  in  std_logic;
			c   :  in  std_logic;
			d   :  in  std_logic;
			an0 :  out std_logic;
			f_a :  out std_logic;
			f_b :  out std_logic;
			f_c :  out std_logic;
			f_d :  out std_logic;
			f_e :  out std_logic;
			f_f :  out std_logic;
			f_g :  out std_logic
		);
	end component;



      signal A0_0_1             :    std_logic;      
      signal A1_0_1             :    std_logic;      
      signal A2_0_1             :    std_logic;      
      signal A3_0_1             :    std_logic;      
      signal adder4_vhdl_0_Cout :    std_logic;      
      signal adder4_vhdl_0_S0   :    std_logic;      
      signal adder4_vhdl_0_S1   :    std_logic;      
      signal adder4_vhdl_0_S2   :    std_logic;      
      signal adder4_vhdl_0_S3   :    std_logic;      
      signal B0_0_1             :    std_logic;      
      signal B1_0_1             :    std_logic;      
      signal B2_0_1             :    std_logic;      
      signal B3_0_1             :    std_logic;      
      signal Cin_0_1            :    std_logic;      
      signal decoder_7seg_0_an0 :    std_logic;      
      signal decoder_7seg_0_f_a :    std_logic;      
      signal decoder_7seg_0_f_b :    std_logic;      
      signal decoder_7seg_0_f_c :    std_logic;      
      signal decoder_7seg_0_f_d :    std_logic;      
      signal decoder_7seg_0_f_e :    std_logic;      
      signal decoder_7seg_0_f_f :    std_logic;      
      signal decoder_7seg_0_f_g :    std_logic;      
begin
	A0_0_1 <= A0_0;
	A1_0_1 <= A1_0;
	A2_0_1 <= A2_0;
	A3_0_1 <= A3_0;
	B0_0_1 <= B0_0;
	B1_0_1 <= B1_0;
	B2_0_1 <= B2_0;
	B3_0_1 <= B3_0;
	Cin_0_1 <= Cin_0;
	an0_0 <= decoder_7seg_0_an0;
	Cout_0 <= adder4_vhdl_0_Cout;
	f_a_0 <= decoder_7seg_0_f_a;
	f_b_0 <= decoder_7seg_0_f_b;
	f_c_0 <= decoder_7seg_0_f_c;
	f_d_0 <= decoder_7seg_0_f_d;
	f_e_0 <= decoder_7seg_0_f_e;
	f_f_0 <= decoder_7seg_0_f_f;
	f_g_0 <= decoder_7seg_0_f_g;


	-- adder4_vhdl_0
	inst_adder4_vhdl_0 : adder4_vhdl
		port map (
			A0   =>  A0_0_1,
			A1   =>  A1_0_1,
			A2   =>  A2_0_1,
			A3   =>  A3_0_1,
			B0   =>  B0_0_1,
			B1   =>  B1_0_1,
			B2   =>  B2_0_1,
			B3   =>  B3_0_1,
			Cin  =>  Cin_0_1,
			Cout =>  adder4_vhdl_0_Cout,
			S0   =>  adder4_vhdl_0_S0,
			S1   =>  adder4_vhdl_0_S1,
			S2   =>  adder4_vhdl_0_S2,
			S3   =>  adder4_vhdl_0_S3
		);

	-- decoder_7seg_0
	inst_decoder_7seg_0 : decoder_7seg
		port map (
			a   =>  adder4_vhdl_0_S3,
			b   =>  adder4_vhdl_0_S2,
			c   =>  adder4_vhdl_0_S1,
			d   =>  adder4_vhdl_0_S0,
			an0 =>  decoder_7seg_0_an0,
			f_a =>  decoder_7seg_0_f_a,
			f_b =>  decoder_7seg_0_f_b,
			f_c =>  decoder_7seg_0_f_c,
			f_d =>  decoder_7seg_0_f_d,
			f_e =>  decoder_7seg_0_f_e,
			f_f =>  decoder_7seg_0_f_f,
			f_g =>  decoder_7seg_0_f_g
		);

end Behavioral;
