library ieee;
use ieee.std_logic_1164.all;

entity note_genius_tb1 is
end note_genius_tb1;

architecture tb of note_genius_tb1 is

    component note_genius is
        port (
            clock                 : in  std_logic;
            clock_nota            : in  std_logic;
            reset                 : in  std_logic; -- ativo baixo
            iniciar               : in  std_logic; -- ativo baixo
            chaves                : in  std_logic_vector (11 downto 0);
            iniciar_tradicional   : in  std_logic; -- ativo baixo
            sel_dificuldade       : in  std_logic_vector (3 downto 0);
            erros                 : out std_logic_vector (13 downto 0);
            pronto                : out std_logic;
            sinal_buzzer          : out std_logic;
            db_estado             : out std_logic_vector (6 downto 0);
            db_jogada             : out std_logic_vector (6 downto 0);
            db_nota_aleatoria     : out std_logic_vector (6 downto 0);
            db_rodada             : out std_logic_vector (6 downto 0);
            db_toca_nota          : out std_logic;
            db_nota               : out std_logic_vector (11 downto 0);
            tb_nota_aleatoria_raw : out std_logic_vector (11 downto 0)
        );
    end component;

    signal clock                 : std_logic;
    signal clock_nota            : std_logic;
    signal reset                 : std_logic;
    signal iniciar               : std_logic;
    signal chaves                : std_logic_vector (11 downto 0);
    signal db_toca_nota          : std_logic;
    signal db_nota               : std_logic_vector (11 downto 0);
    signal erros                 : std_logic_vector (13 downto 0);
    signal pronto                : std_logic;
    signal db_estado             : std_logic_vector (6 downto 0);
    signal db_jogada             : std_logic_vector (6 downto 0);
    signal db_rodada             : std_logic_vector (6 downto 0);
    signal iniciar_tradicional   : std_logic;
    signal db_nota_aleatoria     : std_logic_vector (6 downto 0);
    signal tb_nota_aleatoria_raw : std_logic_vector (11 downto 0);
    signal sel_dificuldade       : std_logic_vector (3 downto 0);

    constant TbPeriod : time      := 1000 ns; -- EDIT Put right period here
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
begin

    dut : note_genius
    port map (clock        => clock,
              clock_nota   => clock,
              reset        => reset,
              iniciar      => iniciar,
              chaves       => chaves,
              db_toca_nota => db_toca_nota,
              db_nota      => db_nota,
              erros        => erros,
              pronto       => pronto,
              db_estado    => db_estado,
              db_jogada    => db_jogada,
              db_rodada    => db_rodada,
              iniciar_tradicional => iniciar_tradicional,
              db_nota_aleatoria   => db_nota_aleatoria,
              tb_nota_aleatoria_raw => tb_nota_aleatoria_raw,
              sel_dificuldade => sel_dificuldade);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clock is really your main clock signal
    clock <= TbClock;

    stimuli : process
    begin
        iniciar <= '1';
        reset <= '1';
        iniciar_tradicional <= '1';
        chaves <= (others => '0');
        sel_dificuldade <= "0000";

        -- Reset generation
        reset <= '0';
        wait for 10*TbPeriod;
        reset <= '1';
        wait for 10*TbPeriod;

        -- Initialize
        sel_dificuldade <= "0001";
        iniciar <= '0';
        wait for TbPeriod;
        iniciar <= '1';
        wait for 2*TbPeriod;

        -- Initialize mode
        sel_dificuldade <= "0001";
        iniciar_tradicional <= '1';
        wait for TbPeriod;
        iniciar_tradicional <= '0';
        wait for 2*TbPeriod;

        -- get all notes right
        for i in 0 to 15 loop  
            chaves <= "000000000000";
            wait for 20*TbPeriod;
            chaves <= tb_nota_aleatoria_raw; 
            wait for 20*TbPeriod;
        end loop;

        wait for TbPeriod*20;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
