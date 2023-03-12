library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
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
end entity;

architecture fsm of unidade_controle is
    type t_estado is (inicial, preparacao, inicio_rodada, espera, registra, 
                      comparacao, proxima_jogada, terminou_rodada, proxima_rodada, 
                      fim_acertou, fim_errou, fim_timeout, espera_escrita);
    signal Eatual, Eprox : t_estado;
begin

    -- memoria de estado
    process (clock,reset)
    begin
        if reset='1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;

    -- logica de proximo estado
    control: process(Eatual, iniciar, fimT, fimTI, jogada_feita, 
                     enderecoIgualRodada, fimL, jogada_correta)
    begin
        acertou    <= '0';
        errou      <= '0';
        zeraE      <= '0';
        contaE     <= '0';
        limpaRC    <= '0';
        registraRC <= '0';
        zeraD      <= '0';
        contaCR    <= '0';
        zeraCR     <= '0';
        leds_src   <= '0';
        pronto     <= '0';
        contaT     <= '0';
        contaTI    <= '0';
        zeraT      <= '0';
        zeraTI     <= '0';
        db_timeout <= '0';
        escreveM   <= '0';

        case Eatual is

            when inicial => 
                zeraE   <= '1';
                zeraT   <= '1';
                zeraTI  <= '1';
                limpaRC <= '1';
                zeraD   <= '1';

                if ( iniciar = '0' ) then
                    Eprox <= inicial;
                else
                    Eprox <= preparacao;
                end if;
            
            when preparacao =>
                contaTI <= '1';
                zeraCR  <= '1';
                leds_src<= '1';
                
                if ( fimTI = '0' ) then
                    Eprox <= preparacao;
                else 
                    Eprox <= inicio_rodada;
                end if;
				
            when inicio_rodada =>
				zeraE <= '1';
				zeraT <= '1';
				zeraTI<= '1';

				Eprox <= espera;

            when espera =>
				contaT <= '1';

				if ( fimT = '0' and jogada_feita = '0' ) then
					Eprox <= espera;
				elsif ( fimT = '0' and jogada_feita = '1' ) then
					Eprox <= registra;
				else 
					Eprox <= fim_timeout;
				end if;
			
			when registra =>
				registraRC <= '1';
				
				Eprox <= comparacao;
			
			when comparacao => 
				zeraT <= '1';
				
				if ( enderecoIgualRodada = '0' and jogada_correta = '1' ) then
					Eprox <= proxima_jogada;
				elsif ( enderecoIgualRodada = '1' and jogada_correta = '1' ) then
					Eprox <= terminou_rodada;
				else 
					Eprox <= fim_errou;
				end if;
            
			when proxima_jogada =>
				contaE <= '1';

				Eprox <= espera;

			when terminou_rodada => 
				contaE <= '1';
				if ( fimL = '0' ) then
					Eprox <= espera_escrita;
				else 
					Eprox <= fim_acertou;
				end if;
            
            when espera_escrita =>
				contaT <= '1';
                registraRC <= '1';
				if ( fimT = '0' and jogada_feita = '0' ) then
					Eprox <= espera_escrita;
				elsif ( fimT = '0' and jogada_feita = '1' ) then
					Eprox <= proxima_rodada;
				else 
					Eprox <= fim_timeout;
				end if;
			

			when proxima_rodada =>
				contaCR <= '1';
                escreveM <= '1';
				Eprox <= inicio_rodada;
				
			when fim_timeout =>
				errou 	   <= '1';
				pronto 	   <= '1';
				db_timeout <= '1';
				zeraT 	   <= '1';
			
				if ( iniciar = '1' ) then
					Eprox <= preparacao;
				else 
					Eprox <= fim_timeout;
				end if;

			when fim_errou =>
				errou <= '1';
				pronto <= '1';

				if ( iniciar = '1' ) then
					Eprox <= preparacao;
				else 
					Eprox <= fim_errou;
				end if;

			when fim_acertou =>
				acertou <= '1';
				pronto <= '1';

				if ( iniciar = '1' ) then
					Eprox <= preparacao;
				else 
					Eprox <= fim_acertou;
				end if;
			
        end case;
    end process;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial,         -- 0
                     "0001" when preparacao,      -- 1
                     "0010" when inicio_rodada,   -- 2
                     "0011" when registra,        -- 3
                     "0100" when comparacao,      -- 4
                     "0101" when proxima_jogada,  -- 5
                     "0110" when terminou_rodada, -- 6
                     "0111" when proxima_rodada,  -- 7
                     "1000" when fim_timeout,     -- 8
                     "1010" when fim_acertou,     -- A
                     "1110" when fim_errou,       -- E
                     "1101" when espera,          -- D
                     "1011" when espera_escrita,  -- B
                     "1111" when others;          -- F

end architecture fsm;
