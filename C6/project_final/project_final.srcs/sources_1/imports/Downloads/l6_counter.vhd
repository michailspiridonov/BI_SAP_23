library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity counter is
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        enable : in  std_logic;
        en_out : out std_logic
    );
end counter;

architecture behavioral of counter is

    constant clk_freq : integer := 100000000;
    constant one_tick : integer := clk_freq;

    signal sig_counter : integer range 0 to one_tick;

    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER OF rst: SIGNAL IS "XIL_INTERFACENAME Reset, POLARITY ACTIVE_HIGH";

begin

    en_out <= '1' when sig_counter=one_tick else '0';

    proc_counter : process(clk, rst, enable)
    begin
        if (rst='1') then
            sig_counter <= 0;
        elsif (clk='1' and clk'event and enable='1') then
            sig_counter <= sig_counter + 1;
            if (sig_counter=one_tick) then
                sig_counter <= 0;
            end if;
        end if;
    end process;

end;
