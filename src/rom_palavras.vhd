library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_palavras is
   port (       
       endereco     : in  std_logic_vector(3 downto 0);
       dado_saida   : out std_logic_vector(29 downto 0)
    );
end entity rom_palavras;

architecture rom_dumb of rom_palavras is

begin
  -- saida da rom
  with endereco select dado_saida <=
   "000000000000000000000000000000" when "0000", -- ------
   "000100010100111010010111000000" when "0001", -- BEGIN-
   "100110010101100001010001110100" when "0010", -- SELECT
   "100100100100111010001010000000" when "0011", -- RIGHT-
   "101111001001111011100011100000" when "0100", -- WRONG-
   "101110100001001000110100000000" when "0101", -- WHICH-
   "001010111000100000000000000000" when "0110", -- END-NN
   "001011001010010000000000000000" when "0111", -- ERR-NN
   "010100111100111000000000000000" when "1000", -- JOG-NN
   "000000000000000000000000000000" when "1001", -- ------
   "000000000000000000000000000000" when "1010", -- ------
   "000000000000000000000000000000" when "1011", -- ------
   "000000000000000000000000000000" when "1100", -- ------
   "000000000000000000000000000000" when "1101", -- ------
   "000000000000000000000000000000" when "1110", -- ------
   "000000000000000000000000000000" when "1111", -- ------
   "000000000000000000000000000000" when others; -- ------

end architecture rom_dumb;
