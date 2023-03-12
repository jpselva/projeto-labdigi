library ieee;
use ieee.std_logic_1164.all;

entity encoder16x4 is
    port (
        I : in  std_logic_vector(15 downto 0);
        O : out std_logic_vector(3 downto 0)
    );
end entity;

architecture dumb of encoder16x4 is
begin
    O <= "0000" when I(0)='1' else
         "0001" when I(1)='1' else
         "0010" when I(2)='1' else
         "0011" when I(3)='1' else
         "0100" when I(4)='1' else
         "0101" when I(5)='1' else
         "0110" when I(6)='1' else
         "0111" when I(7)='1' else
         "1000" when I(8)='1' else
         "1001" when I(9)='1' else
         "1010" when I(10)='1' else
         "1011" when I(11)='1' else
         "1100" when I(12)='1' else
         "1101" when I(13)='1' else
         "1110" when I(14)='1' else
         "1111" when I(15)='1' else
         "0000";
end architecture;
