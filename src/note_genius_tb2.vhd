library ieee;
use ieee.std_logic_1164.all;

entity note_genius_tb2 is
end note_genius_tb2;


architecture tb of note_genius_tb2 is
    component note_genius
        port (clock       : in std_logic;
              reset       : in std_logic;
              iniciar     : in std_logic;
              chaves      : in std_logic_vector (11 downto 0);
              toca_nota   : out std_logic;
              nota        : out std_logic_vector (11 downto 0);
              erros       : out std_logic_vector (13 downto 0);
              pronto      : out std_logic;
              db_estado   : out std_logic_vector (6 downto 0);
              db_jogada   : out std_logic_vector (6 downto 0);
              db_memoria  : out std_logic_vector (6 downto 0);
              db_endereco : out std_logic_vector (6 downto 0));
    end component;

    signal clock       : std_logic;
    signal reset       : std_logic;
    signal iniciar     : std_logic;
    signal chaves      : std_logic_vector (11 downto 0);
    signal toca_nota   : std_logic;
    signal nota        : std_logic_vector (11 downto 0);
    signal erros       : std_logic_vector (13 downto 0);
    signal pronto      : std_logic;
    signal db_estado   : std_logic_vector (6 downto 0);
    signal db_jogada   : std_logic_vector (6 downto 0);
    signal db_memoria  : std_logic_vector (6 downto 0);
    signal db_endereco : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

    type arranjo_memoria is array(0 to 15) of std_logic_vector(11 downto 0);
    signal memoria : arranjo_memoria := (
                                          "000000000001",
                                          "000000000010",
                                          "000000000100",
                                          "000000000001",
                                          "000000000010",
                                          "000000000100",
                                          "000000000001",
                                          "000000000010",
                                          "000000000100",
                                          "000000000001",
                                          "000000000010",
                                          "000000000100",
                                          "000000000001",
                                          "000000000010",
                                          "000000000100",
                                          "000000000001" );
begin

    dut : note_genius
    port map (clock       => clock,
              reset       => reset,
              iniciar     => iniciar,
              chaves      => chaves,
              toca_nota   => toca_nota,
              nota        => nota,
              erros       => erros,
              pronto      => pronto,
              db_estado   => db_estado,
              db_jogada   => db_jogada,
              db_memoria  => db_memoria,
              db_endereco => db_endereco);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clock is really your main clock signal
    clock <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        iniciar <= '0';
        chaves <= (others => '0');

        -- Reset generation
        reset <= '1';
        wait for 10*TbPeriod;
        reset <= '0';
        wait for 10*TbPeriod;

        -- Initialize
        iniciar <= '1';
        wait for TbPeriod;
        iniciar <= '0';
        wait for 2*TbPeriod;

        -- get all notes right
        for i in 0 to memoria'length-1 loop
            if ( memoria(i)(0) = '1' ) then
                chaves <= "000000000000";
                wait for 20*TbPeriod;
                chaves <= memoria(i);
                wait for 20*TbPeriod;
            else 
                chaves <= "000000000000";
                wait for 20*TbPeriod;
                chaves(0) <= '1'; -- miss
                wait for 20*TbPeriod;
                chaves <= "000000000000";
                wait for 20*TbPeriod;
                chaves <= memoria(i); -- get it right now
                wait for 20*TbPeriod;
            end if;
        end loop;

        wait for TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
