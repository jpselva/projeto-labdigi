library ieee;
use ieee.std_logic_1164.all;

entity encoder_letras is
  port (
    i : in  std_logic_vector(4 downto 0);
    o : out std_logic_vector(6 downto 0) 
  ) ;
end encoder_letras ;

architecture dumb of encoder_letras is
  -- signal s_o : std_logic;
begin
  with i select o <=
  "0001000" when "00001", -- A
  "0000011" when "00010", -- B
  "1000110" when "00011", -- C
  "0100001" when "00100", -- D
  "0000110" when "00101", -- E
  "0001110" when "00110", -- F
  "1000010" when "00111", -- G
  "0001011" when "01000", -- H
  "1111001" when "01001", -- I
  "1100001" when "01010", -- J
  "0001010" when "01011", -- K
  "1000111" when "01100", -- L
  "0101010" when "01101", -- M
  "0101011" when "01110", -- N
  "0100011" when "01111", -- O
  "0001100" when "10000", -- P
  "0011000" when "10001", -- Q
  "0101111" when "10010", -- R
  "0010010" when "10011", -- S
  "0000111" when "10100", -- T
  "1000001" when "10101", -- U
  "1100011" when "10110", -- V
  "0010101" when "10111", -- W
  "0001001" when "11000", -- X
  "0010001" when "11001", -- Y
  "0100100" when "11010", -- Z
  -- outros simbolos 
  "1111111" when "00000", -- 
  "1111111" when "11011", -- 
  "1111111" when "11100", -- 
  "1111111" when "11101", -- 
  "1111111" when "11110", -- 
  "1111111" when "11111", -- 
  "1111111" when others;

end architecture ; 