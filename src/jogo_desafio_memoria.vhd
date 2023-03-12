library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity jogo_desafio_memoria is
    port (
        -- inputs
        clock   : in std_logic;
        reset   : in std_logic;
        iniciar : in std_logic;
        botoes  : in std_logic_vector (3 downto 0);

        -- outputs
        leds    : out std_logic_vector (3 downto 0);
        pronto  : out std_logic;
        acertou : out std_logic;
        errou   : out std_logic;

        -- debug
        db_jogada_correta        : out std_logic;
        db_endereco_igual_rodada : out std_logic;
        db_contagem              : out std_logic_vector (6 downto 0);
        db_memoria               : out std_logic_vector (6 downto 0);
        db_estado                : out std_logic_vector (6 downto 0);
        db_jogada_feita          : out std_logic_vector (6 downto 0);
        db_rodada                : out std_logic_vector (6 downto 0);
        db_timeout               : out std_logic;
        db_escreve               : out std_logic
    );
end entity;

architecture arch of jogo_desafio_memoria  is
    component hexa7seg is
      port (
          hexa : in  std_logic_vector(3 downto 0);
          sseg : out std_logic_vector(6 downto 0)
      );
    end component;

    component unidade_controle is 
      port ( 
          clock               : in  std_logic; 
          reset               : in  std_logic; 
          iniciar             : in  std_logic;
          jogada_feita        : in std_logic;
          jogada_correta      : in  std_logic;
          fimL                : in  std_logic;
          fimE                : in  std_logic;
          fimT                : in  std_logic;
          fimTI                : in  std_logic;
          enderecoIgualRodada : in std_logic;
          escreveM  : out std_logic;
          zeraE     : out std_logic;
          contaE    : out std_logic;
          limpaRC   : out std_logic;
          registraRC: out std_logic;
          zeraD     : out std_logic;
          contaCR   : out std_logic;
          zeraCR    : out std_logic;
          leds_src  : out std_logic;
          contaT    : out std_logic;
          contaTI   : out std_logic;
          zeraT     : out std_logic;
          zeraTI    : out std_logic;
          acertou   : out std_logic;
          errou     : out std_logic;
          pronto    : out std_logic;
          db_timeout: out std_logic;
          db_estado : out std_logic_vector(3 downto 0)
      );
    end component;

    component fluxo_dados is
      port (
        clock               : in  std_logic;
        zeraE               : in  std_logic;
        contaE              : in  std_logic;
        escreveM            : in  std_logic;
        limpaRC             : in  std_logic;
        registraRC          : in  std_logic;
        chaves              : in  std_logic_vector (3 downto 0);
        contaT              : in  std_logic;
        contaTI             : in  std_logic;
        zeraT               : in  std_logic;
        zeraTI              : in  std_logic;
        leds_src            : in  std_logic;
        zeraCR              : in  std_logic;
        contaCR             : in  std_logic;
        zeraD               : in  std_logic;
        fimTI               : out std_logic;
        jogada_correta      : out std_logic;
        fimE                : out std_logic;
        fimL                : out std_logic;
        fimT                : out std_logic;
        jogada_feita        : out std_logic;
        db_contagem         : out std_logic_vector (3 downto 0);
        db_memoria          : out std_logic_vector (3 downto 0);
        db_jogada_feita     : out std_logic_vector (3 downto 0);
        db_rodada           : out std_logic_vector (3 downto 0);
        leds                : out std_logic_vector (3 downto 0);
        enderecoIgualRodada : out std_logic
      );
    end component fluxo_dados;

    
    signal s_zeraE               : std_logic;
    signal s_contaE              : std_logic;
    signal s_escreveM            : std_logic;
    signal s_limpaRC             : std_logic;
    signal s_registraRC          : std_logic;
    signal s_contaT              : std_logic;
    signal s_contaTI             : std_logic;
    signal s_zeraT               : std_logic;
    signal s_zeraTI              : std_logic;
    signal s_leds_src            : std_logic;
    signal s_zeraCR              : std_logic;
    signal s_contaCR             : std_logic;
    signal s_fimTI               : std_logic;
    signal s_jogada_correta      : std_logic;
    signal s_fimE                : std_logic;
    signal s_fimL                : std_logic;
    signal s_fimT                : std_logic;
    signal s_enderecoIgualRodada : std_logic;
    signal s_jogada_feita        : std_logic;
    signal s_zeraD               : std_logic;
    signal s_db_contagem         : std_logic_vector (3 downto 0);
    signal s_db_memoria          : std_logic_vector (3 downto 0);
    signal s_db_jogada_feita     : std_logic_vector (3 downto 0);
    signal s_db_estado           : std_logic_vector (3 downto 0);
    signal s_db_rodada           : std_logic_vector (3 downto 0);
begin
    DF: fluxo_dados
        port map (
            clock => clock,
            zeraE => s_zeraE,
            contaE => s_contaE,
            escreveM => s_escreveM,
            limpaRC => s_limpaRC,
            registraRC => s_registraRC,
            chaves => botoes,
            contaT => s_contaT,
            contaTI => s_contaTI,
            zeraT => s_zeraT,
            zeraTI => s_zeraTI,
            leds_src => s_leds_src,
            zeraCR => s_zeraCR,
            contaCR => s_contaCR,
            fimTI => s_fimTI,
            jogada_correta => s_jogada_correta,
            fimE => s_fimE,
            fimL => s_fimL,
            fimT => s_fimT,
            jogada_feita => s_jogada_feita,
            db_contagem => s_db_contagem,
            db_memoria => s_db_memoria,
            db_rodada => s_db_rodada,
            db_jogada_feita => s_db_jogada_feita,
            leds => leds,
            enderecoIgualRodada => s_enderecoIgualRodada,
            zeraD => s_zeraD
        );

    UC: unidade_controle
        port map ( 
            clock => clock,
            reset => reset,
            iniciar => iniciar,
            jogada_feita => s_jogada_feita,
            jogada_correta => s_jogada_correta,
            fimL => s_fimL,
            fimE => s_fimE,
            fimT => s_fimT,
            fimTI => s_fimTI,
            enderecoIgualRodada => s_enderecoIgualRodada,
            escreveM => s_escreveM,
            zeraE => s_zeraE,
            contaE => s_contaE,
            limpaRC => s_limpaRC,
            registraRC => s_registraRC,
            zeraD => s_zeraD,
            contaCR => s_contaCR,
            zeraCR => s_zeraCR,
            leds_src => s_leds_src,
            contaT => s_contaT,
            contaTI => s_contaTI,
            zeraT => s_zeraT,
            zeraTI => s_zeraTI,
            acertou => acertou,
            errou => errou,
            pronto => pronto,
            db_timeout => db_timeout,
            db_estado => s_db_estado
        );

    HEX_CONTAGEM: hexa7seg
      port map(
        hexa => s_db_contagem,
        sseg => db_contagem
        );
    
    HEX_MEMORIA: hexa7seg
      port map(
        hexa => s_db_memoria,
        sseg => db_memoria
        );
        
    HEX_JOGADA: hexa7seg
    port map(
      hexa => s_db_jogada_feita,
      sseg => db_jogada_feita
      );
      
    HEX_ESTADO: hexa7seg
    port map(
      hexa => s_db_estado,
      sseg => db_estado
      );

    HEX_RODADA: hexa7seg
    port map(
     hexa => s_db_rodada,
     sseg => db_rodada
     );

    db_escreve <= s_escreveM;
    db_endereco_igual_rodada <= s_enderecoIgualRodada;
    db_jogada_correta <= s_jogada_correta;
end architecture;
