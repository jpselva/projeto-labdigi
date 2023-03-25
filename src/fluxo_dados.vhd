library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fluxo_dados is
    generic (
        timer_silencio_len  : integer := 5;
        timer_nota_len      : integer := 10
    );
    port (
        clock                  : in  std_logic;
        zera_contjog           : in  std_logic;
        conta_contjog          : in  std_logic;
        zera_regnota           : in  std_logic;
        registra_regnota       : in  std_logic;
        chaves                 : in  std_logic_vector (11 downto 0);
        zera_regmasc           : in  std_logic;
        registra_regmasc       : in  std_logic;
        masc_dado              : in  std_logic_vector (11 downto 0);
        nota_src               : in  std_logic;
        zera_conterros         : in  std_logic;
        conta_conterros        : in  std_logic;
        zera_detec             : in  std_logic;
        zera_tnota             : in  std_logic;
        conta_tnota            : in  std_logic;
        zera_tsil              : in  std_logic;
        conta_tsil             : in  std_logic;
        reset_lfsr             : in  std_logic;
        shift_lfsr             : in  std_logic;
        registra_reg_nota_corr : in  std_logic;

        fim_contjog            : out std_logic;
        jogada_correta         : out std_logic;
        nota                   : out std_logic_vector (11 downto 0);
        erros                  : out std_logic_vector (6  downto 0);
        jogada_feita           : out std_logic;
        timeout_tnota          : out std_logic;
        timeout_tsil           : out std_logic;
        db_jogada              : out std_logic_vector (11 downto 0);
        db_nota_correta        : out std_logic_vector (11 downto 0);
        db_rodada              : out std_logic_vector (3  downto 0);
        lfsr_compativel        : out std_logic
    );
end entity fluxo_dados;

architecture estrutural of fluxo_dados is
    signal s_mascara                  : std_logic_vector (11 downto 0);
    signal s_chave_acionada           : std_logic;
    signal s_jogada                   : std_logic_vector (11 downto 0);
    signal not_zera_contjog           : std_logic;
    signal s_nota_masc                : std_logic_vector (11 downto 0);
    signal s_jogada_correta           : std_logic_vector (2 downto 0);
    signal lfsr_right_serial          : std_logic;
    signal lfsr_selector              : std_logic_vector(1 downto 0);
    signal lfsr_output                : std_logic_vector (15 downto 0);
    signal decoder_lfsr_output        : std_logic_vector (15 downto 0);
    signal s_nota_correta             : std_logic_vector (11 downto 0);
    signal decoder_lfsr_output_masked : std_logic_vector (11 downto 0);

    component contador_163
        port (
            clock : in  std_logic;
            clr   : in  std_logic;
            ld    : in  std_logic;
            ent   : in  std_logic;
            enp   : in  std_logic;
            D     : in  std_logic_vector (3 downto 0);
            Q     : out std_logic_vector (3 downto 0);
            rco   : out std_logic 
        );
    end component;

    component comparador_85
        port (
            i_A3   : in  std_logic;
            i_B3   : in  std_logic;
            i_A2   : in  std_logic;
            i_B2   : in  std_logic;
            i_A1   : in  std_logic;
            i_B1   : in  std_logic;
            i_A0   : in  std_logic;
            i_B0   : in  std_logic;
            i_AGTB : in  std_logic;
            i_ALTB : in  std_logic;
            i_AEQB : in  std_logic;
            o_AGTB : out std_logic;
            o_ALTB : out std_logic;
            o_AEQB : out std_logic
        );
    end component;

    component registrador_n is
        generic (
            constant N: integer := 8 
        );
        port (
            clock  : in  std_logic;
            clear  : in  std_logic;
            enable : in  std_logic;
            D      : in  std_logic_vector (N-1 downto 0);
            Q      : out std_logic_vector (N-1 downto 0) 
        );
    end component;

    component edge_detector is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component;

    component contador_m is
        generic (
            constant M: integer := 100 -- modulo do contador
        );
        port (
            clock   : in  std_logic;
            zera_as : in  std_logic;
            zera_s  : in  std_logic;
            conta   : in  std_logic;
            Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
            fim     : out std_logic;
            meio    : out std_logic
        );
    end component;

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
            I : in std_logic_vector(3 downto 0);
            O : out std_logic_vector(15 downto 0)
        );
    end component;
