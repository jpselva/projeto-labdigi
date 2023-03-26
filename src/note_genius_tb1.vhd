library ieee;
use ieee.std_logic_1164.all;

entity note_genius_tb1 is
end note_genius_tb1;

architecture tb of note_genius_tb1 is

    component note_genius is
        port (
            -- inputs
            clock               : in std_logic;
            reset               : in std_logic; -- ativo baixo
            iniciar             : in std_logic; -- ativo baixo
            chaves              : in std_logic_vector (11 downto 0);
            sel_dificuldade     : in std_logic_vector (3 downto 0);
            sel_modo            : in std_logic_vector (1 downto 0);
    
            -- outputs
            erros        : out std_logic_vector (13 downto 0);
            pronto       : out std_logic;
            sinal_buzzer : out std_logic;
    
            -- messages
            msg_hex0          : out std_logic_vector (6 downto 0);
            msg_hex1          : out std_logic_vector (6 downto 0);
            msg_hex2          : out std_logic_vector (6 downto 0);
            msg_hex3          : out std_logic_vector (6 downto 0);
            msg_hex4          : out std_logic_vector (6 downto 0);
            msg_hex5          : out std_logic_vector (6 downto 0);
    
            -- debug
            db_estado         : out std_logic_vector (6 downto 0);
            db_jogada         : out std_logic_vector (6 downto 0);
            db_nota_correta : out std_logic_vector (6 downto 0);
            db_rodada         : out std_logic_vector (6 downto 0);
            db_toca_nota      : out std_logic;
            db_nota           : out std_logic_vector (11 downto 0);
    
            -- simulacao
            tb_nota_correta_raw     : out std_logic_vector (11 downto 0)
        );
    end component;

    signal clock               : std_logic;
    signal reset               : std_logic;
    signal iniciar             : std_logic;
    signal chaves              : std_logic_vector (11 downto 0);
    signal sel_dificuldade     : std_logic_vector (3 downto 0);
    signal sel_modo            : std_logic_vector (1 downto 0);
    signal erros               : std_logic_vector (13 downto 0);
    signal pronto              : std_logic;
    signal sinal_buzzer        : std_logic;
    signal db_estado           : std_logic_vector (6 downto 0);
    signal db_jogada           : std_logic_vector (6 downto 0);
    signal db_nota_correta     : std_logic_vector (6 downto 0);
    signal db_rodada           : std_logic_vector (6 downto 0);
    signal db_toca_nota        : std_logic;
    signal db_nota             : std_logic_vector (11 downto 0);
    signal tb_nota_correta_raw : std_logic_vector (11 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    DUT: note_genius
    port map (
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        chaves => chaves,
        sel_dificuldade => sel_dificuldade,
        sel_modo => sel_modo,
        erros => erros,
        pronto => pronto,
        sinal_buzzer => sinal_buzzer,
        db_estado => db_estado,
        db_jogada => db_jogada,
        db_nota_correta => db_nota_correta,
        db_rodada => db_rodada,
        db_toca_nota => db_toca_nota,
        db_nota => db_nota,
        tb_nota_correta_raw => tb_nota_correta_raw,
        msg_hex0 => open,
        msg_hex1 => open,
        msg_hex2 => open,
        msg_hex3 => open,
        msg_hex4 => open,
        msg_hex5 => open
    );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clock is really your main clock signal
    clock <= TbClock;

    stimuli : process
    begin
        iniciar <= '1';
        reset <= '1';
        chaves <= (others => '0');
        sel_dificuldade <= (others => '0');
        sel_modo <= (others => '0');

        -- Reset generation
        reset <= '0';
        wait for 10*TbPeriod;
        reset <= '1';
        wait for 10*TbPeriod;

        -- Initialize
        iniciar <= '0';
        wait for 5*TbPeriod;
        iniciar <= '1';
        wait for 2*TbPeriod;

        -- Select mode
        sel_modo(0) <= '1';
        wait for 5*TbPeriod;
        iniciar <= '0';
        wait for 5*TbPeriod;
        iniciar <= '1';

        -- Select difficulty
        sel_dificuldade(1) <= '1';
        wait for 5*TbPeriod;
        iniciar <= '0';
        wait for 5*TbPeriod;
        iniciar <= '1';

        -- Wait for note generation
        wait for 50*TbPeriod;

        -- get all notes right
        for i in 0 to 15 loop  
            chaves <= "111111111111";
            wait for 100*TbPeriod;
            chaves <= not tb_nota_correta_raw; 
            wait for 100*TbPeriod;
        end loop;

        wait for TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
