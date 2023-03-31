library IEEE;
use IEEE.std_logic_1164.all;

entity decoder_7seg_f is
    port(
        a   : in  std_logic;
        b   : in  std_logic;
        c   : in  std_logic;
        d   : in  std_logic;
        f_a : out std_logic;
        f_b : out std_logic;
        f_c : out std_logic;
        f_d : out std_logic;
        f_e : out std_logic;
        f_f : out std_logic;
        f_g : out std_logic
    );
end decoder_7seg_f;

architecture behavioral of decoder_7seg_f is

    signal input  : std_logic_vector (3 downto 0);
    signal output : std_logic_vector (6 downto 0);

begin

    input(3) <= d;
    input(2) <= c;
    input(1) <= b;
    input(0) <= a;

    f_a <= output(0);
    f_b <= output(1);
    f_c <= output(2);
    f_d <= output(3);
    f_e <= output(4);
    f_f <= output(5);
    f_g <= output(6);

    with input select
    output <= "1000000" when "0000", -- 0
              "1111001" when "0001", -- 1
              "0100100" when "0010", -- 2
              "0110000" when "0011", -- 3
              "0011001" when "0100", -- 4
              "0010010" when "0101", -- 5
              "0000010" when "0110", -- 6
              "1111000" when "0111", -- 7
              "0000000" when "1000", -- 8
              "0010000" when "1001", -- 9
              "0001000" when "1010", -- A
              "0000011" when "1011", -- b
              "1000110" when "1100", -- C
              "0100001" when "1101", -- d
              "0000110" when "1110", -- E
              "0001110" when "1111", -- F
              "1000000" when others; -- else

end;
