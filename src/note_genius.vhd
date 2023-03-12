library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity note_genius is
    port (
        -- inputs
        clock   : in std_logic;
        reset   : in std_logic;
        iniciar : in std_logic;
        chaves  : in std_logic_vector (11 downto 0);

        -- outputs
        toca_nota : out std_logic;
        nota      : out std_logic_vector (11 downto 0);
        erros     : out std_logic_vector (13 downto 0);
        pronto    : out std_logic;

        -- debug
        db_estado           : out std_logic_vector (6 downto 0);
        db_jogada           : out std_logic_vector (6 downto 0);
        db_memoria          : out std_logic_vector (6 downto 0);
        db_endereco         : out std_logic_vector (6 downto 0)
    );
end entity;

architecture arch of note_genius is
    component hexa7seg is
      port (
          hexa : in  std_logic_vector(3 downto 0);
          sseg : out std_logic_vector(6 downto 0)
      );
    end component;

    component encoder16x4 is
        port (
            I : in  std_logic_vector(15 downto 0);
            O : out std_logic_vector(3 downto 0)
        );
    end component;

    component unidade_controle is 
        port ( 
            clock               : in std_logic; 
            reset               : in std_logic; 
            iniciar             : in std_logic;
            jogada_feita        : in std_logic;
            jogada_correta      : in std_logic;
            fim_contjog         : in std_logic;
            timeout_tnota       : in std_logic;
            timeout_tsil        : in std_logic;
            zera_contjog        : out std_logic;
            conta_contjog       : out std_logic;
            zera_regnota        : out std_logic;
            registra_regnota    : out std_logic;
            zera_regmasc        : out std_logic;
            registra_regmasc    : out std_logic;
            masc_dado           : out std_logic_vector(11 downto 0);
            nota_src            : out std_logic;
            zera_conterros      : out std_logic;
            conta_conterros     : out std_logic;
            zera_tnota          : out std_logic;
            conta_tnota         : out std_logic;
            zera_tsil           : out std_logic;
            conta_tsil          : out std_logic;
            zera_detec          : out std_logic;
            toca_nota           : out std_logic;
            pronto              : out std_logic;
            db_estado           : out std_logic_vector(3 downto 0)
        );
    end component;

    component fluxo_dados is
      port (
        clock               : in  std_logic;
        zera_contjog        : in  std_logic;
        conta_contjog       : in  std_logic;
        zera_regnota        : in  std_logic;
        registra_regnota    : in  std_logic;
        chaves              : in  std_logic_vector (11 downto 0);
        zera_regmasc        : in  std_logic;
        registra_regmasc    : in  std_logic;
        masc_dado           : in  std_logic_vector (11 downto 0);
        nota_src            : in  std_logic;
        zera_conterros      : in  std_logic;
        conta_conterros     : in  std_logic;
        zera_detec          : in  std_logic;
        zera_tnota          : in  std_logic;
        conta_tnota         : in  std_logic;
        zera_tsil           : in  std_logic;
        conta_tsil          : in  std_logic;
        fim_contjog         : out std_logic;
        jogada_correta      : out std_logic;
        nota                : out std_logic_vector (11 downto 0);
        erros               : out std_logic_vector (6 downto 0);
        jogada_feita        : out std_logic;
        timeout_tnota       : out std_logic;
        timeout_tsil        : out std_logic;
        db_jogada           : out std_logic_vector (11 downto 0);
        db_memoria          : out std_logic_vector (11 downto 0);
        db_endereco         : out std_logic_vector (3 downto 0)
      );
    end component;
    
    ---------------------------------------------
    -- interconnections
    ---------------------------------------------
    signal s_jogada_feita     : std_logic;
    signal s_jogada_correta   : std_logic;
    signal s_fim_contjog      : std_logic;
    signal s_timeout_tnota    : std_logic;
    signal s_timeout_tsil     : std_logic;
    signal s_zera_contjog     : std_logic;
    signal s_conta_contjog    : std_logic;
    signal s_zera_regnota     : std_logic;
    signal s_registra_regnota : std_logic;
    signal s_zera_regmasc     : std_logic;
    signal s_registra_regmasc : std_logic;
    signal s_masc_dado        : std_logic_vector (11 downto 0);
    signal s_nota_src         : std_logic;
    signal s_zera_conterros   : std_logic;
    signal s_conta_conterros  : std_logic;
    signal s_zera_tnota       : std_logic;
    signal s_conta_tnota      : std_logic;
    signal s_zera_tsil        : std_logic;
    signal s_conta_tsil       : std_logic;
    signal s_zera_detec       : std_logic;
    signal s_nota             : std_logic_vector (11 downto 0);
    signal s_erros            : std_logic_vector (6 downto 0);
    signal s_db_jogada        : std_logic_vector (11 downto 0);
    signal s_db_memoria       : std_logic_vector (11 downto 0);
    signal s_db_endereco      : std_logic_vector (3 downto 0);
    signal s_db_estado        : std_logic_vector (3 downto 0);

    ---------------------------------------------
    -- other signals
    ---------------------------------------------
    -- signals padded with zeros in front
    signal s_erros_pad : std_logic_vector (7 downto 0);
    signal s_db_jogada_pad : std_logic_vector(15 downto 0);
    signal s_db_memoria_pad : std_logic_vector(15 downto 0);

    signal s_db_memoria_enc : std_logic_vector (3 downto 0);
    signal s_db_jogada_enc : std_logic_vector (3 downto 0);
