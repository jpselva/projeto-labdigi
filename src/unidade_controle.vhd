library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
    port ( 
        -- inputs
        clock               : in std_logic; 
        reset               : in std_logic; 
        iniciar             : in std_logic;
        iniciar_tradicional : in std_logic;
        jogada_feita        : in std_logic;
        jogada_correta      : in std_logic;
        fim_contjog         : in std_logic;
        timeout_tnota       : in std_logic;
        timeout_tsil        : in std_logic;

        -- outputs
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
        randomiza_nota      : out std_logic;
        reset_gera_nota     : out std_logic;

        -- debug
        db_estado           : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle is
    type t_estado is (inicial, preparacao, toca, espera, registra, 
                      comparacao, espera_errou, espera_acertou, errou_jogada, 
                      acertou_jogada, espera_silencio, fim, seleciona_modo);
    signal Eatual, Eprox : t_estado;
begin

    -- memoria de estado
    process (clock, reset)
    begin
        if reset='1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;

    -- logica de proximo estado
    control: process(Eatual, iniciar, jogada_feita, jogada_correta, fim_contjog,
                     timeout_tnota, timeout_tsil, iniciar_tradicional)
    begin
        zera_contjog      <= '0';
        conta_contjog     <= '0';
        zera_regnota      <= '0';
        registra_regnota  <= '0';
        zera_regmasc      <= '0';
        registra_regmasc  <= '0';
        masc_dado         <= "000000000000";
        nota_src          <= '0';
        zera_conterros    <= '0';
        conta_conterros   <= '0';
        zera_tnota        <= '0';
        conta_tnota       <= '0';
        zera_tsil         <= '0';
        conta_tsil        <= '0';
        toca_nota         <= '0';
        pronto            <= '0';
        zera_detec        <= '0';
        randomiza_nota    <= '0';
        reset_gera_nota   <= '0';

        case Eatual is

            when inicial => 
                if ( iniciar = '0' ) then
                    Eprox <= inicial;
                else
                    Eprox <= preparacao;
                end if;
            
            when preparacao =>
                zera_contjog <= '1';
                zera_regnota <= '1';
                zera_conterros <= '1';
                zera_tnota <= '1';
                zera_tsil <= '1';
                zera_detec <= '1';
                registra_regmasc <= '1';
                masc_dado <= "000000000111";
                reset_gera_nota <= '1';
                
                Eprox <= seleciona_modo;

            when seleciona_modo =>
                randomiza_nota <= '1';

                if ( iniciar_tradicional = '1' ) then
                    Eprox <= toca;
                else
                    Eprox <= seleciona_modo;
                end if;

            when toca =>
                toca_nota <= '1';
                nota_src <= '1';
                zera_tsil <= '1';
                conta_tnota <= '1';

                if ( timeout_tnota = '0' ) then
                    Eprox <= toca;
                else
                    Eprox <= espera;
                end if;

            when espera =>

                if ( jogada_feita = '0' ) then
                    Eprox <= espera;
                else
                    Eprox <= registra;
                end if;
			
			when registra =>
				registra_regnota <= '1';
				Eprox <= comparacao;
			
			when comparacao => 
				zera_tnota <= '1';
				
                if ( jogada_correta = '0' ) then
                    Eprox <= espera_errou;
                else
                    Eprox <= espera_acertou;
                end if;

            when espera_acertou =>
                toca_nota <= '1';
                conta_tnota <= '1';
                randomiza_nota <= '1';

                if ( timeout_tnota = '0' ) then
                    Eprox <= espera_acertou;
                elsif ( fim_contjog = '0' ) then
                    Eprox <= acertou_jogada;
                else
                    Eprox <= fim;
                end if;

			when acertou_jogada => 
                zera_tnota <= '1';
                zera_tsil <= '1';
                conta_contjog <= '1';

                Eprox <= espera_silencio;

			when espera_errou =>
                toca_nota <= '1';
                conta_tnota <= '1';

                if ( timeout_tnota = '0' ) then
                    Eprox <= espera_errou;
                else
                    Eprox <= errou_jogada;
                end if;

            when errou_jogada =>
                zera_tnota <= '1';
                zera_tsil <= '1';
                conta_conterros <= '1';

                Eprox <= espera_silencio;
            
            when espera_silencio =>
                conta_tsil <= '1';

                if ( timeout_tsil = '0' ) then
                    Eprox <= espera_silencio;
                else
                    Eprox <= toca;
                end if;

            when fim =>
                pronto <= '1';

                if ( iniciar = '1' ) then
                    Eprox <= preparacao;
                else
                    Eprox <= fim;
                end if;
			
        end case;
    end process;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial,         -- 0
                     "0001" when preparacao,      -- 1
                     "0010" when seleciona_modo,  -- 2
                     "0011" when registra,        -- 3
                     "0100" when comparacao,      -- 4
                     "0101" when errou_jogada,    -- 5
                     "0110" when acertou_jogada,  -- 6
                     "0111" when espera_silencio, -- 7
                     "1000" when fim,             -- 8
                     "1010" when espera_acertou,  -- A
                     "1100" when toca,            -- C
                     "1101" when espera,          -- D
                     "1110" when espera_errou,    -- E
                     "1111" when others;          -- F

end architecture fsm;