begin
    -- sinais de controle ativos em alto
    -- sinais dos componentes ativos em baixo

    not_zera_contjog <= not zera_contjog;
    --zera_conterros <= not zera_conterros;
    --not_escreveM <= not escreveM;

    -- sinal para saber se ha chave acionada
    s_chave_acionada <= s_nota_masc(0) or s_nota_masc(1) or s_nota_masc( 2) or s_nota_masc( 3) 
                   or s_nota_masc(4) or s_nota_masc(5) or s_nota_masc( 6) or s_nota_masc( 7) 
                   or s_nota_masc(8) or s_nota_masc(9) or s_nota_masc(10) or s_nota_masc(11);

    jogada_correta <= s_jogada_correta(2) and s_jogada_correta(1) and s_jogada_correta(0);
    s_nota_masc <= s_mascara and chaves;

    ContJog: contador_163
    port map (
        clock => clock,
        clr   => not_zera_contjog,  -- clr ativo em baixo
        ld    => '1',
        ent   => '1',
        enp   => conta_contjog,
        D     => "0000",
        Q     => db_rodada,
        rco   => fim_contjog
    );

    CompJog1: comparador_85
    port map (
        i_A3   => s_nota_correta(3),
        i_B3   => s_jogada(3),
        i_A2   => s_nota_correta(2),
        i_B2   => s_jogada(2),
        i_A1   => s_nota_correta(1),
        i_B1   => s_jogada(1),
        i_A0   => s_nota_correta(0),
        i_B0   => s_jogada(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => s_jogada_correta(0) 
    );

    CompJog2: comparador_85
    port map (
        i_A3   => s_nota_correta(7),
        i_B3   => s_jogada(7),
        i_A2   => s_nota_correta(6),
        i_B2   => s_jogada(6),
        i_A1   => s_nota_correta(5),
        i_B1   => s_jogada(5),
        i_A0   => s_nota_correta(4),
        i_B0   => s_jogada(4),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => s_jogada_correta(1) 
    );

    CompJog3: comparador_85
    port map (
        i_A3   => s_nota_correta(11),
        i_B3   => s_jogada(11),
        i_A2   => s_nota_correta(10),
        i_B2   => s_jogada(10),
        i_A1   => s_nota_correta(9),
        i_B1   => s_jogada(9),
        i_A0   => s_nota_correta(8),
        i_B0   => s_jogada(8),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => s_jogada_correta(2)
    );
     
    RegNota: registrador_n
    generic map (
        N => 12
    )
    port map (
        clock => clock,
        clear => zera_regnota,
        enable => registra_regnota,
        D => s_nota_masc,
        Q => s_jogada
    );

    RegMasc: registrador_n
    generic map (
        N => 12
    )
    port map (
        clock => clock,
        clear => zera_regmasc,
        enable => registra_regmasc,
        D => masc_dado,
        Q => s_mascara
    );

    DetetJog: edge_detector
    port map (
        clock => clock,
        reset => zera_detec,
        sinal => s_chave_acionada,
        pulso => jogada_feita
    );

    TimerNota: contador_m
    generic map (
        M => timer_nota_len 
    )
    port map (
        clock => clock,
        zera_as => zera_tnota,
        zera_s => '0',
        conta => conta_tnota,
        Q => open,
        fim => timeout_tnota,
        meio => open
    );

    TimerSilencio: contador_m
    generic map (
        M => timer_silencio_len 
    )
    port map (
        clock => clock,
        zera_as => zera_tsil,
        zera_s => '0',
        conta => conta_tsil,
        Q => open,
        fim => timeout_tsil,
        meio => open
    );

    ContadorErros: contador_m
    generic map (
        M => 99
    )
    port map (
        clock => clock,
        zera_as => zera_conterros,
        zera_s => '0',
        conta => conta_conterros,
        Q => erros,
        fim => open,
        meio => open
    );

    -- NOTE GENERATION LOGIC
    LFSR: shift_register
    generic map (
        word_s => 16
    )
    port map (
        clk => clock,
        write_word => "1110010110010101", -- whatever
        right_serial => lfsr_right_serial,
        left_serial => '0',
        clear => '0',
        selector => lfsr_selector,
        read_word => lfsr_output
    );

    lfsr_selector <= "11" when reset_lfsr = '1' else
                     "01" when shift_lfsr = '1' else
                     "00";

    lfsr_right_serial <= lfsr_output(10) XOR (lfsr_output(12) XOR 
                         (lfsr_output(13) XOR lfsr_output(15)));

    DecoderLfsr: decoder4x16
    port map (
        I => lfsr_output(15 downto 12),
        O => decoder_lfsr_output
    );

    RegNotaCorreta: registrador_n
    generic map (
        N => 12
    )
    port map (
        clock => clock,
        clear => '0',
        enable => registra_reg_nota_corr,
        D => decoder_lfsr_output(11 downto 0),
        Q => s_nota_correta
    );

    decoder_lfsr_output_masked <= decoder_lfsr_output(11 downto 0) AND s_mascara;
    lfsr_compativel <= decoder_lfsr_output_masked(0)  OR
                       decoder_lfsr_output_masked(1)  OR
                       decoder_lfsr_output_masked(2)  OR
                       decoder_lfsr_output_masked(3)  OR
                       decoder_lfsr_output_masked(4)  OR
                       decoder_lfsr_output_masked(5)  OR
                       decoder_lfsr_output_masked(6)  OR
                       decoder_lfsr_output_masked(7)  OR
                       decoder_lfsr_output_masked(8)  OR
                       decoder_lfsr_output_masked(9)  OR
                       decoder_lfsr_output_masked(10) OR
                       decoder_lfsr_output_masked(11);

    nota <= s_nota_correta when nota_src = '1' else s_jogada;
    db_nota_correta  <= s_nota_correta;
    db_jogada <= s_jogada;

end architecture estrutural;