begin
    UC: unidade_controle
      port map (
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        jogada_feita => s_jogada_feita,
        jogada_correta => s_jogada_correta,
        fim_contjog => s_fim_contjog,
        timeout_tnota => s_timeout_tnota,
        timeout_tsil => s_timeout_tsil,
        zera_contjog => s_zera_contjog,
        conta_contjog => s_conta_contjog,
        zera_regnota => s_zera_regnota,
        registra_regnota => s_registra_regnota,
        zera_regmasc => s_zera_regmasc,
        registra_regmasc => s_registra_regmasc,
        masc_dado => s_masc_dado,
        nota_src => s_nota_src,
        zera_conterros => s_zera_conterros,
        conta_conterros => s_conta_conterros,
        zera_tnota => s_zera_tnota,
        conta_tnota => s_conta_tnota,
        zera_tsil => s_zera_tsil,
        conta_tsil => s_conta_tsil,
        zera_detec => s_zera_detec,
        toca_nota => toca_nota,
        pronto => pronto,
        db_estado => s_db_estado
     );

    DF: fluxo_dados
      port map (
        clock => clock,
        zera_contjog => s_zera_contjog,
        conta_contjog => s_conta_contjog,
        zera_regnota => s_zera_regnota,
        registra_regnota => s_registra_regnota,
        chaves => chaves,
        zera_regmasc => s_zera_regmasc,
        registra_regmasc => s_registra_regmasc,
        masc_dado => s_masc_dado,
        nota_src => s_nota_src,
        zera_conterros => s_zera_conterros,
        conta_conterros => s_conta_conterros,
        zera_detec => s_zera_detec,
        zera_tnota => s_zera_tnota,
        conta_tnota => s_conta_tnota,
        zera_tsil => s_zera_tsil,
        conta_tsil => s_conta_tsil,
        fim_contjog => s_fim_contjog,
        jogada_correta => s_jogada_correta,
        nota => s_nota,
        erros => s_erros,
        jogada_feita => s_jogada_feita,
        timeout_tnota => s_timeout_tnota,
        timeout_tsil => s_timeout_tsil,
        db_jogada => s_db_jogada,
        db_memoria => s_db_memoria,
        db_endereco => s_db_endereco
      );

    s_erros_pad <= "0"&s_erros;
    s_db_jogada_pad <= "0000"&s_db_jogada;
    s_db_memoria_pad <= "0000"&s_db_memoria;
    nota <= s_nota;    

    HEX_ESTADO: hexa7seg
    port map(
      hexa => s_db_estado,
      sseg => db_estado
    );

    HEX_ENDERECO: hexa7seg
    port map(
      hexa => s_db_endereco,
      sseg => db_endereco
    );

    HEX_ERROS1: hexa7seg -- Lower 4 bits
    port map (
      hexa => s_erros_pad(3 downto 0),
      sseg => erros(6 downto 0)
    );

    HEX_ERROS2: hexa7seg -- Upper 3 bits
    port map (
      hexa => s_erros_pad(7 downto 4),
      sseg => erros(13 downto 7)
    );

    ENC_JOG: encoder16x4         
    port map (
        I => s_db_jogada_pad,
        O => s_db_jogada_enc
    );

    ENC_MEM: encoder16x4         
    port map (
        I => s_db_memoria_pad,
        O => s_db_memoria_enc
    );

    HEX_JOG: hexa7seg
    port map (
      hexa => s_db_jogada_enc, 
      sseg => db_jogada 
    );

    HEX_MEM: hexa7seg
    port map (
      hexa => s_db_memoria_enc, 
      sseg => db_memoria
    );

end architecture;