-------------------------------------------------------
--! @file shift_register.vhd
--! @brief universal shift register similar to the 74194
--! @author Joao Pedro Selva Bernardino
--! @date 2022-05-28
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
    generic (
        word_s : natural := 64
    );
    port (
        write_word    : in std_logic_vector(word_s-1 downto 0);
        right_serial  : in std_logic; -- serial input for srl
        left_serial   : in std_logic; -- serial input for sll
        clear         : in std_logic; -- async reset
        clk           : in std_logic;

        -- input mode selector (same as 74194)
        selector      : in std_logic_vector(1 downto 0); 

        read_word     : out std_logic_vector(word_s-1 downto 0)
    );
end entity;

architecture registers of shift_register is
    constant ZERO : std_logic_vector(word_s-1 downto 0) := (others => '0');

    signal value      : std_logic_vector (word_s-1 downto 0);
    signal next_value : std_logic_vector (word_s-1 downto 0); -- written to value in next clk edge
begin
    read_word <= value;

    GEN_REG:
    for i in word_s-1 downto 0 generate 
        first_reg: if i = 0 generate
            with selector select
                next_value(i) <= value(i+1)    when "01",
                                 left_serial   when "10",
                                 write_word(i) when "11",
                                 value(i)      when others;
        end generate first_reg;

        last_reg: if i = word_s-1 generate
            with selector select
                next_value(i) <= right_serial  when "01",
                                 value(i-1)    when "10",
                                 write_word(i) when "11",
                                 value(i)      when others;
        end generate last_reg;

        other_reg: if i /= 0 and i /= word_s-1 generate
            with selector select
                next_value(i) <= value(i+1)    when "01",
                                 value(i-1)    when "10",
                                 write_word(i) when "11",
                                 value(i)      when others;
            end generate other_reg;
    end generate GEN_REG;

    UPDATE:
    process (clk, clear)
    begin
        if clear ='1' then
            value(word_s-1 downto 0) <= ZERO;
        elsif rising_edge(clk) then 
            value <= next_value;
        end if;
    end process UPDATE;
end architecture;
