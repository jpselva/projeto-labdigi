library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_controller is
    port (
        clock          : in std_logic;
        not_clock1khz  : in std_logic;
        reset          : in std_logic;
        bytes          : in std_logic_vector(23 downto 0);
        sout           : out std_logic
    );
end serial_controller;

architecture fsm of serial_controller is
    type state_t is (
        idle, byte1, wait1, byte2, wait2, byte3
    );

    component edge_detector is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component; 

    component tx is
        generic (baudrate     : integer := 115200);
        port (
            clock		: in  std_logic;							
            reset		: in  std_logic;							
            partida		: in  std_logic;							
            dado		: in  std_logic_vector(7 downto 0);	
            sout		: out std_logic;							
            out_dado	: out std_logic_vector(7 downto 0);	
            pronto		: out std_logic							
        );
    end component;

    signal Eatual    : state_t;
    signal Eprox     : state_t;
    signal start     : std_logic;
    signal dado      : std_logic_vector(7 downto 0);
    signal tx_pronto : std_logic;
    signal sel_dado  : std_logic_vector(1 downto 0);
    signal tx_partida : std_logic;
begin
    EDGE: edge_detector
    port map (
        clock => clock,
        reset => reset,
        sinal => not_clock1khz,
        pulso => start
    );

    TRAN: tx
    port map (
        clock => clock,
        reset => reset,
        partida => tx_partida,
        dado => dado,
        sout => sout,
        out_dado => open,
        pronto => tx_pronto
    );

    transition: process(clock, reset)
        begin
        if reset = '1' then
            Eatual <= idle;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox;
        end if;
    end process;

    control: process(Eatual, start, tx_pronto)
        begin
        tx_partida <= '0';
        sel_dado <= "00";

        case Eatual is
        when idle =>
            if start = '0' then
                Eprox <= idle;
            else
                Eprox <= byte1;
            end if;

        when byte1 =>
            tx_partida <= '1';
            sel_dado <= "00";

            if tx_pronto = '1' then
                Eprox <= wait1;
            else
                Eprox <= byte1;
            end if;

        when wait1 =>
            if tx_pronto = '0' then
                Eprox <= byte2;
            else
                Eprox <= wait1;
            end if;

        when byte2 =>
            tx_partida <= '1';
            sel_dado <= "01";

            if tx_pronto = '1' then
                Eprox <= wait2;
            else
                Eprox <= byte2;
            end if;

        when wait2 =>
            if tx_pronto = '0' then
                Eprox <= byte3;
            else
                Eprox <= wait2;
            end if;

        when byte3 =>
            tx_partida <= '1';
            sel_dado <= "10";

            if tx_pronto = '1' then
                Eprox <= idle;
            else
                Eprox <= byte3;
            end if;
        end case;
    end process;

    with sel_dado select dado <=
        bytes(7 downto 0) when "00",
        bytes(15 downto 8) when "01",
        bytes(23 downto 16) when "10",
        "00000000" when others;
end architecture;
