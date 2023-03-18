library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity note_generator is
    port (
        -- inputs
        clk             : in std_logic;
        gera            : in std_logic; 
        reset           : in std_logic;
        mascara         : in std_logic_vector(11 downto 0);
        para_de_gerar   : in std_logic;
        -- output
        nota            : out std_logic_vector(11 downto 0)
    );
end entity;

architecture arch of note_generator is
    component shift_register is
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
    end component;
    
    component decoder4x16 is
        port (
            I : std_logic_vector(3 downto 0);
            O : std_logic_vector(15 downto 0)
        );
    end component;

    component registrador_n is
        generic (
            constant N: integer := 8;
            constant reset_value: integer := 0
        );
        port (
            clock  : in  std_logic;
            clear  : in  std_logic;
            enable : in  std_logic;
            D      : in  std_logic_vector (N-1 downto 0);
            Q      : out std_logic_vector (N-1 downto 0) 
        );
    end component;

    signal s_write_word   : std_logic_vector(15 downto 0);
    signal s_right_serial : std_logic;
    signal s_left_serial  : std_logic;
    signal s_clear        : std_logic;
    signal s_clk          : std_logic;
    signal s_selector     : std_logic_vector(1 downto 0); 
    signal saida_lfsr     : std_logic_vector(15 downto 0);
    signal saida_decoder  : std_logic_vector(15 downto 0);
    signal saida_decoder_masked  : std_logic_vector(11 downto 0);
    signal nota_compativel : std_logic; 
    signal enable_reg : std_logic; 
begin
    shft: shift_register
        generic map (
            word_s => 16 
        )
        port map (
            write_word => s_write_word,
            right_serial => s_right_serial,
            left_serial => '0',
            clear => '0',
            clk => clk,
            selector => s_selector,
            read_word => saida_lfsr
        );

    dec: decoder4x16
        port map (
            I => saida_lfsr(15 downto 12),
            O => saida_decoder
        );

    regnota: registrador_n
        generic map (
            N => 12,
            reset_value => 1 -- do
        )
        port map (
            clock => clk,
            clear => '0',
            enable => enable_reg,
            D => saida_decoder(11 downto 0),
            Q => nota
        );

    s_right_serial <= s_write_word(10) XOR s_write_word(12) XOR 
                      s_write_word(13) XOR s_write_word(15);
    s_selector <= '1' & reset;          -- always shift right, load when reset = 1
    s_write_word <= "0011001100110011"; -- super random secret seed ;)
    saida_decoder_masked <= saida_decoder(11 downto 0) AND mascara;

    nota_compativel <= saida_decoder_masked(0)  OR
                       saida_decoder_masked(1)  OR
                       saida_decoder_masked(2)  OR
                       saida_decoder_masked(3)  OR
                       saida_decoder_masked(4)  OR
                       saida_decoder_masked(5)  OR
                       saida_decoder_masked(6)  OR
                       saida_decoder_masked(7)  OR
                       saida_decoder_masked(8)  OR
                       saida_decoder_masked(9)  OR
                       saida_decoder_masked(10) OR
                       saida_decoder_masked(11);

    enable_reg <= nota_compativel AND (NOT para_de_gerar);
end architecture;
