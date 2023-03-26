library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity msg_generator is
  port (
    erros   : in  std_logic_vector( 6 downto 0);
    rodada  : in  std_logic_vector( 3 downto 0);
    msg_end : in  std_logic_vector( 3 downto 0);
    hex0    : out std_logic_vector( 6 downto 0);
    hex1    : out std_logic_vector( 6 downto 0);
    hex2    : out std_logic_vector( 6 downto 0);
    hex3    : out std_logic_vector( 6 downto 0);
    hex4    : out std_logic_vector( 6 downto 0);
    hex5    : out std_logic_vector( 6 downto 0)
  ) ;
end msg_generator;

architecture arch of msg_generator is

    component rom_palavras is
        port (       
        endereco     : in  std_logic_vector(3 downto 0);
        dado_saida   : out std_logic_vector(29 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

    component encoder_letras is
        port (
          i : in  std_logic_vector(4 downto 0);
          o : out std_logic_vector(6 downto 0) 
        ) ;
    end component ;

    signal s_src       : std_logic_vector (1  downto 0);
    signal s_dado      : std_logic_vector (29 downto 0);
    signal s_enc_hex0  : std_logic_vector (6  downto 0);
    signal s_enc_hex1  : std_logic_vector (6  downto 0);
    signal s_erros_pad : std_logic_vector (7  downto 0);
    signal s_erros0    : std_logic_vector (6  downto 0);
    signal s_erros1    : std_logic_vector (6  downto 0);
    signal s_jog       : std_logic_vector (6  downto 0);

begin

    -- rom

    memPalavras: rom_palavras
        port map (
            endereco => msg_end, 
            dado_saida => s_dado
        );

    -- encoder números

    s_erros_pad <= "0" & erros; 

    HEX_ERROS0: hexa7seg -- Lower 4 bits
    port map (
        hexa => s_erros_pad(3 downto 0),
        sseg => s_erros0
    );

    HEX_ERROS1: hexa7seg -- Upper 3 bits
    port map (
        hexa => s_erros_pad(7 downto 4),
        sseg => s_erros1
    );

    HEX_JOGADAS: hexa7seg
    port map (
        hexa => rodada,
        sseg => s_jog
    );
    -- encoder letras

    HEX_PAL0: encoder_letras
        port map(
            i => s_dado(4 downto 0),
            o => s_enc_hex0
        );

    HEX_PAL1: encoder_letras
        port map(
            i => s_dado(9 downto 5),
            o => s_enc_hex1
        );

    HEX_PAL2: encoder_letras
        port map(
            i => s_dado(14 downto 10),
            o => hex2
        );
    
    HEX_PAL3: encoder_letras
        port map(
            i => s_dado(19 downto 15),
            o => hex3
        );
    
    HEX_PAL4: encoder_letras
        port map(
            i => s_dado(24 downto 20),
            o => hex4
        );

    HEX_PAL5: encoder_letras
        port map(
            i => s_dado(29 downto 25),
            o => hex5
        );

    -- lógica dos primeiros hex 
    
    s_src <= "01" when msg_end = "0110" or msg_end = "0111" else
             "10" when msg_end(3) = '1' else 
             "00";

    with s_src select hex0 <=
        s_enc_hex0 when "00",
        s_jog      when "10",
        s_erros0   when "01",
        "1111111"  when others;
    
    
    with s_src select hex1 <=
        s_enc_hex1 when "00",
        s_erros1   when "01",
        "1111111"  when others;

end arch ;