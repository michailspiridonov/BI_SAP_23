library IEEE;
use IEEE.std_logic_1164.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity ShiftTest_vhdl is
   port (
      Btn           :  in  std_logic;
      clk           :  in  std_logic;
      CounterEnable :  in  std_logic;
      reset         :  in  std_logic;
      f_a_0         :  out std_logic;
      f_b_0         :  out std_logic;
      f_c_0         :  out std_logic;
      f_d_0         :  out std_logic;
      f_e_0         :  out std_logic;
      f_f_0         :  out std_logic;
      f_g_0         :  out std_logic
   );
end entity ShiftTest_vhdl;

architecture Behavioral of ShiftTest_vhdl is
	component counter
		port (
			clk    :  in  std_logic;
			enable :  in  std_logic;
			rst    :  in  std_logic;
			en_out :  out std_logic
		);
	end component;

	component decoder_7seg_f
		port (
			a   :  in  std_logic;
			b   :  in  std_logic;
			c   :  in  std_logic;
			d   :  in  std_logic;
			f_a :  out std_logic;
			f_b :  out std_logic;
			f_c :  out std_logic;
			f_d :  out std_logic;
			f_e :  out std_logic;
			f_f :  out std_logic;
			f_g :  out std_logic
		);
	end component;

	component ShiftReg_vhdl
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
	end component;

	component debounce
		generic (
			width: integer := 22
		);
		port (
			clk    : in  std_logic;
			tl_in  : in  std_logic;
			tl_out : out std_logic
		);
	end component;


      signal Btn_1                :    std_logic;        
      signal counter_0_en_out     :    std_logic;        
      signal CounterEnable_1      :    std_logic;        
      signal debounce_0_tl_out    :    std_logic;        
      signal debounce_1_tl_out    :    std_logic;        
      signal decoder_7seg_f_0_f_a :    std_logic;        
      signal decoder_7seg_f_0_f_b :    std_logic;        
      signal decoder_7seg_f_0_f_c :    std_logic;        
      signal decoder_7seg_f_0_f_d :    std_logic;        
      signal decoder_7seg_f_0_f_e :    std_logic;        
      signal decoder_7seg_f_0_f_f :    std_logic;        
      signal decoder_7seg_f_0_f_g :    std_logic;        
      signal hodiny_0_mux_sel     :    std_logic;        
      signal reset_0_1            :    std_logic;        
      signal ShiftReg_vhdl_0_A    :    std_logic;        
      signal ShiftReg_vhdl_0_B    :    std_logic;        
      signal ShiftReg_vhdl_0_C    :    std_logic;        
      signal ShiftReg_vhdl_0_D    :    std_logic;        
begin
	Btn_1 <= Btn;
	hodiny_0_mux_sel <= clk;
	CounterEnable_1 <= CounterEnable;
	reset_0_1 <= reset;
	f_a_0 <= decoder_7seg_f_0_f_a;
	f_b_0 <= decoder_7seg_f_0_f_b;
	f_c_0 <= decoder_7seg_f_0_f_c;
	f_d_0 <= decoder_7seg_f_0_f_d;
	f_e_0 <= decoder_7seg_f_0_f_e;
	f_f_0 <= decoder_7seg_f_0_f_f;
	f_g_0 <= decoder_7seg_f_0_f_g;


	-- counter_0
	inst_counter_0 : counter
		port map (
			clk    =>  hodiny_0_mux_sel,
			enable =>  debounce_1_tl_out,
			rst    =>  reset_0_1,
			en_out =>  counter_0_en_out
		);

	-- debounce_0
	debounce_0 : debounce
		generic map (
			width => 22
		)
		port map (
			clk	=> hodiny_0_mux_sel,
			tl_in	=> Btn_1,
			tl_out	=> debounce_0_tl_out
		);

	-- debounce_1
	debounce_1 : debounce
		generic map (
			width => 22
		)
		port map (
			clk	=> hodiny_0_mux_sel,
			tl_in	=> CounterEnable_1,
			tl_out	=> debounce_1_tl_out
		);

	-- decoder_7seg_f_0
	inst_decoder_7seg_f_0 : decoder_7seg_f
		port map (
			a   =>  ShiftReg_vhdl_0_A,
			b   =>  ShiftReg_vhdl_0_B,
			c   =>  ShiftReg_vhdl_0_C,
			d   =>  ShiftReg_vhdl_0_D,
			f_a =>  decoder_7seg_f_0_f_a,
			f_b =>  decoder_7seg_f_0_f_b,
			f_c =>  decoder_7seg_f_0_f_c,
			f_d =>  decoder_7seg_f_0_f_d,
			f_e =>  decoder_7seg_f_0_f_e,
			f_f =>  decoder_7seg_f_0_f_f,
			f_g =>  decoder_7seg_f_0_f_g
		);

	-- ShiftReg_vhdl_0
	inst_ShiftReg_vhdl_0 : ShiftReg_vhdl
		port map (
			clk        =>  hodiny_0_mux_sel,
			Count      =>  counter_0_en_out,
			reset      =>  reset_0_1 ,
			Shift_Init =>  debounce_0_tl_out,
			A          =>  ShiftReg_vhdl_0_A,
			B          =>  ShiftReg_vhdl_0_B,
			C          =>  ShiftReg_vhdl_0_C,
			D          =>  ShiftReg_vhdl_0_D
		);

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity debounce is
    generic (
		width: integer := 22 -- 100 MHz clock -> 4 - simulation (90 ns); 22 - synthesis (ca. 20 ms)
	);
    port (
		clk : in STD_LOGIC;
        tl_in : in STD_LOGIC;
        tl_out : out STD_LOGIC
	);
end entity debounce;

architecture Behavioral of debounce is

signal cnt       : std_logic_vector(width-1 downto 0) := (others => '0');
signal reset, ce : std_logic := '0';
signal tl_prev   : std_logic := '0';


begin

    counter: process(clk) begin
        if rising_edge(clk) then 
            if (reset = '1') then
                cnt <= (others => '0');
            elsif (ce = '1') then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    process(clk) begin
        if rising_edge(clk) then
            if (tl_prev /= tl_in) then
                reset <= '1';
            else 
                reset <= '0';
            end if;
        end if;
    end process;
                
    process(clk) begin
        if rising_edge(clk) then
            if (reset = '1') then
                tl_prev <= tl_in;
            end if;
        end if;
    end process;
                
    process(clk) begin
        if rising_edge(clk) then
            if ((cnt(width-1) = '1') and (cnt(0) = '0')) then
                tl_out <= tl_prev;
            end if;
        end if;
    end process;
                

    ce <= '0' when ((cnt(width-1) = '1') and (cnt(0) = '1'))
                else '1';

end Behavioral;

