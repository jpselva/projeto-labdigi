library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
    port ( 
        -- inputs
        clock               : in std_logic; 
        reset               : in std_logic; 
        iniciar             : in std_logic;
        jogada_feita        : in std_logic;
        jogada_correta      : in std_logic;
        fim_contjog         : in std_logic;
        timeout_tnota       : in std_logic;
        timeout_tsil        : in std_logic;
        sel_modo            : in std_logic_vector(1 downto 0);
        sel_dificuldade     : in std_logic_vector(3 downto 0);
        lfsr_compativel     : in std_logic;

        -- outputs
        zera_contjog           : out std_logic;
        conta_contjog          : out std_logic;
        zera_regnota           : out std_logic;
        registra_regnota       : out std_logic;
        zera_regmasc           : out std_logic;
        registra_regmasc       : out std_logic;
        masc_dado              : out std_logic_vector(11 downto 0);
        nota_src               : out std_logic;
        zera_conterros         : out std_logic;
        conta_conterros        : out std_logic;
        zera_tnota             : out std_logic;
        conta_tnota            : out std_logic;
        zera_tsil              : out std_logic;
        conta_tsil             : out std_logic;
        zera_detec             : out std_logic;
        toca_nota              : out std_logic;
        pronto                 : out std_logic;
        reset_lfsr             : out std_logic;
        shift_lfsr             : out std_logic;
        registra_reg_nota_corr : out std_logic;
        msg_end                : out std_logic_vector(3 downto 0);

        -- debug
        db_estado           : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle is
    type t_estado is (inicial, preparacao, seleciona_modo,

                      toca_tr, espera_tr, registra_tr, comparacao_tr, espera_errou_tr, 
                      espera_acertou_tr, errou_jogada_tr, acertou_jogada_tr, 
                      silencio_acertou_tr, silencio_errou_tr, fim_tr, seleciona_dif_tr,
                      shift_lfsr_tr, verifica_lfsr_tr,

                      espera_pr, registra_pr, toca_pr);

    component edge_detector is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component;

    signal iniciar_edge, reset_detetinic : std_logic;
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
                     timeout_tnota, timeout_tsil, sel_modo, sel_dificuldade,
                     iniciar_edge, lfsr_compativel)
    begin
        zera_contjog      <= '0';
        conta_contjog     <= '0';
        zera_regnota      <= '0';
        registra_regnota  <= '0';
        zera_regmasc      <= '0';
        registra_regmasc  <= '0';
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
        masc_dado         <= "000000000000";
        reset_lfsr        <= '0';
        shift_lfsr        <= '0';
        registra_reg_nota_corr <= '0';
        reset_detetinic   <= '0';
        msg_end           <= "0000";

        case Eatual is

            when inicial =>
                msg_end <= "0001"; 
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
                reset_detetinic <= '1';
                masc_dado <= "111111111111";
                registra_regmasc <= '1';
                reset_lfsr <= '1';
                
                Eprox <= seleciona_modo;

            when seleciona_modo =>
                msg_end <= "0010";
                if ( iniciar_edge = '1' ) then
                    if ( sel_modo(0) = '1' ) then
                        Eprox <= seleciona_dif_tr;
                    elsif ( sel_modo(1) = '1' ) then
                        Eprox <= espera_pr;
                    else
                        Eprox <= seleciona_modo;
                    end if;
                else
                    Eprox <= seleciona_modo;
                end if;

            when seleciona_dif_tr =>
                msg_end <= "0010";
                registra_regmasc <= '1';

                if (sel_dificuldade(3) = '1') then
                    masc_dado <= "111111111111";
                elsif (sel_dificuldade(2) = '1') then
                    masc_dado <= "000001111111";
                elsif (sel_dificuldade(1) = '1') then
                    masc_dado <= "000000011111";
                else
                    masc_dado <= "000000000111";
                end if;

                if iniciar_edge = '1' then
                    Eprox <= shift_lfsr_tr;
                else
                    Eprox <= seleciona_dif_tr;
                end if;

            when shift_lfsr_tr =>
                shift_lfsr <= '1';
                Eprox <= verifica_lfsr_tr;

            when verifica_lfsr_tr =>
                registra_reg_nota_corr <= '1'; 
                
                if ( lfsr_compativel = '1' ) then
                    Eprox <= toca_tr;
                else
                    Eprox <= shift_lfsr_tr;
                end if;

            when toca_tr =>
                toca_nota <= '1';
                nota_src <= '1';
                zera_tsil <= '1';
                conta_tnota <= '1';

                if ( timeout_tnota = '0' ) then
                    Eprox <= toca_tr;
                else
                    Eprox <= espera_tr;
                end if;

            when espera_tr =>
                msg_end <= "0011";
                if ( jogada_feita = '0' ) then
                    Eprox <= espera_tr;
                else
                    Eprox <= registra_tr;
                end if;
			
			when registra_tr =>
				registra_regnota <= '1';
				Eprox <= comparacao_tr;
			
			when comparacao_tr => 
				zera_tnota <= '1';
				
                if ( jogada_correta = '0' ) then
                    Eprox <= espera_errou_tr;
                else
                    Eprox <= espera_acertou_tr;
                end if;

            when espera_acertou_tr =>
                msg_end <= "0100";
                toca_nota <= '1';
                conta_tnota <= '1';

                if ( timeout_tnota = '0' ) then
                    Eprox <= espera_acertou_tr;
                elsif ( fim_contjog = '0' ) then
                    Eprox <= acertou_jogada_tr;
                else
                    Eprox <= fim_tr;
                end if;

			when acertou_jogada_tr => 
                zera_tnota <= '1';
                zera_tsil <= '1';
                conta_contjog <= '1';

                Eprox <= silencio_acertou_tr;

			when espera_errou_tr =>
                msg_end <= "0101";
                toca_nota <= '1';
                conta_tnota <= '1';

                if ( timeout_tnota = '0' ) then
                    Eprox <= espera_errou_tr;
                else
                    Eprox <= errou_jogada_tr;
                end if;

            when errou_jogada_tr =>
                zera_tnota <= '1';
                zera_tsil <= '1';
                conta_conterros <= '1';

                Eprox <= silencio_errou_tr;
            
            when silencio_acertou_tr =>
                conta_tsil <= '1';
                msg_end <= "1000";
                if ( timeout_tsil = '0' ) then
                    Eprox <= silencio_acertou_tr;
                else
                    Eprox <= shift_lfsr_tr;
                end if;
            
            when silencio_errou_tr =>
                conta_tsil <= '1';
                msg_end <= "0110";
                if ( timeout_tsil = '0' ) then
                    Eprox <= silencio_errou_tr;
                else
                    Eprox <= toca_tr;
                end if;

            when fim_tr =>
                pronto <= '1';
                msg_end <= "0111";
                if ( iniciar = '1' ) then
                    Eprox <= preparacao;
                else
                    Eprox <= fim_tr;
                end if;

            when espera_pr =>
                zera_tnota <= '1';

                if ( iniciar = '1' ) then
                    Eprox <= preparacao;
                elsif ( jogada_feita = '1' ) then
                    Eprox <= registra_pr;
                else
                    Eprox <= espera_pr;
                end if;

            when registra_pr =>
                registra_regnota <= '1';
                Eprox <= toca_pr;

            when toca_pr =>
                toca_nota <= '1';
                conta_tnota <= '1';

                if ( timeout_tnota = '1' ) then
                    Eprox <= espera_pr;
                else
                    Eprox <= toca_pr;
                end if;
        end case;
    end process;

    DetetInic: edge_detector
    port map ( 
        clock => clock,
        reset => reset_detetinic,
        sinal => iniciar,
        pulso => iniciar_edge
    );

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial,            -- 0
                     "0001" when preparacao,         -- 1
                     "0010" when seleciona_modo,     -- 2

                     "0011" when registra_tr,        -- 3
                     "0100" when comparacao_tr,      -- 4
                     "0101" when errou_jogada_tr,    -- 5
                     "0110" when acertou_jogada_tr,  -- 6
                     "0111" when silencio_acertou_tr,-- 7
                     "1001" when silencio_errou_tr,  -- 9
                     "1000" when fim_tr,             -- 8
                     "1010" when espera_acertou_tr,  -- A
                     "1100" when toca_tr,            -- C
                     "1101" when espera_tr,          -- D
                     "1110" when espera_errou_tr,    -- E

                     "1101" when espera_pr,          -- D
                     "0011" when registra_pr,        -- 3
                     "1100" when toca_pr,            -- C
                     "1111" when others;             -- F

end architecture fsm;
