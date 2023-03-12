library ieee;
use ieee.std_logic_1164.all;

entity jogo_desafio_memoria_tb1 is
end jogo_desafio_memoria_tb1;

architecture tb of jogo_desafio_memoria_tb1 is
    type   arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
    component jogo_desafio_memoria
        port (clock                    : in std_logic;
              reset                    : in std_logic;
              iniciar                  : in std_logic;
              botoes                   : in std_logic_vector (3 downto 0);
              leds                     : out std_logic_vector (3 downto 0);
              pronto                   : out std_logic;
              acertou                  : out std_logic;
              errou                    : out std_logic;
              db_jogada_correta        : out std_logic;
              db_endereco_igual_rodada : out std_logic;
              db_contagem              : out std_logic_vector (6 downto 0);
              db_memoria               : out std_logic_vector (6 downto 0);
              db_estado                : out std_logic_vector (6 downto 0);
              db_jogada_feita          : out std_logic_vector (6 downto 0);
              db_rodada                : out std_logic_vector (6 downto 0);
              db_timeout               : out std_logic;
              db_escreve               : out std_logic);
    end component;

    signal clock                    : std_logic;
    signal reset                    : std_logic;
    signal iniciar                  : std_logic;
    signal botoes                   : std_logic_vector (3 downto 0);
    signal leds                     : std_logic_vector (3 downto 0);
    signal pronto                   : std_logic;
    signal acertou                  : std_logic;
    signal errou                    : std_logic;
    signal db_jogada_correta        : std_logic;
    signal db_endereco_igual_rodada : std_logic;
    signal db_contagem              : std_logic_vector (6 downto 0);
    signal db_memoria               : std_logic_vector (6 downto 0);
    signal db_estado                : std_logic_vector (6 downto 0);
    signal db_jogada_feita          : std_logic_vector (6 downto 0);
    signal db_rodada                : std_logic_vector (6 downto 0);
    signal db_timeout               : std_logic;
    signal db_escreve               : std_logic;

    constant TbPeriod : time := 1 ms; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    signal tb_case : natural := 0;

    signal MAX_ROUND : natural := 16;
    signal MAX_ADDR  : natural := 16;
    signal memoria : arranjo_memoria := ("0001",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000",
                                         "0000");

begin
    dut : jogo_desafio_memoria
    port map (clock                    => clock,
              reset                    => reset,
              iniciar                  => iniciar,
              botoes                   => botoes,
              leds                     => leds,
              pronto                   => pronto,
              acertou                  => acertou,
              errou                    => errou,
              db_jogada_correta        => db_jogada_correta,
              db_endereco_igual_rodada => db_endereco_igual_rodada,
              db_contagem              => db_contagem,
              db_memoria               => db_memoria,
              db_estado                => db_estado,
              db_jogada_feita          => db_jogada_feita,
              db_rodada                => db_rodada,
              db_timeout               => db_timeout,
              db_escreve               => db_escreve);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clock is really your main clock signal
    clock <= TbClock;

    stimuli : process
    begin
        -- INICIALIZACAO
        iniciar <= '0';
        botoes <= (others => '0');

        -- 1 - RESET
        tb_case <= 1;
        reset <= '1';
        wait for TbPeriod;
        reset <= '0';

        -- 2 - INICIAR 
        tb_case <= tb_case + 1;
        iniciar <= '1';
        wait for TbPeriod;
        iniciar <= '0';

        -- 3
        tb_case <= tb_case + 1;
        wait for 2100 ms;
        
        -- ACERTAR TODAS AS POSICOES
        for r in 0 to memoria'length-1 loop
            for a in 0 to r loop
                botoes <= "0000";
                wait for 10*TbPeriod;
                botoes <= memoria(a);
                wait for 10*TbPeriod;
            end loop;

            if r < memoria'length-1 then
                botoes <= "0000";
                wait for 10*TbPeriod;
                botoes <= "0001";
                memoria(r + 1) <= "0001";
                wait for 10*TbPeriod;
            end if;

            wait for 10*TbPeriod;
        end loop;

        -- 11
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
